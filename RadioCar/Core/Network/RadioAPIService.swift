//
//  RadioAPIService.swift
//  RadioCar
//
//  Created by Maestro Master on 24/06/2025.
//
import Foundation

final class RadioAPIService {
    private let session: URLSession
    private let baseURL = URL(string: "https://de1.api.radio-browser.info")!

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "User-Agent": "RadioCar/2.0 (radiocar.tunes@gmail.com)"
        ]
        self.session = URLSession(configuration: configuration)
    }

    // 1. Fetch stations by country
    func fetchStations(
        country: String = "UA",
        offset: Int = 0,
        limit: Int = 200
    ) async throws -> [Station] {
        print("fetchStations")
        let url = baseURL
            .appendingPathComponent("/json/stations/search")
            .appending(queryItems: [
                .init(name: "countrycode", value: country),
                .init(name: "offset", value: "\(offset)"),
                .init(name: "limit", value: "\(limit)"),
                .init(name: "order", value: "votes"),
                .init(name: "reverse", value: "true")
            ])
        return try await sendRequest(url: url)
    }

    // 2. Fetch stations by name
    func fetchStationsByName(
        searchTerm: String,
        offset: Int = 0,
        limit: Int = 200
    ) async throws -> [Station] {
        print("fetchStationsByName")
        let url = baseURL
            .appendingPathComponent("/json/stations/byname/\(searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")")
            .appending(queryItems: [
                .init(name: "offset", value: "\(offset)"),
                .init(name: "limit", value: "\(limit)"),
                .init(name: "order", value: "votes"),
                .init(name: "reverse", value: "true")
            ])
        return try await sendRequest(url: url)
    }

    // 3. Full-featured search (like getStationsExt)
    func fetchStationsExt(
        country: String = "UA",
        name: String = "",
        tag: String = "",
        offset: Int = 0,
        limit: Int = 200,
        order: String = "votes",
        reverse: String = "true"
    ) async throws -> [Station] {
        print("fetchStationsExt")
        let url = baseURL
            .appendingPathComponent("/json/stations/search")
            .appending(queryItems: [
                .init(name: "countrycode", value: country),
                .init(name: "name", value: name),
                .init(name: "tag", value: tag),
                .init(name: "offset", value: "\(offset)"),
                .init(name: "limit", value: "\(limit)"),
                .init(name: "order", value: order),
                .init(name: "reverse", value: reverse)
            ])
        return try await sendRequest(url: url)
    }

    // MARK: - Private
    private func sendRequest(url: URL) async throws -> [Station] {
        let startTime = Date()
        let (data, response) = try await session.data(from: url)
        let endTime = Date()
        let duration = endTime.timeIntervalSince(startTime) * 1000

        if let httpResponse = response as? HTTPURLResponse {
            print("➡️ Request to \(url.absoluteString)")
            print("⬅️ Response (\(httpResponse.statusCode)) in \(duration) ms")
        }

        if let json = String(data: data, encoding: .utf8) {
            print("🧾 Body: \(json.prefix(500))...")
        }

        do {
            return try JSONDecoder().decode([Station].self, from: data)
        } catch {
            // Логування повного json для діагностики
            if let jsonString = String(data: data, encoding: .utf8) {
                print("❌ JSON decoding failed for response: \(jsonString.prefix(1000))")
            }
            // Логування самої помилки
            print("❌ Decoding error: \(error)")

            // Можна додатково кастомізувати помилку (наприклад, прокидати кастомну або просто повторно кинути)
            throw error
        }
    }

}


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

    // MARK: - Public API

    func fetchStations(
        country: String = "UA",
        offset: Int = 0,
        limit: Int = 200
    ) async throws -> [Station] {
        print("fetchStations")
        let query: [String: String] = [
            "countrycode": country,
            "offset": "\(offset)",
            "limit": "\(limit)",
            "order": "votes",
            "reverse": "true"
        ]
        let url = try buildURL(path: "/json/stations/search", queryItems: query)
        return try await sendRequest(url: url)
    }

    func fetchStationsByName(
        searchTerm: String,
        offset: Int = 0,
        limit: Int = 200
    ) async throws -> [Station] {
        print("fetchStationsByName")
        let encodedTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let path = "/json/stations/byname/\(encodedTerm)"
        let query: [String: String] = [
            "offset": "\(offset)",
            "limit": "\(limit)",
            "order": "votes",
            "reverse": "true"
        ]
        let url = try buildURL(path: path, queryItems: query)
        return try await sendRequest(url: url)
    }

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
        let query: [String: String] = [
            "countrycode": country,
            "name": name,
            "tag": tag,
            "offset": "\(offset)",
            "limit": "\(limit)",
            "order": order,
            "reverse": reverse
        ]
        let url = try buildURL(path: "/json/stations/search", queryItems: query)
        return try await sendRequest(url: url)
    }

    // MARK: - Private helpers

    private func buildURL(path: String, queryItems: [String: String]) throws -> URL {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = components?.url else {
            throw URLError(.badURL)
        }

        return url
    }

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
            if let jsonString = String(data: data, encoding: .utf8) {
                print("❌ JSON decoding failed for response: \(jsonString.prefix(1000))")
            }
            print("❌ Decoding error: \(error)")
            throw error
        }
    }
}

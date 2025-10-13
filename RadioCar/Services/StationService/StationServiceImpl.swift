//
//  StationServiceImpl.swift
//  RadioCar
//
//  Created by Maestro Master on 24/06/2025.
//
import Foundation

class StationServiceImpl: StationService {
    private let baseURL = URL(string: "https://de2.api.radio-browser.info")! //  BASE_RADIO_URL
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    private func makeRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("RadioCar/2.0 (radiocar.tunes@gmail.com)", forHTTPHeaderField: "User-Agent")
        return request
    }

    private func fetchStations(url: URL) async throws -> [Station] {
        let request = makeRequest(url: url)
        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode([Station].self, from: data)
    }

    func getStationsExt(
        country: String = "UA",
        name: String = "",
        tag: String = "",
        offset: Int = 0,
        limit: Int = 200
    ) async throws -> [Station] {
        var components = URLComponents(url: baseURL.appendingPathComponent("/json/stations/search"), resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "countrycode", value: country),
            URLQueryItem(name: "name", value: name),
            URLQueryItem(name: "tag", value: tag),
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "limit", value: String(limit)),
        ]
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        return try await fetchStations(url: url)
    }

    func getStations(
        country: String = "UA",
        offset: Int = 0,
        limit: Int = 200
    ) async throws -> [Station] {
        var components = URLComponents(url: baseURL.appendingPathComponent("/json/stations/search"), resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "countrycode", value: country),
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "limit", value: String(limit)),
        ]
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        return try await fetchStations(url: url)
    }

    func getStationsByName(
        searchTerm: String,
        offset: Int = 0,
        limit: Int = 200
    ) async throws -> [Station] {
        let endpoint = "/json/stations/byname/\(searchTerm)"
        var components = URLComponents(url: baseURL.appendingPathComponent(endpoint), resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "limit", value: String(limit)),
        ]
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        return try await fetchStations(url: url)
    }
}


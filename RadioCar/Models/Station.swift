//
//  Station.swift
//  RadioCar
//
//  Created by Maestro Master on 24/06/2025.
//

import Foundation

import Foundation

struct Station: Identifiable, Codable {
    var id: String { stationuuid ?? UUID().uuidString }

    let stationuuid: String?
    let bitrate: Int?
    let changeuuid: String?
    let serveruuid: String?
    let clickcount: Int?
    let clicktimestamp: String?
    let clicktrend: Int?
    let codec: String?
    let country: String?
    let countrycode: String?
    let favicon: String?
    let geo_lat: Double?
    let geo_long: Double?
    let has_extended_info: Bool?
    let hls: Int?
    let homepage: String?
    let iso_3166_2: String?
    let language: String?
    let languagecodes: String?
    let lastchangetime: String?
    let lastchangetime_iso8601: String?
    let lastcheckok: Int?
    let lastcheckoktime: String?
    let lastcheckoktime_iso8601: String?
    let lastchecktime: String?
    let lastchecktime_iso8601: String?
    let lastlocalchecktime: String?
    let lastlocalchecktime_iso8601: String?
    let name: String?
    let ssl_error: Int?
    let state: String?
    let tags: String?
    let url: String?
    let url_resolved: String?
    let votes: Int?

    var isFavorite: Bool = false
    var isRecent: Bool = false

    enum CodingKeys: String, CodingKey {
        case bitrate, changeuuid, serveruuid, clickcount, clicktimestamp, clicktrend, codec,
             country, countrycode, favicon, geo_lat, geo_long, has_extended_info, hls,
             homepage, iso_3166_2, language, languagecodes, lastchangetime, lastchangetime_iso8601,
             lastcheckok, lastcheckoktime, lastcheckoktime_iso8601, lastchecktime, lastchecktime_iso8601,
             lastlocalchecktime, lastlocalchecktime_iso8601, name, ssl_error, state, stationuuid,
             tags, url, url_resolved, votes
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        stationuuid = try? container.decodeIfPresent(String.self, forKey: .stationuuid)
        bitrate = try? container.decodeIfPresent(Int.self, forKey: .bitrate)
        changeuuid = try? container.decodeIfPresent(String.self, forKey: .changeuuid)
        serveruuid = try? container.decodeIfPresent(String.self, forKey: .serveruuid)
        clickcount = try? container.decodeIfPresent(Int.self, forKey: .clickcount)
        clicktimestamp = try? container.decodeIfPresent(String.self, forKey: .clicktimestamp)
        clicktrend = try? container.decodeIfPresent(Int.self, forKey: .clicktrend)
        codec = try? container.decodeIfPresent(String.self, forKey: .codec)
        country = try? container.decodeIfPresent(String.self, forKey: .country)
        countrycode = try? container.decodeIfPresent(String.self, forKey: .countrycode)
        favicon = try? container.decodeIfPresent(String.self, forKey: .favicon)
        geo_lat = try? container.decodeIfPresent(Double.self, forKey: .geo_lat)
        geo_long = try? container.decodeIfPresent(Double.self, forKey: .geo_long)
        has_extended_info = try? container.decodeIfPresent(Bool.self, forKey: .has_extended_info)
        hls = try? container.decodeIfPresent(Int.self, forKey: .hls)
        homepage = try? container.decodeIfPresent(String.self, forKey: .homepage)
        iso_3166_2 = try? container.decodeIfPresent(String.self, forKey: .iso_3166_2)
        language = try? container.decodeIfPresent(String.self, forKey: .language)
        languagecodes = try? container.decodeIfPresent(String.self, forKey: .languagecodes)
        lastchangetime = try? container.decodeIfPresent(String.self, forKey: .lastchangetime)
        lastchangetime_iso8601 = try? container.decodeIfPresent(String.self, forKey: .lastchangetime_iso8601)
        lastcheckok = try? container.decodeIfPresent(Int.self, forKey: .lastcheckok)
        lastcheckoktime = try? container.decodeIfPresent(String.self, forKey: .lastcheckoktime)
        lastcheckoktime_iso8601 = try? container.decodeIfPresent(String.self, forKey: .lastcheckoktime_iso8601)
        lastchecktime = try? container.decodeIfPresent(String.self, forKey: .lastchecktime)
        lastchecktime_iso8601 = try? container.decodeIfPresent(String.self, forKey: .lastchecktime_iso8601)
        lastlocalchecktime = try? container.decodeIfPresent(String.self, forKey: .lastlocalchecktime)
        lastlocalchecktime_iso8601 = try? container.decodeIfPresent(String.self, forKey: .lastlocalchecktime_iso8601)
        name = try? container.decodeIfPresent(String.self, forKey: .name)
        ssl_error = try? container.decodeIfPresent(Int.self, forKey: .ssl_error)
        state = try? container.decodeIfPresent(String.self, forKey: .state)
        tags = try? container.decodeIfPresent(String.self, forKey: .tags)
        url = try? container.decodeIfPresent(String.self, forKey: .url)
        url_resolved = try? container.decodeIfPresent(String.self, forKey: .url_resolved)
        votes = try? container.decodeIfPresent(Int.self, forKey: .votes)
    }
}

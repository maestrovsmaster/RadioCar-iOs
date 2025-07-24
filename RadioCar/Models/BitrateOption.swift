//
//  BitrateOption.swift
//  RadioCar
//
//  Created by Maestro Master on 24/06/2025.
//
enum BitrateOption: Int, Codable, CaseIterable {
    case veryLow = 32
    case low = 64
    case standard = 128
    case high = 192
    case hd = 320

    var displayName: String {
        switch self {
        case .hd: return "HD Quality"
        case .high: return "High Quality"
        case .standard: return "Standard"
        case .low: return "Low Quality"
        case .veryLow: return "Very Low Quality"
        }
    }

    static func from(_ value: Int) -> BitrateOption {
        BitrateOption.allCases.min(by: { abs($0.rawValue - value) < abs($1.rawValue - value) }) ?? .standard
    }
}


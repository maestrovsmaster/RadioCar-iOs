//
//  PlayerState.swift
//  RadioCar
//
//  Created by Maestro Master on 24/07/2025.
//
import Foundation
import Combine
import AVFoundation

final class PlayerState: ObservableObject {
    static let shared = PlayerState()

    @Published var currentStation: Station?
    @Published var isPlaying: Bool = false

    private init() {}

    func playStation(_ station: Station) {
        if currentStation?.id != station.id {
            currentStation = station
        }
        isPlaying = true
    }

    func pause() {
        isPlaying = false
    }

    func stop() {
        isPlaying = false
        currentStation = nil
    }
}

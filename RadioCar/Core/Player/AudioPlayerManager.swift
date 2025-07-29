//
//  ExoPlayerManager.swift
//  RadioCar
//
//  Created by Maestro Master on 23/07/2025.
//
import Foundation
import AVFoundation
import MediaPlayer
import Combine

protocol AudioPlayerListener: AnyObject {
    func onPlayEvent(_ action: PlayAction)
    func onSongMetadata(_ title: String)
    func onSetAudioPlayerSessionId(_ sessionId: UInt32)
}

enum PlayAction {
    case play, pause, stop, buffering(Bool), error(String?), next, previous
}



final class AudioPlayerManager: NSObject {
    static let shared = AudioPlayerManager()
    
    private var player: AVPlayer?
    private var subscriptions = Set<AnyCancellable>()
    
    private override init() {
        super.init()
        setupAudioSession()
        setupRemoteCommandCenter()
        observePlayerState()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to activate audio session: \(error)")
        }
    }
    
    private func observePlayerState() {
        print("observePlayerState ")
        PlayerState.shared.$currentStation
            .sink { [weak self] station in
                guard let station = station else {
                    self?.stop()
                    return
                }
                self?.playStation(station)
            }
            .store(in: &subscriptions)
        
        PlayerState.shared.$isPlaying
            .sink { [weak self] playing in
                print("observePlayerState >>>")
                if playing {
                    self?.player?.play()
                } else {
                    self?.player?.pause()
                }
            }
            .store(in: &subscriptions)
        
        PlayerState.shared.$volume
            .sink { [weak self] volume in
                self?.player?.volume = volume
            }
            .store(in: &subscriptions)
    }
    
    private func playStation(_ station: Station) {
        guard let url = URL(string: station.url_resolved ?? "") else {
            print("Invalid station URL")
            return
        }
        
        if player == nil || player?.currentItem?.asset != AVAsset(url: url) {
            player = AVPlayer(url: url)
            self.updateNowPlayingInfo(title: station.name ?? "Radio", artist: "")
        }
        
        player?.play()
    }
    
    func pause() {
        player?.pause()
        PlayerState.shared.isPlaying = false
    }
    
    func stop() {
        player?.pause()
        player = nil
            //  PlayerState.shared.isPlaying = false
       // PlayerState.shared.currentStation = nil
    }
    
    private func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { [weak self] _ in
            DispatchQueue.main.async {
                PlayerState.shared.isPlaying = true
            }
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { [weak self] _ in
            DispatchQueue.main.async {
                PlayerState.shared.isPlaying = false
            }
            return .success
        }
        
        commandCenter.nextTrackCommand.addTarget { _ in
            NotificationCenter.default.post(name: .nextTrackRequested, object: nil)
            return .success
        }
        
        commandCenter.previousTrackCommand.addTarget { _ in
            NotificationCenter.default.post(name: .previousTrackRequested, object: nil)
            return .success
        }
    }
    
    
    private func updateNowPlayingInfo(title: String, artist: String? = nil) {
        var nowPlayingInfo: [String: Any] = [
            MPMediaItemPropertyTitle: title
        ]
        if let artist = artist {
            nowPlayingInfo[MPMediaItemPropertyArtist] = artist
        }

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
}

extension Notification.Name {
    static let nextTrackRequested = Notification.Name("nextTrackRequested")
    static let previousTrackRequested = Notification.Name("previousTrackRequested")
}

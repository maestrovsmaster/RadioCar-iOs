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
    private var isObservingPlayer = false
    private var isObservingPlayerItem = false
    
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
                guard let self = self, let player = self.player else { return }

                // Only control player if the state change was initiated by user action
                // (not from our own observer updates)
                let currentlyPlaying = player.timeControlStatus == .playing

                if playing && !currentlyPlaying {
                    print("▶️ User action: Play")
                    player.play()
                } else if !playing && currentlyPlaying {
                    print("⏸️ User action: Pause")
                    player.pause()
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
            PlayerState.shared.isBuffering = false
            return
        }

        // Remove old observers if player exists
        if isObservingPlayer, let oldPlayer = player {
            oldPlayer.removeObserver(self, forKeyPath: "timeControlStatus")
            isObservingPlayer = false
        }
        if isObservingPlayerItem, let oldItem = player?.currentItem {
            oldItem.removeObserver(self, forKeyPath: "status")
            isObservingPlayerItem = false
        }

        if player == nil || player?.currentItem?.asset != AVAsset(url: url) {
            let playerItem = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: playerItem)

            // Observe player status
            player?.addObserver(self, forKeyPath: "timeControlStatus", options: [.new, .old], context: nil)
            isObservingPlayer = true

            playerItem.addObserver(self, forKeyPath: "status", options: [.new, .old], context: nil)
            isObservingPlayerItem = true

            self.updateNowPlayingInfo(title: station.name ?? "Radio", artist: "")
        }

        PlayerState.shared.isBuffering = true
        player?.play()
    }
    
    func pause() {
        player?.pause()
        PlayerState.shared.isPlaying = false
    }
    
    func stop() {
        // Remove observers safely
        if isObservingPlayer, let player = player {
            player.removeObserver(self, forKeyPath: "timeControlStatus")
            isObservingPlayer = false
        }
        if isObservingPlayerItem, let playerItem = player?.currentItem {
            playerItem.removeObserver(self, forKeyPath: "status")
            isObservingPlayerItem = false
        }

        player?.pause()
        player = nil
    }

    // Observe player state changes
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "timeControlStatus" {
            if let player = player {
                DispatchQueue.main.async {
                    switch player.timeControlStatus {
                    case .playing:
                        PlayerState.shared.isPlaying = true
                        PlayerState.shared.isBuffering = false
                        print("🎵 Player is PLAYING")
                    case .paused:
                        PlayerState.shared.isPlaying = false
                        PlayerState.shared.isBuffering = false
                        print("🎵 Player is PAUSED")
                    case .waitingToPlayAtSpecifiedRate:
                        PlayerState.shared.isPlaying = false
                        PlayerState.shared.isBuffering = true
                        print("🎵 Player is BUFFERING")
                    @unknown default:
                        break
                    }
                }
            }
        } else if keyPath == "status" {
            if let playerItem = object as? AVPlayerItem {
                DispatchQueue.main.async {
                    switch playerItem.status {
                    case .readyToPlay:
                        print("🎵 Player item READY")
                    case .failed:
                        print("⚠️ Player item FAILED: \(playerItem.error?.localizedDescription ?? "unknown")")
                        PlayerState.shared.isPlaying = false
                        PlayerState.shared.isBuffering = false
                    case .unknown:
                        print("🎵 Player item UNKNOWN")
                    @unknown default:
                        break
                    }
                }
            }
        }
    }
    
    private func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { _ in
            DispatchQueue.main.async {
                PlayerState.shared.isPlaying = true
            }
            return .success
        }

        commandCenter.pauseCommand.addTarget { _ in
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

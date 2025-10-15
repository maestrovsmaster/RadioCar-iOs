//
//  ICYMetadataFetcher.swift
//  RadioCar
//
//  Created by Maestro Master on 28/07/2025.
//
import Foundation

final class ICYMetadataFetcher: NSObject, URLSessionDataDelegate {

    static let shared = ICYMetadataFetcher()

    private let dataQueue = DispatchQueue(label: "com.radiocar.metadata", qos: .userInitiated)
    private var metadataInterval: Int = 0
    private var receivedData = Data()
    private var bytesRead = 0
    private var currentStreamTask: URLSessionDataTask?
    private var session: URLSession?
    private var lastMetadata: String = ""
    private var metadataTimeoutTimer: Timer?
    private var hasReceivedMetadata = false

    private let metadataTimeout: TimeInterval = 30.0 // 30 seconds

    override private init() {
        super.init()
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
    }

    func fetchMetadata(from url: URL) {
        // Stop previous task
        stopFetching()

        // Reset state
        metadataInterval = 0
        receivedData = Data()
        bytesRead = 0
        lastMetadata = ""
        hasReceivedMetadata = false

        var request = URLRequest(url: url)
        request.setValue("1", forHTTPHeaderField: "Icy-MetaData")
        request.httpShouldUsePipelining = true

        currentStreamTask = session?.dataTask(with: request)
        currentStreamTask?.resume()

        // Start timeout timer
        startMetadataTimeout()

        print("🎵 Started fetching metadata from: \(url)")
    }

    func stopFetching() {
        currentStreamTask?.cancel()
        currentStreamTask = nil
        cancelMetadataTimeout()
    }

    private func startMetadataTimeout() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            // Cancel existing timer
            self.metadataTimeoutTimer?.invalidate()
            self.metadataTimeoutTimer = nil

            self.metadataTimeoutTimer = Timer.scheduledTimer(withTimeInterval: self.metadataTimeout, repeats: false) { [weak self] _ in
                guard let self = self else { return }

                if !self.hasReceivedMetadata {
                    print("⏱️ Metadata timeout - no metadata received in \(self.metadataTimeout)s")
                    // Clear "Loading metadata..." state
                    if PlayerState.shared.songMetadata == nil {
                        PlayerState.shared.songMetadata = ""
                    }
                    self.stopFetching()
                }
            }
        }
    }

    private func cancelMetadataTimeout() {
        DispatchQueue.main.async { [weak self] in
            self?.metadataTimeoutTimer?.invalidate()
            self?.metadataTimeoutTimer = nil
        }
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {

        if let httpResponse = response as? HTTPURLResponse {
            print("🎵 Response headers: \(httpResponse.allHeaderFields)")

            // Try different header key variations
            let possibleKeys = ["icy-metaint", "Icy-MetaInt", "ICY-MetaInt"]

            for key in possibleKeys {
                if let icyMetaInt = httpResponse.allHeaderFields[key] as? String,
                   let interval = Int(icyMetaInt) {
                    metadataInterval = interval
                    print("🎵 Found metadata interval: \(interval)")
                    break
                }
            }

            if metadataInterval == 0 {
                print("⚠️ No metadata interval found in headers")
            }
        }

        completionHandler(.allow)
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        dataQueue.async { [weak self] in
            guard let self = self else { return }

            self.receivedData.append(data)
            self.bytesRead += data.count

            guard self.metadataInterval > 0 else { return }

            // Process metadata blocks
            while true {
                // Need at least: metadataInterval (audio) + 1 (length byte)
                guard self.receivedData.count > self.metadataInterval else { break }

                // Skip audio data (we don't need it)
                self.receivedData.removeFirst(self.metadataInterval)

                // Peek at the metadata length byte without removing it yet
                // Use safe access to avoid out-of-bounds crash
                guard let metadataLengthByte = self.receivedData.first else { break }
                let metadataLength = Int(metadataLengthByte) * 16

                // Check if we have enough data for the complete metadata block
                // We need: 1 byte (length) + metadataLength bytes (actual metadata)
                guard self.receivedData.count >= (1 + metadataLength) else {
                    // Not enough data yet, wait for more
                    break
                }

                // Now we can safely remove the length byte
                self.receivedData.removeFirst()

                // If no metadata, continue to next block
                if metadataLength == 0 {
                    continue
                }

                // Extract metadata (we already confirmed we have enough data)
                let metadataBytes = self.receivedData.prefix(metadataLength)
                self.receivedData.removeFirst(metadataLength)

                // Parse metadata
                if let metadataString = String(data: metadataBytes, encoding: .utf8)?.trimmingCharacters(in: .controlCharacters),
                   let title = self.parseTitle(from: metadataString),
                   !title.isEmpty,
                   title != self.lastMetadata {
                    self.lastMetadata = title
                    self.hasReceivedMetadata = true
                    print("🎵 New metadata: \(title)")

                    DispatchQueue.main.async {
                        PlayerState.shared.songMetadata = title
                    }

                    // Cancel timeout since we received metadata
                    DispatchQueue.main.async {
                        self.cancelMetadataTimeout()
                    }
                }
            }
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print("⚠️ Metadata fetch error: \(error.localizedDescription)")
        }
    }

    private func parseTitle(from icyString: String) -> String? {
        // Parse StreamTitle='Artist - Song';
        let components = icyString.components(separatedBy: ";")
        for component in components {
            if component.contains("StreamTitle") {
                let parts = component.components(separatedBy: "'")
                if parts.count >= 2 {
                    let title = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    return title.isEmpty ? nil : title
                }
            }
        }
        return nil
    }
}


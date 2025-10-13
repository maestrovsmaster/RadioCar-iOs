//
//  ICYMetadataFetcher.swift
//  RadioCar
//
//  Created by Maestro Master on 28/07/2025.
//
import Foundation

final class ICYMetadataFetcher: NSObject, URLSessionDataDelegate {

    static let shared = ICYMetadataFetcher()

    private var metadataInterval: Int = 0
    private var receivedData = Data()
    private var bytesRead = 0
    private var currentStreamTask: URLSessionDataTask?
    private var session: URLSession?
    private var lastMetadata: String = ""

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

        var request = URLRequest(url: url)
        request.setValue("1", forHTTPHeaderField: "Icy-MetaData")
        request.httpShouldUsePipelining = true

        currentStreamTask = session?.dataTask(with: request)
        currentStreamTask?.resume()

        print("🎵 Started fetching metadata from: \(url)")
    }

    func stopFetching() {
        currentStreamTask?.cancel()
        currentStreamTask = nil
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
        receivedData.append(data)
        bytesRead += data.count

        guard metadataInterval > 0 else { return }

        // Process metadata blocks
        while receivedData.count > metadataInterval {
            // Need at least: metadataInterval (audio) + 1 (length byte)
            guard receivedData.count > metadataInterval else { break }

            // Skip audio data (we don't need it)
            receivedData.removeFirst(metadataInterval)

            // Read metadata length byte
            guard receivedData.count > 0 else { break }
            let metadataLengthByte = receivedData.removeFirst()
            let metadataLength = Int(metadataLengthByte) * 16

            // If no metadata, continue to next block
            if metadataLength == 0 {
                continue
            }

            // Wait for full metadata block
            guard receivedData.count >= metadataLength else {
                // Not enough data yet, put the length byte back and wait
                receivedData.insert(metadataLengthByte, at: 0)
                break
            }

            // Extract metadata
            let metadataBytes = receivedData.prefix(metadataLength)
            receivedData.removeFirst(metadataLength)

            // Parse metadata
            if let metadataString = String(data: metadataBytes, encoding: .utf8)?.trimmingCharacters(in: .controlCharacters),
               let title = parseTitle(from: metadataString),
               !title.isEmpty,
               title != lastMetadata {
                lastMetadata = title
                print("🎵 New metadata: \(title)")

                DispatchQueue.main.async {
                    PlayerState.shared.songMetadata = title
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


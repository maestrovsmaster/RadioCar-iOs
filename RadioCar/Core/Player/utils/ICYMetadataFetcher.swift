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

    func fetchMetadata(from url: URL) {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)

        var request = URLRequest(url: url)
        request.setValue("1", forHTTPHeaderField: "Icy-MetaData")

        currentStreamTask = session.dataTask(with: request)
        currentStreamTask?.resume()
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        receivedData.append(data)

        if metadataInterval == 0 {
            if let headers = (dataTask.response as? HTTPURLResponse)?.allHeaderFields {
                if let icyMetaInt = headers["icy-metaint"] as? String,
                   let interval = Int(icyMetaInt) {
                    metadataInterval = interval
                }
            }
        }

        while metadataInterval > 0 && receivedData.count > metadataInterval {
            guard receivedData.count > metadataInterval else { break }

            let index = receivedData.index(receivedData.startIndex, offsetBy: metadataInterval)
            let metadataLengthByte = receivedData[index]
            let metadataLength = Int(metadataLengthByte) * 16

            if metadataLength == 0 || receivedData.count < metadataInterval + 1 + metadataLength {
                break
            }

            let metadataStartIndex = receivedData.index(index, offsetBy: 1)
            let metadataEndIndex = receivedData.index(metadataStartIndex, offsetBy: metadataLength)

            let metadataBytes = receivedData[metadataStartIndex..<metadataEndIndex]

            if let metadataString = String(data: metadataBytes, encoding: .utf8),
               let title = self.parseTitle(from: metadataString) {
                DispatchQueue.main.async {
                    PlayerState.shared.songMetadata = title
                }
            }

            receivedData.removeSubrange(receivedData.startIndex..<metadataEndIndex)
        }


    }

    private func parseTitle(from icyString: String) -> String? {
        let components = icyString.components(separatedBy: ";")
        for component in components {
            if component.contains("StreamTitle") {
                let parts = component.components(separatedBy: "'")
                if parts.count > 1 {
                    return parts[1]
                }
            }
        }
        return nil
    }
}


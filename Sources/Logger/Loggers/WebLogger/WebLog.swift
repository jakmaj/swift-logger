//
//  LogEntry.swift
//  
//
//  Created by Martin Troup on 29.09.2021.
//

import Foundation

struct WebLog {
    let level: Level
    let timestamp: Double
    let message: CustomStringConvertible
    let sessionID: UUID
}

// MARK: - WebLog + Encodable

extension WebLog: Encodable {
    enum CodingKeys: String, CodingKey {
        case level = "severity"
        case timestamp
        case message
        case sessionID = "sessionName"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(serverLevelName(for: level), forKey: .level)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(message.description, forKey: .message)
        try container.encode(sessionID.uuidString, forKey: .sessionID)
    }

    private func serverLevelName(for level: Level) -> String {
        switch level {
        case .warn:
            return "WARNING"
        case .system, .process:
            return "INFO"
        default:
            return level.rawValue.uppercased()
        }
    }
}

// MARK: - LogEntryBatch

typealias LogEntryBatch = Array<WebLog>

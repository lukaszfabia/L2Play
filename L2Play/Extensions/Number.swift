//
//  Number.swift
//  L2Play
//
//  Created by Lukasz Fabia on 21/11/2024.
//

import Foundation

extension Int {
    func shorterNumber() -> String {
        switch self {
        case 0..<100_000:
            return "\(self)"
        case 100_000..<1_000_000:
            return String(format: "%.1fk", Double(self) / 1_000).replacingOccurrences(of: ".0", with: "")
        default:
            return String(format: "%.1fmln", Double(self) / 1_000_000).replacingOccurrences(of: ".0", with: "")
        }
    }
}

extension Double {
    func formatTimestamp() -> String {
        let date = Date(timeIntervalSince1970: self)
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
}

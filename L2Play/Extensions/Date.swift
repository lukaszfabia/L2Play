//
//  Date.swift
//  L2Play
//
//  Created by Lukasz Fabia on 21/11/2024.
//

import Foundation

extension Date {
    func timeAgoSinceDate() -> String {
        let now = Date()
        let secondsBetween = now.timeIntervalSince(self)
        
        let minutes = Int(secondsBetween / 60)
        let hours = minutes / 60
        let days = hours / 24
        let weeks = days / 7
        let months = days / 30
        let years = days / 365
        
        switch true {
        case years >= 1:
            return "\(years) year\(years > 1 ? "s" : "") ago"
        case months >= 1:
            return "\(months) month\(months > 1 ? "s" : "") ago"
        case weeks >= 1:
            return "\(weeks) week\(weeks > 1 ? "s" : "") ago"
        case days >= 1:
            return "\(days) day\(days > 1 ? "s" : "") ago"
        case hours >= 1:
            return "\(hours) hour\(hours > 1 ? "s" : "") ago"
        case minutes >= 1:
            return "\(minutes) minute\(minutes > 1 ? "s" : "") ago"
        default:
            let seconds = Int(secondsBetween)
            return "\(seconds) second\(seconds > 1 ? "s" : "") ago"
        }
    }
    
    func getMonthAndYear() -> String? {
        let dateFormatter = DateFormatter()
         
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMrrrr")
        
        let tokens = dateFormatter.string(from: self).split(separator: " ")
        
        if let lhs = tokens.first, let rhs = tokens.dropFirst().first {
            return "\(String(lhs.prefix(3))). \(rhs)"
        }
        
        return nil
    }
}

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
               return String(format: NSLocalizedString(years > 1 ? "year_plural_ago" : "year_ago", comment: ""), years)
           case months >= 1:
               return String(format: NSLocalizedString(months > 1 ? "month_plural_ago" : "month_ago", comment: ""), months)
           case weeks >= 1:
               return String(format: NSLocalizedString(weeks > 1 ? "week_plural_ago" : "week_ago", comment: ""), weeks)
           case days >= 1:
               return String(format: NSLocalizedString(days > 1 ? "day_plural_ago" : "day_ago", comment: ""), days)
           case hours >= 1:
               return String(format: NSLocalizedString(hours > 1 ? "hour_plural_ago" : "hour_ago", comment: ""), hours)
           case minutes >= 1:
               return String(format: NSLocalizedString(minutes > 1 ? "minute_plural_ago" : "minute_ago", comment: ""), minutes)
           default:
               let seconds = Int(secondsBetween)
               return String(format: NSLocalizedString(seconds > 1 ? "second_plural_ago" : "second_ago", comment: ""), seconds)
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
    
    func getYear() -> Int {
        let dateFormatter = DateFormatter()
        
        dateFormatter.setLocalizedDateFormatFromTemplate("rrrr")
        
        return Int(dateFormatter.string(from: self))!
    }
}

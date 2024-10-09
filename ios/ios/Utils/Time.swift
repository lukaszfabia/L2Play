//
//  Time.swift
//  ios
//
//  Created by Lukasz Fabia on 09/10/2024.
//

import Foundation

func timeAgoSinceDateSimple(_ date: Date) -> String {
    let now = Date()
    let secondsBetween = now.timeIntervalSince(date)
    let minutes = secondsBetween / 60
    let hours = minutes / 60
    let days = hours / 24
    let weeks = days / 7
    let months = days / 30
    let years = days / 365
    
    if years >= 1 {
        return "\(Int(years)) year\(years > 1 ? "s" : "") ago"
    } else if months >= 1 {
        return "\(Int(months)) month\(months > 1 ? "s" : "") ago"
    } else if weeks >= 1 {
        return "\(Int(weeks)) week\(weeks > 1 ? "s" : "") ago"
    } else if days >= 1 {
        return "\(Int(days)) day\(days > 1 ? "s" : "") ago"
    } else if hours >= 1 {
        return "\(Int(hours)) hour\(hours > 1 ? "s" : "") ago"
    } else if minutes >= 1 {
        return "\(Int(minutes)) minute\(minutes > 1 ? "s" : "") ago"
    } else {
        return "\(Int(secondsBetween)) second\(secondsBetween > 1 ? "s" : "") ago"
    }
}

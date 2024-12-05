//
//  ReportedContent.swift
//  L2Play
//
//  Created by Lukasz Fabia on 01/12/2024.
//

import Foundation


enum ReportReason: String, Codable {
    case hateSpeech = "Hate Speech"
    case spam = "Spam"
    case misinformation = "Misinformation"
    case privacyViolation = "Privacy Violation"
    case inappropriateContent = "Inappropriate Content"
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        
        switch value {
        case "Hate Speech":
            self = .hateSpeech
        case "Spam":
            self = .spam
        case "Misinformation":
            self = .misinformation
        case "Privacy Violation":
            self = .privacyViolation
        case "Inappropriate Content":
            self = .inappropriateContent
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown report reason")
        }
    }
}

let reportReasons : [ReportReason] = [
    ReportReason.hateSpeech,
    ReportReason.spam,
    ReportReason.misinformation,
    ReportReason.privacyViolation,
    ReportReason.inappropriateContent,
]

struct ReportedReview: Codable, Identifiable {
    private(set) var id: UUID = .init()
    private let whoReported: String
    let createdAt: Date
    let reason: ReportReason
    let reviewID: UUID
    
    init(whoReported: String, reason: ReportReason, reviewID: UUID) {
        self.id = .init()
        self.whoReported = whoReported
        self.createdAt = Date()
        self.reason = reason
        self.reviewID = reviewID
    }
}

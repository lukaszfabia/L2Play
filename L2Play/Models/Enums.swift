//
//  Enums.swift
//  L2Play
//
//  Created by Lukasz Fabia on 05/12/2024.
//

import Foundation

enum SortOption: String, Codable, CaseIterable, Identifiable {
    case ascending, descending
    
    var id: String {self.rawValue}
}

enum SortAttributeForGame: String, CaseIterable, Identifiable {
    case name = "Name"
    case studio = "Studio"
    case updatedAt = "Updated at"
    case state = "State"

    var id: String { self.rawValue }
}

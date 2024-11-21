//
//  Tag.swift
//  L2Play
//
//  Created by Lukasz Fabia on 21/11/2024.
//

import Foundation

struct Tag: Codable {
    private(set) var id: UUID = .init()
    let name: String
}

//
//  Array+Extensions.swift
//  L2Play
//
//  Created by Lukasz Fabia on 26/11/2024.
//

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

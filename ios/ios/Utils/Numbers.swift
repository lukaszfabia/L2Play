//
//  Numbers.swift
//  ios
//
//  Created by Lukasz Fabia on 20/10/2024.
//

func shorterNumber(_ number: Int) -> String {
    if number < 100000 {
        return "\(number)"
    } else if number < 1000000 {
        return "\(number / 1000)k"
    }
    
    return "\(number / 1000000)mln"
}

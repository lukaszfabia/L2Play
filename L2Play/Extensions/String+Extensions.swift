//
//  String+Extensions.swift
//  L2Play
//
//  Created by Lukasz Fabia on 26/11/2024.
//

import Foundation

extension String {
    
    /// Takes first word from sentence
    /// Use case: "Ala ma kota".takeFirstWord() -> "Ala"
    /// - Returns: First word in sentence
    func takeFirstWord() -> String {
        guard let res = self.split(whereSeparator: { $0.isWhitespace }).first else {
            return ""
        }
        
        return String(res)
    }
    
    func localized(with arguments: CVarArg...) -> String {
        return String(format: NSLocalizedString(self, comment: ""), arguments: arguments)
    }
}

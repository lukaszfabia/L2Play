//
//  ParseEnvVars.swift
//  L2Play
//
//  Created by Lukasz Fabia on 10/12/2024.
//

import Foundation

enum Plists: String {
    case google_service = "GoogleSerive-Info"
    case cloudinary = "CloudinaryService-Info"
}

class ParseEnvVars {
    static let shared = ParseEnvVars()
    
    func getEnv(from plist: Plists, _ identifier: String) -> String? {
        guard let path = Bundle.main.path(forResource: plist.rawValue, ofType: "plist"),
              let xml = FileManager.default.contents(atPath: path),
              let plist = try? PropertyListSerialization.propertyList(from: xml, options: [], format: nil) as? [String: Any] else {
            print("Unable to read plist.")
            return nil
        }
        
        if let apiKey = plist[identifier] as? String {
            return apiKey
        } else {
            print("Failed to find")
            return nil
        }
    }

}

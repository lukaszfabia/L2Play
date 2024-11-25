//
//  Translator.swift
//  L2Play
//
//  Created by Lukasz Fabia on 23/11/2024.
//

//import Foundation
//import MLKitTranslate
//
//class TranslatorService: ObservableObject {
//    private var targetLang: TranslateLanguage
//    private var t:Translator
//    
//    init() {
//        targetLang = Self.getTargetLanguage()
//        
//        let options = TranslatorOptions(sourceLanguage: .english, targetLanguage: targetLang)
//        self.t = MLKitTranslate.Translator.translator(options: options)
//        
//
//        let conditions = ModelDownloadConditions(
//            allowsCellularAccess: false,
//            allowsBackgroundDownloading: true
//        )
//        
//
//        self.t.downloadModelIfNeeded(with: conditions) { error in
//            guard error == nil else {
//                print("Model download failed: \(String(describing: error))")
//                return
//            }
//            print("Model downloaded successfully")
//        }
//    }
//    
//    private static func getTargetLanguage() -> TranslateLanguage {
//        guard let currentLanguage = NSLocale.current.language.languageCode?.identifier else {
//            return .english
//        }
//        
//        
//        let languageMap: [String: TranslateLanguage] = [
//            "pl": .polish,
//            
//        ]
//        
//        return languageMap[currentLanguage] ?? .english
//    }
//    
//    func translate(text: String) async -> String {
//        do {
//            let res = try await self.t.translate(text)
//            return res
//        } catch {
//            return text
//        }
//    }
//    
//}

    //
    //  Cloudinary.swift
    //  L2Play
    //
    //  Created by Lukasz Fabia on 10/12/2024.
    //

    import Cloudinary
    import SwiftUI


    class CloudinaryService {
        
        static let shared = CloudinaryService()
        private var _cloudinary: Cloudinary.CLDCloudinary? = nil
        
        init() {
            guard
                let cloudName = ParseEnvVars.shared.getEnv(from: .cloudinary, "CLOUD_NAME"),
                let apiKey = ParseEnvVars.shared.getEnv(from: .cloudinary, "API_KEY"),
                let apiSecret = ParseEnvVars.shared.getEnv(from: .cloudinary, "API_SECRET") else {return}
            
            let config = CLDConfiguration(
                cloudName: cloudName,
                apiKey: apiKey,
                apiSecret: apiSecret,
                secure: true)
            
            self._cloudinary = Cloudinary.CLDCloudinary(configuration: config)
            
        }
        
        // TODO: append to params old url to remove if it was existed
        func uploadImage(image: UIImage) async throws -> URL {
            guard let cloudinary = _cloudinary else {
                throw NSError(domain: "Cloudinary", code: 0, userInfo: [NSLocalizedDescriptionKey: "Cloudinary not initialized"])
            }
            
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                throw NSError(domain: "Cloudinary", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse on jpeg"])
            }
            
            return try await withCheckedThrowingContinuation { continuation in
                cloudinary.createUploader().upload(data: imageData, uploadPreset: "l2play", completionHandler:  { response, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let secureUrl = response?.secureUrl, let url = URL(string: secureUrl) {
                        continuation.resume(returning: url)
                    } else {
                        continuation.resume(throwing: NSError(domain: "Cloudinary", code: 2, userInfo: [NSLocalizedDescriptionKey: "Image upload failed"]))
                    }
                })
            }
        }
    }


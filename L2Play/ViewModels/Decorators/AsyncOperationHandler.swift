//
//  AsyncOperationHandler.swift
//  L2Play
//
//  Created by Lukasz Fabia on 28/11/2024.
//

import Foundation

/// Handle Async/Await operations
@MainActor
protocol AsyncOperationHandler: ObservableObject {
    /// Represents state
    /// - States:
    ///     - true: data is downloading from API
    ///     - false: data is fetched
    var isLoading: Bool { get set }
    
    /// Shows error occured during executing operation
    var errorMessage: String? { get set }
    
    
    /// Execute async operation
    /// - Parameter operation: async function
    /// - Returns: Result of the operation
    func performAsyncOperation<T>(_ operation: @escaping () async throws -> T) async -> Result<T, Error>
}


extension AsyncOperationHandler {
    public func performAsyncOperation<T>(_ operation: @escaping () async throws -> T) async -> Result<T, Error> {        
        do {
            let result = try await operation()
            self.errorMessage = nil // reset error message 
            return .success(result)
        } catch let err {
            print(err.localizedDescription)
            self.errorMessage = err.localizedDescription
            return .failure(err)
        }
    }
}

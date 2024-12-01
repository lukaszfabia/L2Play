//
//  BlockCheck.swift
//  L2Play
//
//  Created by Lukasz Fabia on 01/12/2024.
//

enum BlockError: Error {
    case userBlocked(message: String)
}

@discardableResult
func blockCheck<T>(_ action: @escaping () async throws -> T, currentUser: User, targetUser: User) async throws -> T {
    // checks if target user didn't block us
    guard !targetUser.hasBlocked(currentUser.id) else {
        throw BlockError.userBlocked(message: "You've been blocked.")
    }
    return try await action()
}

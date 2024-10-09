//
//  Response.swift
//  ios
//
//  Created by Lukasz Fabia on 08/10/2024.
//  File contains models from API

import Foundation

struct Tokens: Codable {
    let access: String
    let refresh: String
}



/*
 Handling Users and friend requests
 */
struct FriendRequest: Codable {
    let sender : User
    let recevier : User
    let status : String
    let create_at: Date
}

struct User: Codable {
    let first_name: String
    let last_name : String
    let email: String
    let profile_picture: URL
    let friends : [User]
    let friend_requests : [FriendRequest]
    let created_at: Date
}


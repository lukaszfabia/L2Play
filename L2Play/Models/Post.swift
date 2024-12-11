//
//  Post.swift
//  L2Play
//
//  Created by Lukasz Fabia on 08/12/2024.
//

import Foundation

// post 1234
//  post(repost) 3456

// post(reposts)
//    post 1234
//

class Post: Codable, Identifiable, Hashable {
    private(set) var id: UUID = .init()
    let createdAt: Date
    let title: String? // stricte pod post
    let content: String
    var image: URL? // too poor to set list - i dont have a too much space for that
    var author: Author
    var reposts: [UUID] // post id !!!
    
    private var up: [String]
    private var down: [String]
    
    var ups: Int {
        return up.count
    }
    
    var downs: Int {
        return down.count
    }
    
    // MARK: - Hashable & Equatable
    static func ==(lhs: Post, rhs: Post) -> Bool {
         return lhs.id == rhs.id
     }

     func hash(into hasher: inout Hasher) {
         hasher.combine(id)
     }
    
    init(title: String? = nil, content: String, author: Author, image: URL? = nil, reposts: [UUID] = []) {
        self.id = .init()
        self.createdAt = Date()
        self.content = content
        self.author = author
        self.up = []
        self.down = []
        self.image = image
        self.reposts = []
        
        if let title, !title.isEmpty {
            self.title = title
        } else {
            self.title = nil
        }
    }
    
    private func userVoted(_ coll: [String], _ userID: String) -> Bool {
        return coll.contains(userID)
    }
    
    func userVotedYes(_ userID: String) -> Bool {
        return userVoted(up, userID)
    }
    
    func userVotedNo(_ userID: String) -> Bool {
        return userVoted(down, userID)
    }
    
    
    func toggleVoteForYes(_ userID: String) {
        if up.contains(userID) {
            up.removeAll(where: { $0 == userID })
        } else {
            down.removeAll(where: { $0 == userID })
            up.append(userID)
        }
    }
    
    func toggleVoteForNo(_ userID: String) {
        if down.contains(userID) {
            down.removeAll(where: { $0 == userID })
        } else {
            up.removeAll(where: { $0 == userID })
            down.append(userID)
        }
    }
}

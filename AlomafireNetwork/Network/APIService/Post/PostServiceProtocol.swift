//
//  PostService.swift
//  AlomafireNetwork
//
//  Created by Mert Saygılı on 21.10.2024.
//

import Foundation

/// PostServiceProtocol
/// This protocol is responsible for fetching posts from the server.
protocol PostServiceProtocol {
    func fetchPosts() async throws -> [PostModel]
    func fetchPost(id: Int) async throws -> PostModel
}

//
//  PostService.swift
//  AlomafireNetwork
//
//  Created by Mert Saygılı on 21.10.2024.
//

final class PostService: PostServiceProtocol {
    func fetchPosts() async throws -> [PostModel] {
        return try await NetworkManager.shared.request(PostEndpoint.getPosts)
    }

    func fetchPost(id: Int) async throws -> PostModel {
        return try await NetworkManager.shared.request(PostEndpoint.getPost(id: id))
    }
}

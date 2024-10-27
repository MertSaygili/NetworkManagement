//
//  ContentView.swift
//  AlomafireNetwork
//
//  Created by Mert Saygılı on 21.10.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var posts: [PostModel] = []
    @State private var isLoading: Bool = false
    @State private var error: Error?

    var postService: PostServiceProtocol;

    init(postService: PostServiceProtocol) {
        self.postService = postService
    }


    var body: some View {
        Button(action: {
            Task {
                isLoading = true
                defer { isLoading = false }

                do {
                    posts = try await postService.fetchPosts()
                } catch {
                    print("Error: \(error)")
                }
            }
        }) {
            if isLoading {
                ProgressView()
            } else {
                Text("Fetch Posts")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }

    private func loadPosts() async {
        isLoading = true
        defer { isLoading = false }

        do {
            posts = try await postService.fetchPosts()
        } catch {
            self.error = error
        }
    }
}

#Preview {
    ContentView(postService: PostService())
}

//
//  ArticalModel.swift
//  iOS-Mini-Project
//
//  Created by MacBook Pro on 19/9/24.
//

import Foundation
import Alamofire
class ArticalViewModel: ObservableObject{
        @Published var posts: [Payload] = []
        @Published var isLoading = false
        @Published var error: Error?
        @Published var userNme: String = "Kim Minji"
        private var isPollingActive = true // Control polling activity
        // Function to fetch all posts with long polling
        func getAllPosts() {
            guard isPollingActive else { return } // Stop if polling is disabled

            isLoading = true
            AF.request("http://110.74.194.123:8080/api/v1/articles")
                .responseDecodable(of: Welcome.self) { response in
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                    
                    switch response.result {
                    case .success(let result):
                        DispatchQueue.main.async {
                            self.posts = result.payload
                        }
                        
                        // Continue long polling after successful response
                        if self.isPollingActive {
                            self.scheduleNextPoll() // Continue polling after a short delay
                        }
                        
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.error = error
                        }
                        print("Error: \(error)")
                        
                        // Retry after a delay if there's a failure
                        if self.isPollingActive {
                            self.scheduleNextPoll(withDelay: 5) // Retry after 5 seconds on failure
                        }
                    }
                }
    }
    // Method to schedule the next poll with an optional delay
    func scheduleNextPoll(withDelay delay: TimeInterval = 1) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.getAllPosts() // Recursively call to keep polling
        }
    }
    
    // Method to stop polling (can be called when the view disappears)
    func stopPolling() {
        isPollingActive = false
    }
    // Method to start polling again (can be called when the view appears)
    func startPolling() {
        isPollingActive = true
        getAllPosts() // Start polling immediately
    }
    func deletePost(at offsets: IndexSet) {
        let postIdsToDelete = offsets.map { posts[$0].id }
        for postId in postIdsToDelete {
            let url = "http://110.74.194.123:8080/api/v1/articles/\(postId)"
            AF.request(url, method: .delete)
                .validate(statusCode: 200..<300)
                .response { response in
                    switch response.result {
                    case .success:
                        if let index = self.posts.firstIndex(where: { $0.id == postId }) {
                            self.posts.remove(at: index)
                        }
                    case let .failure(error):
                        print("Failed to delete post with error: \(error)")
                    }
                }
        }
    }
    
}

struct Welcome: Codable{
    let message: String
    let payload: [Payload]
    let status: String
    let timestamp: String
}

struct Payload: Identifiable, Codable, Hashable {
    let id: Int
    let title: String
    let content: String
    let imageUrl: String
    let author: String
    let publishedDate: String
    let views: Int
    let isPublished: Bool
}
//    func getAllPosts() {
//            isLoading = true
//            AF.request("http://110.74.194.123:8080/api/v1/articles")
//                .responseDecodable(of: Welcome.self) { response in
//                    self.isLoading = false
//                    switch response.result {
//                    case .success(let result):
//                        DispatchQueue.main.async {
//                            self.posts = result.payload
//                                    }
//
//                    case .failure(let error):
//                        self.error = error
//                        print("Error: \(error)")
//                    }
//                }
//
//        }

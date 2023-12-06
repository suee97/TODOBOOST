import Foundation

struct Followers: Codable {
    let followers: [Follower]
}

struct Follower: Codable {
    let userId: Int
    let nickname: String
    let notification: Bool
    let userImageUrl: String
    let description: String
}

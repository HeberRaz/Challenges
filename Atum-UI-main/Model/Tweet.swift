//  Atum UI Challenge

// Tweet model

import Foundation

struct Tweet : Identifiable, Decodable {
    let id: Int
    let text: String
    let user: UserProfile
}

func testTweet() -> Tweet {
    let user = testUserProfile()
    let tweet = Tweet(id: 0, text: "Fake Tweet Text", user: user)
    return tweet
}

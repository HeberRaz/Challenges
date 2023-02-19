//  Atum UI Challenge

// UserProfile model

// Note: There are more fields in the JSON data for the user profile, but these are the only ones we need for the exercise

import Foundation

struct UserProfile : Decodable {

    let id: Int
    let name:String
    let description: String
    let profileBackgroundImageURLHTTPS: String
    let profileImageURLHTTPS: String
    
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case profileBackgroundImageURLHTTPS = "profile_background_image_url_https"
        case profileImageURLHTTPS = "profile_image_url_https"
    }
}

func testUserProfile() -> UserProfile {
    let userProfile = UserProfile(id: 0, name: "Tweeter", description: "A tweeting person", profileBackgroundImageURLHTTPS: "", profileImageURLHTTPS: "")
    return userProfile
}


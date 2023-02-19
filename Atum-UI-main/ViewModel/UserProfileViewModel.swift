//
//  UserProfileViewModel.swift
//  Atum UI Challenge
//

import UIKit

struct UserProfileViewModel {
    let userProfile: UserProfile
    
    func name() -> String {
        return userProfile.name
    }
    
    func description() -> String {
        return userProfile.description
    }
    
    // Configure the user image view on a background thread using GCD
    func updateUserImageView(completion: @escaping (_ image: UIImage) -> Void) {
      DispatchQueue.global(qos: .background).async {
        if let imageURL = URL(string: userProfile.profileImageURLHTTPS) {
          // TODO: Optional 5 Given the imageURL update the image of the ImageView but load the image on the global DispatchQueue
          print(imageURL) // quiet the warning for now
          let image = UIImage(systemName: "star.circle.fill")!
          completion(image)
        }
      }
    }
}

func testUserProfileViewModel() -> UserProfileViewModel {
    let userProfileViewModel = UserProfileViewModel(userProfile: testUserProfile())
    return userProfileViewModel
}

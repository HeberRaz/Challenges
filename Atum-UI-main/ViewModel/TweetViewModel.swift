//
//  TweetViewModel.swift
//  Atum UI Challenge
//

struct TweetViewModel {
  let tweet: Tweet
    lazy var userProfileViewModel = UserProfileViewModel(userProfile: tweet.user)
        
    func text() -> String {
        return tweet.text
    }
}

func testTweetViewModel() -> TweetViewModel {
    let tweetViewModel = TweetViewModel(tweet: testTweet())
    return tweetViewModel
}

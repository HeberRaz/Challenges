//
//  ViewModelHelper.swift
//  Atum UI Challenge
//
//  ViewModelHelper is provided to load the sample data and access view models of that data.
//
//  View Model accessors
//    userProfileViewModel() returns the viewModel of the user profile
//    tweetCount() returns the total number of tweets
//    tweetViewModel(at index: Int) returns the view model of a specific tweet

//  Functions to trigger loading data
//    loadUserProfile(locally:Bool, completion:) loads the user profile
//      locally: will access the cached copy of the data from the local file
//      completion: gets called when complete

//    loadTweets(locally: Bool, completion) similarly loads the tweets
//      locally: will access the cached copy of the data from the local file
//      completion: gets called when complete

import Foundation

// Don't be concerned that we use Combine internally. You can get all the data without knowing Combine or SwiftUI
import Combine

class ViewModelHelper : ObservableObject {
    // MARK: Private model properties; Use the accessors to get ViewModel objects to access the model data
    private var user: UserProfile?
    private var tweets: [Tweet]?
    
    // MARK: View Model Accessors
    func userProfileViewModel() -> UserProfileViewModel?
    {
        guard let userProfile = user else { return nil }
        
        return UserProfileViewModel(userProfile: userProfile)
    }
    
    func tweetViewModel(at index: Int) -> TweetViewModel? {
        guard let tweet = tweets?[index] else { return nil }
        
        return TweetViewModel(tweet: tweet)
    }
    
    func tweetCount() -> Int {
        return tweets?.count ?? 0
    }

    // MARK: Functions to trigger initial loading of data with callbacks
    func loadUserProfile(locally:Bool, completion: @escaping () -> Void) {
        if locally {
            self.user = getJSONData(forName: "userprofile")
            completion()
        } else {
            getJSONData(withPathComponent: userPathComponent, ofType: UserProfile.self, completion: { value in
                self.user = value
                completion()
            })
        }
    }
    
    func loadTweets(locally: Bool, completion: @escaping () -> Void) {
        if locally {
            self.tweets = getJSONData(forName: "tweets")
            completion()
        } else {
            getJSONData(withPathComponent: tweetsPathComponents, ofType: [Tweet].self, completion: { [weak self] value in
                self?.tweets = value
                completion()
            })
        }
    }

    // MARK: Private accessors
    fileprivate let agent = Agent()
    let base = URL(string: "https://wizetwitterproxy.herokuapp.com/api")!
    let userPathComponent = "user"
    let tweetsPathComponents = "statuses/user_timeline"
  
    private var cancellable : Set<AnyCancellable> = Set()

    private func getJSONData<T: Decodable>(withPathComponent pathComponent:String, ofType _: T.Type, completion: @escaping (_ value: T) -> Void) {
        agent.run(URLRequest(url: base.appendingPathComponent(pathComponent)))
            .map(\.value)
            .sink(receiveCompletion: { _ in },
                  receiveValue: completion)
            .store(in: &cancellable)
    }
    
    private func getJSONData<T: Decodable>(forName name: String) -> T? {
        do {
            if let jsonURL = Bundle.main.url(forResource: name, withExtension: "json") {
                let jsonData = try Data(contentsOf: jsonURL)
                return try JSONDecoder().decode(T.self, from: jsonData)
            }
        } catch {
            print(error)
        }
        
        return nil
    }

}


private struct Agent {
    let session = URLSession.shared
    
    struct Response<T> {
        let value: T
        let response: URLResponse
    }
    
    func run<T: Decodable>(_ request: URLRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .retry(2)
            .tryMap { result -> Response<T> in
                guard let httpResponse = result.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                let value = try decoder.decode(T.self, from: result.data)
                return Response(value: value, response: result.response)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}


//
//  TweetDetailViewController.swift
//  Atum UI Challenge
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var tweetViewModel: TweetViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if var tweetViewModel = self.tweetViewModel {
            descriptionLabel.text = tweetViewModel.text()
            
            // we ask the viewModel to download the image and update our imageView in the background
            let userProfileViewModel = tweetViewModel.userProfileViewModel
            userProfileViewModel.updateUserImageView() { [weak self] image in
              DispatchQueue.main.async {
                self?.imageView.image = image
              }

            }
        }
    }
    
    @IBAction func share(_ sender: Any) {
      guard let tweetText: String = tweetViewModel?.text() else { return }
      let activityViewController = UIActivityViewController(activityItems: [tweetText], applicationActivities: nil)
      activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

      // exclude some activity types from the list (optional)
      activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

      // present the view controller
      self.present(activityViewController, animated: true, completion: nil)
        // TODO: Optional 6 Present the Share sheet modally with the text from tweetViewModel?.text()
    }
}

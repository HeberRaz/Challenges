//
//  TweetTableViewCell.swift
//  Atum UI Challenge
//

import UIKit

// Solution - since configuring the cell is handled in the view model, this class is pretty light
class TweetTableViewCell: UITableViewCell {
    static let reuseIdentifier: String = String(describing: TweetTableViewCell.self)

    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //Hint: Configure the cell when the tweetViewModel is assigned
    var tweetViewModel: TweetViewModel?
        
}

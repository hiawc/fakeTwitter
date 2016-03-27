//
//  TweetCell.swift
//  fakeTwitter
//
//  Created by Nhat Truong on 3/25/16.
//  Copyright © 2016 Nhat Truong. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    let likeOnImg = UIImage(named: "like-on") as UIImage?
    let retweetOnImg = UIImage(named: "retweet-on") as UIImage?
    var tweetID: String!
    
    @IBOutlet weak var retweetCount: UILabel!
    
    @IBOutlet weak var favoriteCount: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var tweet = Tweet!.self()
    


    @IBAction func onReply(sender: AnyObject) {
        
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        let favoriteString = "1.1/favorites/create.json?id=\(tweetID)"
        TwitterClient.sharedInstance.POST(favoriteString, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            self.favoriteButton.setImage(self.likeOnImg, forState: .Normal)
            
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print("error \(error.localizedDescription)")
        }
        
    }
    @IBAction func onRetweet(sender: AnyObject) {
        let retweetString = "1.1/statuses/retweet/\(tweetID).json"
        TwitterClient.sharedInstance.POST(retweetString, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            self.retweetButton.setImage(self.retweetOnImg, forState: .Normal)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print("error \(error.localizedDescription)")
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

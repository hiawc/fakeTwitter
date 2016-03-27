//
//  TweetDetailsViewController.swift
//  fakeTwitter
//
//  Created by Nhat Truong on 3/26/16.
//  Copyright © 2016 Nhat Truong. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {
    let likeOnImg = UIImage(named: "like-on") as UIImage?
    let retweetOnImg = UIImage(named: "retweet-on") as UIImage?

    @IBOutlet weak var favoriteButton: UIButton!
    @IBAction func onFavorite(sender: AnyObject) {
        self.favoriteString = "1.1/favorites/create.json?id=\(tweetID)"
        TwitterClient.sharedInstance.POST(self.favoriteString, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            self.favoriteButton.setImage(self.likeOnImg, forState: .Normal)
            
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print("error \(error.localizedDescription)")
        }
        
    }
    @IBOutlet weak var retweetButton: UIButton!
    var favoriteString: String!
    var retweetString: String!
    var tweetID: String!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let nVc = segue.destinationViewController as? UINavigationController {
            let tvVc = nVc.topViewController as! TweetViewController
            tvVc.tweetID = tweetID
            tvVc.replyView = true
        }        
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        
        self.retweetString = "1.1/statuses/retweet/\(tweetID).json"
        TwitterClient.sharedInstance.POST(self.retweetString, parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            self.retweetButton.setImage(self.retweetOnImg, forState: .Normal)
            self.dismissViewControllerAnimated(true, completion: nil)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print("error \(error.localizedDescription)")
        }

        
        
    }
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    var username: String!
    var screenname: String!
    var timestamp: NSDate!
    var tweet: String!
    var imgUrl: NSURL!
    var retweet: Int!
    var favorite: Int!
    var didRetweet: Bool!
    var didFavorite: Bool!
    
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = username
        
        if didFavorite == true {
            self.favoriteButton.setImage(self.likeOnImg, forState: .Normal)
        }
        if didRetweet == true {
            self.retweetButton.setImage(self.retweetOnImg, forState: .Normal)
        }
        usernameLabel.text = username
        screennameLabel.text = "@\(screenname)"
        tweetLabel.text = tweet
        timestampLabel.text = "\(timestamp)"
        profileImg.setImageWithURL(imgUrl)
        retweetLabel.text = "\(retweet)"
        favoriteLabel.text = "\(favorite)"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


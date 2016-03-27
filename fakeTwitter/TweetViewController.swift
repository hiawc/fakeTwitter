//
//  TweetViewController.swift
//  fakeTwitter
//
//  Created by Nhat Truong on 3/26/16.
//  Copyright © 2016 Nhat Truong. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TweetViewController: UIViewController {
   
    let POSTString = "1.1/statuses/update.json"
    var user: User?
    var tweetID: String!
    var replyView = true
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var screenname: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var tweetView: UITextView!
    
    @IBAction func sendTweet(sender: AnyObject) {
        var params = [String: AnyObject]()
        if replyView == true {
            params["status"] = tweetView.text
            params["in_reply_to_status_id"] = tweetID
        } else {
            params["status"] = tweetView.text
            params["in_reply_to_status_id"] = ""
        }
        
        TwitterClient.sharedInstance.POST(self.POSTString, parameters: params , success: { (task: NSURLSessionDataTask, response: AnyObject?) in
                
            self.dismissViewControllerAnimated(true, completion: nil)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print("error \(error.localizedDescription)")
        }
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.text = ""
        screenname.text = ""
        if replyView == true {
            navigationItem.title = "Reply"
        } else {
            navigationItem.title = "Tweet"
        }
        TwitterClient.sharedInstance.currentAccount({ (user: User) in
            self.user = user
            let imgUrl = self.user?.profileUrl

            if imgUrl == nil {
                self.profileImg.image = nil
            } else {
                self.profileImg.setImageWithURL(imgUrl!)
            }


            self.username.text =  self.user?.name as? String
            let screen_name = self.user?.screenname as? String
            if screen_name == nil {
                self.screenname.text = ""
            } else {
                self.screenname.text = "@\(screen_name!)"
            }
        }) { (error: NSError) in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

//
//  HomeViewController.swift
//  fakeTwitter
//
//  Created by Nhat Truong on 3/22/16.
//  Copyright © 2016 Nhat Truong. All rights reserved.
//

import UIKit
import AFNetworking

class HomeViewController: UIViewController {
    let likeOnImg = UIImage(named: "like-on") as UIImage?
    let retweetOnImg = UIImage(named: "retweet-on") as UIImage?
    
    var tweets: [Tweet]?
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func onLogoutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    override func viewDidAppear(animated: Bool) {
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            
        }) { (error: NSError) in
            print("error \(error.localizedDescription)")
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(HomeViewController.refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()

        }) { (error: NSError) in
            print("error \(error.localizedDescription)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) in
            self.tweets = tweets
            print("reload")
            self.tableView.reloadData()

        }) { (error: NSError) in
            print("error \(error.localizedDescription)")
        }
        refreshControl.endRefreshing()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailsSegue" {
            let vc = segue.destinationViewController as! TweetDetailsViewController
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        
            vc.username = tweets![indexPath!.row].username as! String
            vc.screenname = tweets![indexPath!.row].screenname as! String
            vc.timestamp = tweets![indexPath!.row].timestamp 
            vc.tweet = tweets![indexPath!.row].text as! String
            vc.imgUrl = tweets![indexPath!.row].profileUrl
            vc.favorite = tweets![indexPath!.row].favoritesCount
            vc.retweet = tweets![indexPath!.row].retweetCount
            vc.tweetID = tweets![indexPath!.row].tweetID as! String
            vc.didRetweet = tweets![indexPath!.row].retweeted
            vc.didFavorite = tweets![indexPath!.row].favorited

        } else if segue.identifier == "tweetSegue" {
            if let nVc = segue.destinationViewController as? UINavigationController {
                let tvVc = nVc.topViewController as! TweetViewController
                tvVc.replyView = false
            }
        } else if segue.identifier == "homeReplySegue"{
            let indexPath : NSIndexPath
            if let button = sender as? UIButton {
                let cell = button.superview?.superview as! UITableViewCell
                indexPath = self.tableView.indexPathForCell(cell)!
                if let nVc = segue.destinationViewController as? UINavigationController {
                    let tvVc = nVc.topViewController as! TweetViewController
                    tvVc.tweetID = tweets?[indexPath.row].tweetID as? String
                    tvVc.replyView = true
                }
            }
            

        }
    }
    
    

        
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //return tweetMessage?.count ?? 0
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
       
        cell.tweetLabel.text = tweets?[indexPath.row].text as? String
        cell.nameLabel.text = tweets?[indexPath.row].username as? String
        cell.tweetID = tweets?[indexPath.row].tweetID as? String
       
        let retweets = tweets?[indexPath.row].retweetCount
        if retweets == nil {
            cell.retweetCount.text =  ""
        } else {
            cell.retweetCount.text =  "\(retweets!)"
        }
        
        let favorites = tweets?[indexPath.row].favoritesCount
        if favorites == nil {
            cell.favoriteCount.text = ""
        } else {
            cell.favoriteCount.text =  "\(favorites!)"
        }
        
        let didRetweet = tweets?[indexPath.row].retweeted
        if didRetweet == true {
            cell.retweetButton.setImage(self.retweetOnImg, forState: .Normal)
        }
        
        let didFavorite = tweets?[indexPath.row].favorited
        if didFavorite == true {
            cell.favoriteButton.setImage(self.likeOnImg, forState: .Normal)
        }
        
        let screen_name = tweets?[indexPath.row].screenname as? String
        if screen_name == nil {
             cell.screennameLabel.text = ""
        } else {
            cell.screennameLabel.text = "@\(screen_name!)"
        }
        
        let timestamp = tweets?[indexPath.row].timestamp
        if timestamp == nil {
            cell.timestampLabel.text =  ""
        } else {
            cell.timestampLabel.text =  "\(timestamp!)"
        }
        
        let imageUrl = tweets?[indexPath.row].profileUrl
        if imageUrl == nil {
            cell.profileImg.image = nil
        } else {
            cell.profileImg.setImageWithURL(imageUrl!)
        }
        
        return cell
        
    }
}


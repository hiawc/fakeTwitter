//
//  TwitterClient.swift
//  fakeTwitter
//
//  Created by Nhat Truong on 3/24/16.
//  Copyright © 2016 Nhat Truong. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: "qLxtJKtZtwLta867eSHrnkg3b", consumerSecret: "z22pLezxKLnQDeoYe7BbnrGvtFgQkoA64uNzxsfSsgfBE8rUuT")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    
    func homeTimeline(successs: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            successs(tweets)
            
        }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            failure(error)
        }
        
    }
    
    
    func currentAccount(success: (User)-> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
            //print(user.name)
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            failure(error)
        })
    }
    
        
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func login(success: () -> () , failure: (NSError) -> ()) {
        
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()
        
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "myfaketwitter://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            
        }) { (error: NSError!) -> Void in
            self.loginFailure?(error)
        }
    }
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken:BDBOAuth1Credential!) -> Void in
            
            self.currentAccount({ (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: NSError) in
                self.loginFailure?(error)
            })
            
            
        }) { (error:NSError!) -> Void in
            self.loginFailure?(error)

        }

    }
    
}

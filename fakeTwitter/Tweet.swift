//
//  Tweet.swift
//  fakeTwitter
//
//  Created by Nhat Truong on 3/22/16.
//  Copyright © 2016 Nhat Truong. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var username: NSString?
    var profileUrl: NSURL?
    var screenname: NSString?
    var tweetID: NSString?
    var favorited: Bool?
    var retweeted: Bool?
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int ) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        username = dictionary["user"]!["name"] as? String
        screenname = dictionary["user"]!["screen_name"] as? String
        tweetID = dictionary["id_str"] as? String
        favorited = dictionary["favorited"] as? Bool
        retweeted = dictionary["retweeted"] as? Bool

        
        let profileUrlString = dictionary["user"]!["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString)
        }

        
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }

}

//
//  ViewController.swift
//  fakeTwitter
//
//  Created by Nhat Truong on 3/22/16.
//  Copyright © 2016 Nhat Truong. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import MBProgressHUD

class LoginViewController: UIViewController {

    @IBAction func onLoginButton(sender: AnyObject) {
        TwitterClient.sharedInstance.login({
            self.performSegueWithIdentifier("loginSegue", sender: self)
        }) { (error: NSError) in
                print("error \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func displayMessage(message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}


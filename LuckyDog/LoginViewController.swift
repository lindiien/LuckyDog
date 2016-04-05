//
//  LoginViewController.swift
//  LuckyDog
//
//  Created by Mason Ballowe on 3/31/16.
//  Copyright © 2016 D27 Studios. All rights reserved.
//

import UIKit
import Bolts
import ParseFacebookUtilsV4
import FBSDKCoreKit
import FBSDKLoginKit


class LoginViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Hey chickenfucker")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    
    @IBAction func fbLoginButtonPressed(sender: UIButton) {
        
        let permissions = ["public_profile"]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                    

                    let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, gender, picture"])
                    req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
                        if(error == nil)
                        {
                            user["name"] = result["name"] as! NSString!
                            user["gender"] = result["gender"] as! NSString!
                            
                            let pictureURL = ((result["picture"] as! NSDictionary)["data"] as! NSDictionary) ["url"]
                            let urlString = pictureURL as! String
                            let url: NSURL = NSURL(string: urlString)!
                            let request = NSURLRequest(URL: url)
                            
                            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
                                response, data, error in
                                
                                let imageFile = PFFile(name: "avatar.jpg", data: data!)
                                user["picture"] = imageFile
                                user.saveInBackgroundWithBlock(nil)
                                })
                        }
                        else
                        {
                            print("error \(error)")
                        }
                    })
                    
                } else {
                    print("User logged in through Facebook!")
                    self.goToCardsViewController()

                }
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        }
        
    }
    
    
    func goToCardsViewController() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CardsNavController") as? UIViewController
        
        self.presentViewController(vc!, animated: true, completion: nil)
    }

}

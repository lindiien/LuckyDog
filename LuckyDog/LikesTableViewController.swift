//
//  LikesTableViewController.swift
//  LuckyDog
//
//  Created by Mason Ballowe on 4/8/16.
//  Copyright © 2016 D27 Studios. All rights reserved.
//

import UIKit

class LikesTableViewController: UITableViewController {

    var likeArray : [Like] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = UIImageView(image: UIImage(named: "chat-header"))
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav-back-button"), style: UIBarButtonItemStyle.Plain, target: self, action: "goToPriorVC:")
        navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.titleView = UIImageView(image: UIImage(named: "chat-header"))
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav-back-button"), style: UIBarButtonItemStyle.Plain, target: self, action: "goToPreviousVC:")
        navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: true)
        
        fetchLikedAnimals()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    func goToPriorVC(button: UIBarButtonItem) {
        pageController.goToNextVC()
    }
    
    func fetchLikedAnimals () -> () {
        
        let query = PFQuery(className : "Action")
        query.whereKey("byUser", equalTo: PFUser.currentUser()!.objectId!)
        query.whereKey("type", equalTo: "liked")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error : NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) liked animals.")
                
                
                if let returnedLikes = objects as? [PFObject]! {
                    for like in returnedLikes {

                        let newLikeID = like.objectId
                        let newLikeByUser = like["byUser"] as! String
                        let newLikeToUser = like["toUser"] as! String
                        let newLikeHostID = like["hostID"] as! String
                        
                        let newLike = Like(likeID : newLikeID!, byUser : newLikeByUser, toUser : newLikeToUser, hostID : newLikeHostID)
                        self.likeArray.append(newLike)
                    }
            } else {
                    // Log details of the failure
                    
                }
                
        }
            print("tableview reload")
            self.tableView.reloadData()
        }
        
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


    
}

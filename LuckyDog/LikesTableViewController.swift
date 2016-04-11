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
    var likeImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        navigationItem.titleView = UIImageView(image: UIImage(named: "chat-header"))
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav-back-button"), style: UIBarButtonItemStyle.Plain, target: self, action: "goToPriorVC:")
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.likeArray.count
    }
    
    func goToPriorVC(button: UIBarButtonItem) {
        pageController.goToNextVC()
    }
    
    func fetchLikedAnimals () -> () {
        self.likeArray.removeAll()
        
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
                        let newLikeName = like["animalName"] as! String
                        
                        
                        let newLikeImage = like["image"] as? PFFile
                        newLikeImage!.getDataInBackgroundWithBlock {
                            (imageData: NSData?, error: NSError?) -> Void in
                            print("Hello BITCHES")
                            if (error == nil) {
                                if let imageData = imageData {
                                    let image : UIImage = UIImage(data:imageData)!
                                    print(image)
                                    print("Image Above")
                                    self.likeImage = image
                                }
                            } else {
                                print(error)
                            }
                            let newLike = Like(likeID : newLikeID!, byUser : newLikeByUser, toUser : newLikeToUser, hostID : newLikeHostID, animalName: newLikeName, image: self.likeImage!)
                            self.likeArray.append(newLike)
                            
                            self.tableView.reloadData()
                        }
                        

                    }
            } else {
                    // Log details of the failure
                    
                }
               
        }
            
            
        }
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LikeCell", forIndexPath: indexPath) as! LikeCell
        
        let like = self.likeArray[indexPath.row].likeID
        
        
        
        cell.nameLabel.text = likeArray[indexPath.row].animalName
       
        cell.avatarImageView.image = likeArray[indexPath.row].image

        return cell
    
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc = ChatViewController()
        navigationController?.pushViewController(vc, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

//
//  RosterViewController.swift
//  LuckyDog
//
//  Created by Mason Ballowe on 4/14/16.
//  Copyright © 2016 D27 Studios. All rights reserved.
//

import UIKit

class RosterViewController: UITableViewController {
    
    var rosterArray : [Animal] = []
    var rosterImage : UIImage?
    var currentAnimal = ""
    var currentPath : NSIndexPath?
    var cellTapped : Bool?
    var currentIndex : Int?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.titleView = UIImageView(image: UIImage(named: "nav-header"))
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav-back-button"), style: UIBarButtonItemStyle.Plain, target: self, action: "addAnimal:")
        navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: true)
    }
    
    func addAnimal(button: UIBarButtonItem) {
        pageController.goToNextVC()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        fetchAnimalRoster()
        self.currentPath = nil
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return self.rosterArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RosterCell", forIndexPath: indexPath) as! RosterCell
    
        if self.currentPath == indexPath {
                cell.deleteButton.hidden = false
            } else {
                cell.deleteButton.hidden = true
            }
        
        
        cell.nameLabel.text = self.rosterArray[indexPath.row].name
        cell.avatarImageView.image = self.rosterArray[indexPath.row].image
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("RosterCell", forIndexPath: indexPath) as! RosterCell
        
//        cell.deleteButton.hidden = false
        
        self.currentAnimal=self.rosterArray[indexPath.row].id
        
        self.currentPath = indexPath
        self.currentIndex = indexPath.row
        
        cell.nameLabel.text = self.rosterArray[indexPath.row].name
        cell.avatarImageView.image = self.rosterArray[indexPath.row].image
        
        tableView.reloadData()
        
    }
    

    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            print("Hello")
        }
    }
    
    
    
    func fetchAnimalRoster () -> () {
        self.rosterArray.removeAll()
        
        let query = PFQuery(className : "Animal")
        query.whereKey("host", equalTo: PFUser.currentUser()!.objectId!)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error : NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) hosted animals.")
                
                
                if let returnedAnimals = objects as? [PFObject]! {
                    for animal in returnedAnimals {
                        
                        let newAnimalID = animal.objectId
                        let newAnimalName = animal["name"] as! String
                        let newAnimalType = animal["type"] as! String
                        let newAnimalAge = animal["age"] as! String
                        let newAnimalGender = animal["gender"] as! String
                        let newAnimalBreed = animal["breed"] as! String
                        let newAnimalDescription = animal["description"] as! String
                        let newAnimalHost = animal["host"] as! String
                        
                        
                        let newAnimalImage = animal["picture"] as? PFFile
                        newAnimalImage!.getDataInBackgroundWithBlock {
                            (imageData: NSData?, error: NSError?) -> Void in
                            print("Hello BITCHES")
                            if (error == nil) {
                                if let imageData = imageData {
                                    let image : UIImage = UIImage(data:imageData)!
                                    print(image)
                                    print("Image Above")
                                    self.rosterImage = image
                                }
                            } else {
                                print(error)
                            }
                            let newAnimal = Animal(id: newAnimalID!, name: newAnimalName, type: newAnimalType, gender: newAnimalGender, age: newAnimalAge, breed: newAnimalBreed, description: newAnimalDescription, host: newAnimalHost, image: self.rosterImage!)
                            self.rosterArray.append(newAnimal)
                            
                            
                            
                            
                            
                            self.tableView.reloadData()
                        }
                        
                        
                    }
                } else {
                    // Log details of the failure
                    
                }
                
            }
            
            
        }
        
    }
    
    @IBAction func deleteButtonPressed(sender: UIButton) {
        print("DELETING")
        print(self.currentAnimal)
        
        
       
        let query = PFQuery(className : "Animal")
        query.whereKey("objectId", equalTo: self.currentAnimal)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error : NSError?) -> Void in
            if error == nil {
                print("Successfully retrieved \(objects!.count) hosted animals for deletion.")
                for object in objects! {
                    object.deleteInBackground()
                    print("1")
                }
                print("2")
                
            }
            print("3")

            self.rosterArray.removeAtIndex(self.currentIndex!)
            self.currentPath = nil
            self.tableView.reloadData()
        }
        print("4")
    }
    
    
    
    
}
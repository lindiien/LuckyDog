//
//  CardsViewController.swift
//  LuckyDog
//
//  Created by Mason Ballowe on 3/31/16.
//  Copyright © 2016 D27 Studios. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController, SwipeViewDelegate {
    
    struct Card {
        let cardView : CardView
        let swipeView : SwipeView
        var animal : Animal
    }
    
    
    var shouldLoop : Bool = true
    
    @IBOutlet var cardStackView: UIView!
    @IBOutlet var nahButton: UIButton!
    @IBOutlet var yeahButton: UIButton!
    
    
    
    let frontCardTopMargin : CGFloat = 0
    let backCardTopMargin : CGFloat = 10
    
    var frontCard : Card?
    var backCard : Card?
    
    var animalsArray : [Animal] = []
    var viewedAnimalsArray : [String] = []
    var animalImage : UIImage?
    var animalIndex : Int = 0
    var currentAnimal : String = ""
    var currentHost : String = ""
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.titleView = UIImageView(image: UIImage(named: "nav-header"))
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav-back-button"), style: UIBarButtonItemStyle.Plain, target: self, action: "goToChat:")
        navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: true)
    }
    
    
    func goToChat(button: UIBarButtonItem) {
        pageController.goToPreviousVC()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchViewedAnimals()
        
        cardStackView.backgroundColor = UIColor.clearColor()
        nahButton.setImage(UIImage(named: "nah-button-pressed"), forState: UIControlState.Highlighted)
        yeahButton.setImage(UIImage(named: "yeah-button-pressed"), forState: UIControlState.Highlighted)
        
//        fetchUnviewedAnimals({
//            returnedAnimals in
//            self.animalsArray = returnedAnimals
//            
//                if let card = self.popCard() {
//                    self.frontCard = card
//                    self.cardStackView.addSubview(self.frontCard!.swipeView)
//                }
//                if let card = self.popCard() {
//                    self.backCard = card
//                    self.backCard!.swipeView.frame = self.createCardFrame(self.backCardTopMargin)
//                    self.cardStackView.insertSubview(self.backCard!.swipeView, belowSubview: self.frontCard!.swipeView)
//                }
//            }
//        )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nahButtonPressed(sender: UIButton) {
        if let card = frontCard {
            card.swipeView.swipe(SwipeView.Direction.Left)
        }
    }
    
    
    @IBAction func yeahButtonPressed(sender: UIButton) {
        if let card = frontCard {
            card.swipeView.swipe(SwipeView.Direction.Right)
        }
    }
    
    
    
    private func createCardFrame(topMargin : CGFloat) -> CGRect {
        return CGRect(x: 0, y: topMargin, width: cardStackView.frame.width, height: cardStackView.frame.height)
    }
    
    private func createCard(animal : Animal) -> Card {
        let cardView = CardView()
       
            print("CREATE CARDS")
            print("CREATE CARDS")
            print(self.animalsArray.count)
            cardView.name = self.animalsArray[self.animalIndex].name
            cardView.image = self.animalsArray[self.animalIndex].image
        
            let swipeView = SwipeView(frame: createCardFrame(0))
            swipeView.delegate = self
            swipeView.innerView = cardView
            return Card(cardView: cardView, swipeView: swipeView, animal: animal)
    }
    
    private func popCard() -> Card? {
        
        print(self.animalsArray.count)
        print("THIS IS PRINTING")
        
            print("Condition one")
            self.animalIndex = 0
            self.frontCard = createCard(animalsArray[self.animalIndex])
            self.cardStackView.addSubview(self.frontCard!.swipeView)
        
            self.currentAnimal = animalsArray[self.animalIndex].id
            self.currentHost = animalsArray[self.animalIndex].host
     
            print("Condition two")
            self.animalIndex = 1
            self.backCard = createCard(animalsArray[self.animalIndex])
            self.backCard!.swipeView.frame = self.createCardFrame(self.backCardTopMargin)
            self.cardStackView.insertSubview(self.backCard!.swipeView, belowSubview: self.frontCard!.swipeView)

        
        
        if animalsArray.count > 2 {
            return createCard(animalsArray.removeAtIndex(0))
        }
        else {
            showAlertWithText("Awwwwwww", message: "You're out of animals.  Please expand your search or check back soon.  New loveables are added every day!")
            return nil
        }
        
    }
    
    private func switchCards() {
            
        if let card = backCard {
            frontCard = card
            UIView.animateWithDuration(0.2, animations: {
                self.frontCard!.swipeView.frame = self.createCardFrame(self.frontCardTopMargin)
            })
            self.backCard!.swipeView.frame = self.createCardFrame(self.backCardTopMargin)
            self.cardStackView.insertSubview(self.backCard!.swipeView, belowSubview: self.frontCard!.swipeView)
            
            self.popCard()
        }
        

        
    }
    
    
    
    // MARK : SwipeViewDelegate
    
    func swipedLeft() {
        print("Left")
        if let frontCard = frontCard {
            frontCard.swipeView.removeFromSuperview()
            saveSkip()
            switchCards()
        }
    }
    
    func swipedRight() {
        print("Right")
        if let frontCard = frontCard {
            frontCard.swipeView.removeFromSuperview()
            saveLike()
            switchCards()
        }
    }
    
    func fetchUnviewedAnimals (callback: ([Animal]) -> ()) {
        
        let query = PFQuery(className : "Animal")
        query.whereKey("objectId", notContainedIn: self.viewedAnimalsArray)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error : NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) unviewed animals.")
                
                if objects!.count == 0 {
                    self.animalsArray.append(animalTwo)
                    self.animalsArray.append(animalOne)
                    self.popCard()
                }
                
                // Do something with the found objects
                
                if let returnedAnimals = objects as? [PFObject]! {
                    for animal in returnedAnimals {
                        print(animal.objectId)
                        print(animal["name"])
                        
                        let newAnimalID = animal.objectId
                        let newAnimalName = animal["name"] as! String
                        let newAnimalType = animal["type"] as! String
                        let newAnimalAge = animal["age"] as! String
                        let newAnimalGender = animal["gender"] as! String
                        let newAnimalBreed = animal["breed"] as! String
                        let newAnimalDescription = animal["description"] as! String
                        let newAnimalHost = animal["host"] as! String
                        
                        let animalImage = animal["picture"] as? PFFile
                            animalImage!.getDataInBackgroundWithBlock {
                                (imageData: NSData?, error: NSError?) -> Void in
                                if (error == nil) {
                                        if let imageData = imageData {
                                            let image : UIImage = UIImage(data:imageData)!
                                            print(image)
                                            print("Image Above")
                                            self.animalImage = image
                                        }
                                    } else {
                                    print(error)
                                }
                                let newAnimal = Animal(id: newAnimalID!, name: newAnimalName, type: newAnimalType, gender: newAnimalGender, age: newAnimalAge, breed: newAnimalBreed, description: newAnimalDescription, host: newAnimalHost, image: self.animalImage!)
                                self.animalsArray.append(newAnimal)
                                
                                print("hello")
                                print(newAnimal)
                                print("hello2")
                                
                                if objects!.count == self.animalsArray.count && self.shouldLoop == true {
                                    print("Loop Complete BIOTCH")
                                    self.shouldLoop = false
                                    
                                    self.animalsArray.append(animalTwo)
                                    self.animalsArray.append(animalOne)
                                    self.popCard()
                        
                                } else {
                                    print(objects!.count)
                                    print(self.animalsArray.count)
                                    
                                }
                                
                            }

                    }
                } else {
                    // Log details of the failure
                    print("Error:")
                }

            }
        }
    }
    
    func showAlertWithText (header : String = "Ermahgerd!!!", message : String) {
        let alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

  
    // Skips and Likes
    
    func saveSkip() {
       
        if self.currentAnimal != "Two" {
        let skip = PFObject(className: "Action")
        skip.setObject(PFUser.currentUser()!.objectId!, forKey: "byUser")
        skip.setObject(self.currentAnimal, forKey: "toUser")
        skip.setObject("skipped", forKey: "type")
        skip.setObject(self.currentHost, forKey: "hostID")
        skip.saveInBackgroundWithBlock(nil)
        }
    }
    
    func saveLike() {
        if self.currentAnimal != "Two" {
        let like = PFObject(className: "Action")
        like.setObject(PFUser.currentUser()!.objectId!, forKey: "byUser")
        like.setObject(self.currentAnimal, forKey: "toUser")
        like.setObject("liked", forKey: "type")
        like.setObject(self.currentHost, forKey: "hostID")
        like.saveInBackgroundWithBlock(nil)
        }
    }
    
    func fetchViewedAnimals () {
        
        let query = PFQuery(className : "Action")
        query.whereKey("byUser", equalTo: (PFUser.currentUser()?.objectId)!)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error : NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) viewed animals.")
                // Do something with the found objects
                
                for object in objects! {
                    let viewedAnimalID = object["toUser"] as! String
                    self.viewedAnimalsArray.append(viewedAnimalID)
                }
                
                self.fetchUnviewedAnimals({
                    returnedAnimals in
                    self.animalsArray = returnedAnimals
                    
                    if let card = self.popCard() {
                        self.frontCard = card
                        self.cardStackView.addSubview(self.frontCard!.swipeView)
                    }
                    if let card = self.popCard() {
                        self.backCard = card
                        self.backCard!.swipeView.frame = self.createCardFrame(self.backCardTopMargin)
                        self.cardStackView.insertSubview(self.backCard!.swipeView, belowSubview: self.frontCard!.swipeView)
                    }
                    }
                )
            
            
                
            } else {
                    // Log details of the failure
                    print("Error:")
                }
 
        }
    
    
    
    }
}


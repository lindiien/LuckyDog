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
    
    let frontCardTopMargin : CGFloat = 0
    let backCardTopMargin : CGFloat = 10
    
    var frontCard : Card?
    var backCard : Card?
    
    var animalsArray : [Animal] = []
    var animalImage : UIImage?
    var animalIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        cardStackView.backgroundColor = UIColor.clearColor()
        
        fetchUnviewedAnimals({
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            switchCards()
        }
    }
    
    func swipedRight() {
        print("Right")
        if let frontCard = frontCard {
            frontCard.swipeView.removeFromSuperview()
            switchCards()
        }
    }
    
    func fetchUnviewedAnimals (callback: ([Animal]) -> ()) {
        
        let query = PFQuery(className : "Animal")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error : NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                
                if let returnedAnimals = objects as? [PFObject]! {
                    for animal in returnedAnimals {
                        print(animal.objectId)
                        print(animal["name"])
                        
                        let newAnimalID = animal.objectId
                        let newAnimalName = animal["name"] as! String
                        let newAnimalType = animal["type"] as! String
                        
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
                                let newAnimal = Animal(id: newAnimalID!, name: newAnimalName, type: newAnimalType, image: self.animalImage!)
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

  
    
    
    
    
    
    
}

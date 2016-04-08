//
//  Animal.swift
//  LuckyDog
//
//  Created by Mason Ballowe on 4/4/16.
//  Copyright © 2016 D27 Studios. All rights reserved.
//

import Foundation




struct Animal {
    var id : String
    var name : String
    var type : String
    var gender : String
    var age : String
    var breed : String
    var description : String
    var host : String
    var image : UIImage

}

let sadCatImage = UIImage(named: "sadCat.jpg")

let animalOne : Animal = Animal(id: "one", name: "AnimalOne", type: "sadCat", gender : "male", age : "1", breed : "Mutt", description : "loveable", host : "Mason", image: sadCatImage!)

let smilingHedgehogImage = UIImage(named: "smilingHedgehog.jpg")

let animalTwo : Animal = Animal(id: "Two", name: "AnimalTwo", type: "HappyHedge", gender : "male", age : "1", breed : "Mutt", description : "loveable", host: "Mason", image: smilingHedgehogImage!)



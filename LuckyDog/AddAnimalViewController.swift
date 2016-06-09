//
//  AddAnimalViewController.swift
//  LuckyDog
//
//  Created by Mason Ballowe on 6/9/16.
//  Copyright © 2016 D27 Studios. All rights reserved.
//

import UIKit

class AddAnimalViewController: ViewController {

    @IBOutlet var nameField: UITextField!
    @IBOutlet var typeField: UITextField!
    @IBOutlet var ageField: UITextField!
    @IBOutlet var genderField: UITextField!
    @IBOutlet var breedField: UITextField!
    @IBOutlet var descriptionField: UITextField!
    @IBOutlet var imageView: UIImageView!
    
    var pickerController : UIImagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addImageButtonPressed(sender: UIButton) {
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(sender: UIButton) {
    }
    



}

//
//  FirstViewController.swift
//  Calosharev1
//
//  Created by Tessa Voon on 25/6/16.
//  Copyright © 2016 Tessa Voon. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var foods = [Food]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addNewFood))
        navigationItem.title = "Meal Log"
    }
    
    func addNewFood() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }
    
    // dismiss photo selection
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var newImage: UIImage
        
        if let possibleImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        let imageName = NSUUID().UUIDString
        let imagePath = getDocumentsDirectory().stringByAppendingPathComponent(imageName)
        
        if let jpegData = UIImageJPEGRepresentation(newImage, 80) {
            jpegData.writeToFile(imagePath, atomically: true)
        }
        
        let food = Food(foodInfo: "Add details", image: imageName)
        foods.insert(food, atIndex: 0)
        collectionView.reloadData()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foods.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Food", forIndexPath: indexPath) as! FoodCell
        
        let food = foods[indexPath.item]
        
        cell.foodInfo.text = food.foodInfo
        
        let path = getDocumentsDirectory().stringByAppendingPathComponent(food.image)
        cell.imageView.image = UIImage(contentsOfFile: path)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let food = foods[indexPath.item]
        
        // get date to append in foodinfo field
        let currentDateTime = NSDate()
        let userCalendar = NSCalendar.currentCalendar()
        let requestedComponents: NSCalendarUnit = [
            NSCalendarUnit.Year,
            NSCalendarUnit.Month,
            NSCalendarUnit.Day
        ]
        let dateTimeComponents = userCalendar.components(requestedComponents, fromDate: currentDateTime)
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Which meal are you having?", message: "", preferredStyle: .ActionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        
        // BREAKFAST
        
        let breakfastAction: UIAlertAction = UIAlertAction(title: "Breakfast", style: .Default) { action -> Void in
            food.foodInfo = "Breakfast " + String(dateTimeComponents.day) + "/" + String(dateTimeComponents.month)
            
            self.collectionView.reloadData()
        }
        actionSheetController.addAction(breakfastAction)
        
        // LUNCH
        
        let lunchAction: UIAlertAction = UIAlertAction(title: "Lunch", style: .Default) { action -> Void in
            food.foodInfo = "Lunch " + String(dateTimeComponents.day) + "/" + String(dateTimeComponents.month)
            
            self.collectionView.reloadData()
        }
        actionSheetController.addAction(lunchAction)
        
        // DINNER
        
        let dinnerAction: UIAlertAction = UIAlertAction(title: "Dinner", style: .Default) { action -> Void in
            food.foodInfo = "Dinner " + String(dateTimeComponents.day) + "/" + String(dateTimeComponents.month)
            
            self.collectionView.reloadData()
        }
        actionSheetController.addAction(dinnerAction)
        
        // SNACK
        
        let snackAction: UIAlertAction = UIAlertAction(title: "Snack", style: .Default) { action -> Void in
            food.foodInfo = "Snack " + String(dateTimeComponents.day) + "/" + String(dateTimeComponents.month)
            
            self.collectionView.reloadData()
        }
        actionSheetController.addAction(snackAction)
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }

}


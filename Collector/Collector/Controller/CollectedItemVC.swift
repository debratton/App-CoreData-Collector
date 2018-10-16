//
//  CollectedItemVC.swift
//  Collector
//
//  Created by David E Bratton on 10/15/18.
//  Copyright © 2018 David Bratton. All rights reserved.
//

import UIKit
import CoreData

class CollectedItemVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleText: UITextField!
    
    // SETUP Picker Controller for both Camera and Media on your phone
    // For Camera, you have to modify info.plist and Privacy - Camera Usage Description
    // At top have to add to protocols to inherit from  UIImagePickerControllerDelegate, UINavigationControllerDelegate
    var pickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        pickerController.delegate = self
    }
    
    // Function allows us to grab the picture to place in image view
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
        }
        // Need this otherwise the screen where you pic image never goes away
        pickerController.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func mediaFolderBtnPressed(_ sender: UIBarButtonItem) {
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true) {
            
        }
    }
    
    @IBAction func cameraBtnPressed(_ sender: UIBarButtonItem) {
        pickerController.sourceType = .camera
        present(pickerController, animated: true) {
            
        }
    }
    
    @IBAction func addItemBtnPressed(_ sender: Any) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let newItem = Collectable(context: context)

            if let title = titleText.text {
                newItem.title = title
            }
            
            // Since in core data we set type to Binary Data, we have to convert UIImage
            if let image = imageView.image?.jpegData(compressionQuality: 1.0) {
                newItem.image = image
            }
            // Save the data to CoreData
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        }
        navigationController?.popViewController(animated: true)
    }
    
}
// Dismiss the keyboard so you can hit the Add button
extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

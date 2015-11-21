//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Andrei Sadovnicov on 21/11/15.
//  Copyright © 2015 Andrei Sadovnicov. All rights reserved.
//

import UIKit


// MARK: - CLASS
class MemeEditorViewController: UIViewController {
    
    // MARK: - PROPERTIES
    
    // MARK: - @IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    
    // MARK: - METHODS
    
    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the text fields
        configureTextField(topTextField, withText: "TOP")
        configureTextField(bottomTextField, withText: "BOTTOM")
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Disable camera button if camera is not available
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
    }
    
    
    
    // MARK: - @IBActions
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
        
        
    }
    
    
    // MARK: - Style text fields
    func configureTextField(textField: UITextField, withText text: String) {
        
        textField.text = text
        
        let memeTextAttributes = [
        
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSStrokeWidthAttributeName : -2.0,
            
        ]
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.autocapitalizationType = .AllCharacters
        textField.textAlignment = .Center
        textField.backgroundColor = UIColor.clearColor()
        textField.borderStyle = .None
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 12.0
        
    }
    
    
    
    
    
    
}


// MARK: - EXTENSIONS

// MARK: - UIImagePickerControllerDelegate
extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageView.image = image
            
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
}
















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
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
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
        
        // Disable the share button if there is no image selected
        if imageView.image == nil {
            
            shareButton.enabled = false
            
        }
        
        // Subscribe to keyboard notifications
        subscribeToKeyboardNotifications()
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        
        // Unsubscribe from keyboard notifications
        unsubscribeFromKeyboardNotifications()
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        // Dismiss the keyboard on rotation
        view.endEditing(true)
        
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
    
    @IBAction func shareMeme(sender: AnyObject) {
        
        let memedImage = generateMemedImage()
        
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = { _, completed, _, _ in
            
            if completed {
                
                self.saveMeme()
                self.dismissViewControllerAnimated(true, completion: nil)
                
            }
        }
        
        presentViewController(activityViewController, animated: true, completion: nil)
        
        
    }
    
    // MARK: - Text fields configuration
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
        
        textField.delegate = self
        
    }
    
    
    // MARK: - Keyboard management
    func subscribeToKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide", name: UIKeyboardWillHideNotification, object: nil)
        

        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        

    }
    
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
        
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        if bottomTextField.isFirstResponder() {
            
            view.frame.origin.y -= getKeyboardHeight(notification)
            
        }
        
    }
    
    func keyboardWillHide() {
        
        if bottomTextField.isFirstResponder() {
            
            view.frame.origin.y = 0.0
            
        }
    }
    
    
    // MARK: - Meme management
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        navigationController?.navigationBar.hidden = true
        navigationController?.toolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        navigationController?.navigationBar.hidden = false
        navigationController?.toolbar.hidden = false
        
        // Return the memedImage
        return memedImage
    }
    
    
    func saveMeme() {
        
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
            
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        
        print("Meme saved")

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
            
            shareButton.enabled = true
            
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }

}


extension MemeEditorViewController: UITextFieldDelegate {
    
    // Remove the default text when starting to edit the text field
    func textFieldDidBeginEditing(textField: UITextField) {
        
        switch textField {
            
        case topTextField:
            
            if textField.text == "TOP" {
                
                textField.text = ""
                
            }
            
        case bottomTextField:
            
            if textField.text == "BOTTOM" {
            
                textField.text = ""
            
            }
            
        default:
            
            break
        }
        
    }
    
    // Add back the default text if the text field is empty after user dismisses the keyboard
    func textFieldDidEndEditing(textField: UITextField) {
        
        switch textField {
            
        case topTextField:
            
            if textField.text == "" {
                
                textField.text = "TOP"
                
            }
            
        case bottomTextField:
            
            if textField.text == "" {
                
                textField.text = "BOTTOM"
                
            }
            
        default:
            
            break
        }

        
    }
    
    // Dismiss keyboard on pressing the return key
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    
}















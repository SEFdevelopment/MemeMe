//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Andrei Sadovnicov on 25/11/15.
//  Copyright © 2015 Andrei Sadovnicov. All rights reserved.
//

import UIKit
import AVFoundation


// MARK: - CLASS
class MemeEditorViewController: UIViewController {
    
    // MARK: - PROPERTIES
    
    // MARK: - @IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet var textFieldsView: UIView!
    
    
    // MARK: - Model
    var indexForMemeToEdit: Int?
    
    
    // MARK: - AppDelegate
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    // MARK: - METHODS
    
    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let indexForMemeToEdit = indexForMemeToEdit {
            
            let memeToEdit = appDelegate.memes[indexForMemeToEdit]
            
            configureTextField(topTextField, withText: memeToEdit.topText)
            configureTextField(bottomTextField, withText: memeToEdit.bottomText)
            
            imageView.image = memeToEdit.originalImage
            
        } else {
            
            configureTextField(topTextField, withText: "TOP")
            configureTextField(bottomTextField, withText: "BOTTOM")
            
        }
        
        view.addSubview(textFieldsView)
        
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
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if imageView.image != nil {
            
            positionTextFieldsViewForAspectFit()
            
            
        } else {
            
            positionTextFieldsViewForNoImage()
            
        }
        
        
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
        
        // Dismiss the keyboard on share
        view.endEditing(true)
        
        // Generate, share and save the meme
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
    
    @IBAction func cancel(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
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
    
    
    // MARK: - Text fields positioning
    func positionTextFieldsViewForAspectFit() {
        
        let rectForAspectFitArea = AVMakeRectWithAspectRatioInsideRect(imageView.image!.size, imageView.frame)
        
        textFieldsView.frame = rectForAspectFitArea
        
    }
    
    
    func positionTextFieldsViewForNoImage() {
        
        textFieldsView.frame = imageView.frame
        
    }
    
    
    
    // MARK: - Keyboard management
    func subscribeToKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
        
        
        
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
        
        UIGraphicsBeginImageContext(view.bounds.size)
        
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        
        
        let rectForAspectFitArea = AVMakeRectWithAspectRatioInsideRect(imageView.image!.size, imageView.frame)
        
        let cgiImage = CGImageCreateWithImageInRect(viewImage.CGImage, rectForAspectFitArea)
        
        let memedImage = UIImage(CGImage: cgiImage!)
        
        return memedImage
    }
    
    
    func saveMeme() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
        
        if let indexForMemeToEdit = indexForMemeToEdit {
            
            appDelegate.memes[indexForMemeToEdit] = meme
            
        } else {
            
            appDelegate.memes.append(meme)
            
        }
        
        
        
        
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
            
            positionTextFieldsViewForAspectFit()
            
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















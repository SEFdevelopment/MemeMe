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
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Disable camera button if camera is not available
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        
        // Disable the share button if there is no image selected
        if imageView.image == nil {
            
            shareButton.isEnabled = false
            
        }
        
        // Subscribe to keyboard notifications
        subscribeToKeyboardNotifications()
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
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
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        // Dismiss the keyboard on rotation
        view.endEditing(true)
        
    }
    
    // MARK: - @IBActions
    @IBAction func pickAnImageFromAlbum(_ sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    @IBAction func shareMeme(_ sender: AnyObject) {
        
        // Dismiss the keyboard on share
        view.endEditing(true)
        
        // Generate, share and save the meme
        let memedImage = generateMemedImage()
        
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = { _, completed, _, _ in
            
            if completed {
                
                self.saveMeme()
                self.dismiss(animated: true, completion: nil)
                
            }
        }
        
        present(activityViewController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    // MARK: - Text fields configuration
    func configureTextField(_ textField: UITextField, withText text: String) {
        
        textField.text = text
        
        let memeTextAttributes = [
            
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSForegroundColorAttributeName : UIColor.white,
            NSStrokeColorAttributeName : UIColor.black,
            NSStrokeWidthAttributeName : -2.0,
            
        ] as [String : Any]
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.autocapitalizationType = .allCharacters
        textField.textAlignment = .center
        textField.backgroundColor = UIColor.clear
        textField.borderStyle = .none
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 12.0
        
        textField.delegate = self
        
    }
    
    
    // MARK: - Text fields positioning
    func positionTextFieldsViewForAspectFit() {
        
        let rectForAspectFitArea = AVMakeRect(aspectRatio: imageView.image!.size, insideRect: imageView.frame)
        
        textFieldsView.frame = rectForAspectFitArea
        
    }
    
    
    func positionTextFieldsViewForNoImage() {
        
        textFieldsView.frame = imageView.frame
        
    }
    
    
    
    // MARK: - Keyboard management
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
    }
    
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
        
    }
    
    
    func keyboardWillShow(_ notification: Notification) {
        
        if bottomTextField.isFirstResponder {
            
            view.frame.origin.y -= getKeyboardHeight(notification)
            
        }
        
    }
    
    func keyboardWillHide() {
        
        if bottomTextField.isFirstResponder {
            
            view.frame.origin.y = 0.0
            
        }
    }
    
    
    // MARK: - Meme management
    func generateMemedImage() -> UIImage {
        
        UIGraphicsBeginImageContext(view.bounds.size)
        
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()

        let rectForAspectFitArea = AVMakeRect(aspectRatio: imageView.image!.size, insideRect: imageView.frame)
        
        let cgiImage = viewImage?.cgImage?.cropping(to: rectForAspectFitArea)
        
        let memedImage = UIImage(cgImage: cgiImage!)
        
        return memedImage
    }
    
    
    func saveMeme() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageView.image = image
            
            shareButton.isEnabled = true
            
            positionTextFieldsViewForAspectFit()
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
}


extension MemeEditorViewController: UITextFieldDelegate {
    
    // Remove the default text when starting to edit the text field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
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
    func textFieldDidEndEditing(_ textField: UITextField) {
        
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
}















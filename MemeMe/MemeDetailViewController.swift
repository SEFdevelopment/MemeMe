//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Andrei Sadovnicov on 25/11/15.
//  Copyright © 2015 Andrei Sadovnicov. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    // MARK: - PROPERTIES
    
    // MARK: - Model
    var memeIndex: Int!
    
    // MARK: - AppDelegate
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    // MARK: - @IBOutlets
    @IBOutlet weak var memeDetailImageView: UIImageView!
    
    // MARK: - METHODS
    
    // MARK: - View controller life cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        let memedImage = appDelegate.memes[memeIndex].memedImage
        
        UIView.animateWithDuration(0.3, animations: {
            
            self.memeDetailImageView.image = memedImage
            
        })
        
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let navigationController = segue.destinationViewController as! UINavigationController
        
        let memeEditorViewController = navigationController.topViewController as! MemeEditorViewController
        
        memeEditorViewController.indexForMemeToEdit = memeIndex
        
    }
    
    
}

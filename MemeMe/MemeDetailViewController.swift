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
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - @IBOutlets
    @IBOutlet weak var memeDetailImageView: UIImageView!
    
    // MARK: - METHODS
    
    // MARK: - View controller life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let memedImage = appDelegate.memes[memeIndex].memedImage
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.memeDetailImageView.image = memedImage
            
        })
        
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navigationController = segue.destination as! UINavigationController
        
        let memeEditorViewController = navigationController.topViewController as! MemeEditorViewController
        
        memeEditorViewController.indexForMemeToEdit = memeIndex
        
    }
    
    
}

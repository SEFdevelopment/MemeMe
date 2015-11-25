//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Andrei Sadovnicov on 24/11/15.
//  Copyright © 2015 Andrei Sadovnicov. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
    
    // MARK: - PROPERTIES
    
    // MARK: - @IBOutlets
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: - Model
    var memes: [Meme] {
        
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        
    }
    
    // MARK: - Text attributes
    let memeTextAttributes = [
        
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!,
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSStrokeWidthAttributeName : -2.0,
        
    ]
    
    
    // MARK: - METHODS

    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureFlowLayout()
        
    }


    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView?.reloadData()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        configureFlowLayout()
        
    }
    
    
    // MARK: - Collection view flowLayout
    func configureFlowLayout() {
        
        let frameWidth = view.frame.size.width
        let frameHeight = view.frame.size.height
        let dimension: CGFloat
        
        if frameHeight >= frameWidth {
            
            dimension = (view.frame.size.width / 3.0) - 1.0
            
        } else {
            
            dimension = (view.frame.size.width / 5.0) - 1.0
            
        }
        
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
        
    }
    
    

    // MARK: - UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
        
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return memes.count
        
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memeCell", forIndexPath: indexPath) as! SentMemesCollectionViewCell
    
        if memes.count > 0 {
            
            cell.memeImageView.image = memes[indexPath.row].originalImage
            
            let topAttributedText = NSAttributedString(string: memes[indexPath.row].topText, attributes: memeTextAttributes)
            let bottomAttributedText = NSAttributedString(string: memes[indexPath.row].bottomText, attributes: memeTextAttributes)
            
            cell.topTextLabelInImage.attributedText = topAttributedText
            cell.bottomTextLabelInImage.attributedText = bottomAttributedText
            
            
        }
    
        return cell
    }

    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        if segue.identifier == "fromCollectionToDetail" {
            
            let memeDetailViewController = segue.destinationViewController as! MemeDetailViewController
            
            let indexPath = collectionView?.indexPathsForSelectedItems()![0]
            
            memeDetailViewController.memeIndex = indexPath!.row
            
        }
        
    }

    
}

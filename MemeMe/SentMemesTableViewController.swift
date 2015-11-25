//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Andrei Sadovnicov on 25/11/15.
//  Copyright © 2015 Andrei Sadovnicov. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    // MARK: - PROPERTIES
    
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

        tableView.estimatedRowHeight = 90
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
    }



    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memes.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell", forIndexPath: indexPath) as! SentMemesTableViewCell

        if memes.count > 0 {
            
            cell.memeImageView.image = memes[indexPath.row].originalImage
            
            let topAttributedText = NSAttributedString(string: memes[indexPath.row].topText, attributes: memeTextAttributes)
            let bottomAttributedText = NSAttributedString(string: memes[indexPath.row].bottomText, attributes: memeTextAttributes)
            
            cell.topTextLabelInImage.attributedText = topAttributedText
            cell.bottomTextLabelInImage.attributedText = bottomAttributedText
            
            cell.topTextLabelInRow.text = memes[indexPath.row].topText
            cell.bottomTextLabelInRow.text = memes[indexPath.row].bottomText
            
        }
        
        return cell
    }

    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
           (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
        }
 
    }
    
    
    // MARK: - Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 90
        
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "fromTableToDetail" {
            
            let memeDetailViewController = segue.destinationViewController as! MemeDetailViewController
            
            let indexPath = tableView.indexPathForSelectedRow
            
            memeDetailViewController.memeIndex = indexPath!.row
            
        }
        
    }
    
}

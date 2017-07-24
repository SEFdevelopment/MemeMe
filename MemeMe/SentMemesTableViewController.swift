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
        
        return (UIApplication.shared.delegate as! AppDelegate).memes
        
    }
    
    
    // MARK: - Text attributes
    let memeTextAttributes = [
        
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!,
        NSForegroundColorAttributeName : UIColor.white,
        NSStrokeColorAttributeName : UIColor.black,
        NSStrokeWidthAttributeName : -2.0,
        
    ] as [String : Any]
    
    
    
    // MARK: - METHODS
    
    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 90
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
    }



    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeCell", for: indexPath) as! SentMemesTableViewCell

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

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
           (UIApplication.shared.delegate as! AppDelegate).memes.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
 
    }
    
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
        
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fromTableToDetail" {
            
            let memeDetailViewController = segue.destination as! MemeDetailViewController
            
            let indexPath = tableView.indexPathForSelectedRow
            
            memeDetailViewController.memeIndex = indexPath!.row
            
        }
        
    }
    
}

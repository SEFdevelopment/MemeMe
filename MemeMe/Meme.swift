//
//  Meme.swift
//  MemeMe
//
//  Created by Andrei Sadovnicov on 22/11/15.
//  Copyright © 2015 Andrei Sadovnicov. All rights reserved.
//

import UIKit

class Meme {
    
    // MARK: - PROPERTIES
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
    
    // MARK: - INITIALIZERS
    init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
        
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
        
    }
    
    
}
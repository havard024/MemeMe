//
//  File.swift
//  MemeMe
//
//  Created by mac on 10/18/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var selectedMeme: Meme?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imageView.image = selectedMeme?.memedImage
    }
}

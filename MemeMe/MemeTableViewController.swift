//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by mac on 10/18/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // tableView.rowHeight = UITableViewAutomaticDimension
        // tableView.estimatedRowHeight = 120
        self.tableView.rowHeight = 100.0
        self.tableView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell") as? MemeTableViewCell else {
            fatalError("The dequeued cell is not an instance of MemeTableViewCell")
        }
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.topText.text = meme.topText
        cell.bottomText.text = meme.bottomText
        cell.memeImage?.image = meme.memedImage
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meme = self.memes[(indexPath as NSIndexPath).row]
        guard var viewController = storyboard?.instantiateViewController(withIdentifier: "memeDetailView") as? MemeDetailViewController else {
            fatalError("View controller with identifier 'memeDetailView' is not an instance of MemeDetailViewController")
        }
        viewController.selectedMeme = meme
        if let navigator = navigationController {
            navigator.pushViewController(viewController, animated: true)
        }
    }
}

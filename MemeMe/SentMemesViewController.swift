//
//  SentMemesViewController.swift
//  MemeMe
//
//  Created by Matthias on 16/03/15.
//

import UIKit

class SentMemesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // If no memes have been created yet, present the meme editor.
        if (UIApplication.sharedApplication().delegate as AppDelegate).memes.isEmpty {
            performSegueWithIdentifier("EditFirstMemeSegue", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? MemeViewController {
            if let cell = sender as? UITableViewCell {
                controller.image = cell.imageView?.image
            } else if let cell = sender as? MemeCollectionViewCell {
                controller.image = cell.imageView?.image
            }
        }
    }
}
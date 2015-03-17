//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Matthias on 16/03/15.
//

import UIKit

class SentMemesTableViewController: SentMemesViewController, UITableViewDataSource {

    var appDelegate: AppDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell", forIndexPath: indexPath) as UITableViewCell
        cell.imageView?.image = appDelegate.memes[indexPath.row].image
        cell.textLabel?.text = "\(appDelegate.memes[indexPath.row].topText) \(appDelegate.memes[indexPath.row].bottomText)"
        return cell
    }
}
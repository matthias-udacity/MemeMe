//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Matthias on 16/03/15.
//

import UIKit

class SentMemesCollectionViewController: SentMemesViewController, UICollectionViewDataSource {

    var appDelegate: AppDelegate!

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK UICollectionViewDataSource

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as MemeCollectionViewCell
        cell.imageView?.image = appDelegate.memes[indexPath.row].image
        return cell
    }
}

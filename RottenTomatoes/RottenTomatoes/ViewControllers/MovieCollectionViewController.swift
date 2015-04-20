//
//  MovieCollectionViewController.swift
//  RottenTomatoes
//
//  Created by Will Johansson on 2015-04-19.
//  Copyright (c) 2015 Will Johansson. All rights reserved.
//

import UIKit
import SwiftyJSON

let reuseIdentifier = "MovieCollectionCell"

struct Movie {
    let title : String
    let description : String
    let poster : String
    let posterBig : String
}

class MovieCollectionViewController: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var url : String? = nil
    var movies : [Movie] = []

    convenience init(title: String, url: String) {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())
        self.url = url
        self.title = title
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        collectionView!.delegate = self
        collectionView!.dataSource = self
        
        let cellXib = UINib(nibName: "MovieCollectionViewCell", bundle: nil)
        
        // Register cell classes
        self.collectionView!.registerNib(cellXib, forCellWithReuseIdentifier: reuseIdentifier)
        
        let request = NSURLRequest(URL: NSURL(string: url!)!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var js = JSON(data: data!)

            if let movies = js["movies"].array {
                for movie in movies {
                    let t = movie["title"].string
                    let s = movie["synopsis"].string
                    var p : String? = nil
                    var pb : String? = nil
                    if let posters = movie["posters"].dictionary {
                        p = posters["original"]!.string
                        pb = posters["original"]!.string
                        
                        var range = pb!.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
                        if let range = range {
                            pb = pb!.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
                        }
                    }
                    self.movies.append(Movie(title: t!, description: s!, poster: p!, posterBig: pb!))
                    self.collectionView?.reloadData()
                }
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView?.backgroundColor = UIColor.whiteColor()
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return movies.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MovieCollectionViewCell
    
        // Configure the cell
        
        cell.movieImageView.setImageWithURL(NSURL(string:movies[indexPath.row].poster))
        cell.movieTitle.text = movies[indexPath.row].title
        cell.movieTitle.sizeToFit()
    
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSize(width: 100, height: 150)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 25.0, left: 25.0, bottom: 25.0, right: 25.0)
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        navigationController?.pushViewController(MovieDetailViewController(movie: movies[indexPath.row]), animated: true)
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}

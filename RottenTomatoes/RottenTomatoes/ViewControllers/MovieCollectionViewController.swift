//
//  MovieCollectionViewController.swift
//  RottenTomatoes
//
//  Created by Will Johansson on 2015-04-19.
//  Copyright (c) 2015 Will Johansson. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

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
    var refreshControl : UIRefreshControl? = nil
    var errorView : UIView? = nil

    convenience init(title: String, url: String) {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())
        self.url = url
        self.title = title
        refreshControl = UIRefreshControl(frame: UIScreen.mainScreen().bounds)
        refreshControl?.addTarget(self, action: "startRefresh", forControlEvents: .ValueChanged)
        collectionView?.alwaysBounceVertical = true
        collectionView?.addSubview(refreshControl!)
        var bounds = CGRect(x: CGFloat(0), y: CGFloat(0), width: UIScreen.mainScreen().bounds.width, height: CGFloat(50))
        var textBounds = CGRect(x: CGFloat(10), y: CGFloat(0), width: CGFloat(UIScreen.mainScreen().bounds.width - 10), height: CGFloat(50))
        errorView = UIView(frame: bounds)
        errorView?.backgroundColor = UIColor.redColor()
        var errorText : UILabel = UILabel(frame: textBounds)
        errorText.textColor = UIColor.whiteColor()
        errorText.text = "An error has occurred. Please try again."
        errorView?.addSubview(errorText)
    }
    
    func startRefresh() {
        refreshData(false)
        refreshControl!.endRefreshing()
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported")
    }
    
    func refreshData(showProgressHUD: Bool) {
        if showProgressHUD {
            SVProgressHUD.show()
        }
        
        self.movies.removeAll(keepCapacity: true)
        
        let request = NSURLRequest(URL: NSURL(string: url!)!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            if showProgressHUD {
                SVProgressHUD.dismiss()
            }
            
            if let error = error {
                self.collectionView!.addSubview(self.errorView!)
                
                // 2 seconds
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
                
                dispatch_after(delayTime, dispatch_get_main_queue(), {
                    self.errorView?.removeFromSuperview()
                })
                
                return
            }
            
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView!.delegate = self
        collectionView!.dataSource = self
        
        let cellXib = UINib(nibName: "MovieCollectionViewCell", bundle: nil)
        
        self.collectionView!.registerNib(cellXib, forCellWithReuseIdentifier: reuseIdentifier)
        
        refreshData(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView?.backgroundColor = UIColor.whiteColor()
    }


    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MovieCollectionViewCell
        
        cell.movieImageView.image = nil
        cell.movieTitle.text = nil
        
        if movies.count <= indexPath.row {
            return cell
        }
        
        cell.movieImageView.setImageWithURL(NSURL(string:movies[indexPath.row].poster))
        cell.movieTitle.text = movies[indexPath.row].title
    
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

}

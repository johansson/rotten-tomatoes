//
//  CategoryListViewController.swift
//  RottenTomatoes
//
//  Created by Will Johansson on 2015-04-19.
//  Copyright (c) 2015 Will Johansson. All rights reserved.
//

import UIKit

enum MovieCategory {
    case BoxOffice
    case InTheatres
    case Opening
    case Upcoming
}

enum DVDCategory {
    case TopRentals
    case CurrentReleases
    case NewReleases
    case Upcoming
}

class CategoryListViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

    let movies = [
        MovieCategory.BoxOffice: "Box Office",
        MovieCategory.InTheatres: "In Theatres",
        MovieCategory.Opening: "Opening",
        MovieCategory.Upcoming: "Upcoming",
    ];
    
    let dvds = [
        DVDCategory.TopRentals: "Top Rentals",
        DVDCategory.CurrentReleases: "Current Releases",
        DVDCategory.NewReleases: "New Releases",
        DVDCategory.Upcoming: "Upcoming"
    ];
    
    var type : CategoryListType = .Movies

    convenience init(type: CategoryListType) {
        self.init(style: UITableViewStyle.Plain)
        self.type = type
        
        if type == .Movies {
            title = "Movies"
        } else if type == .DVDs {
            title = "DVDs"
        }
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    required init!(coder aDecoder: NSCoder!) {
        fatalError("NSCoder not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CategoryListViewCellReuseId")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryListViewCellReuseId", forIndexPath: indexPath) as! UITableViewCell

        if type == .Movies {
            cell.textLabel?.text = movies.values.array[indexPath.row]
        } else if type == .DVDs {
            cell.textLabel?.text = dvds.values.array[indexPath.row]
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if type == .Movies {
            let key = movies.keys.array[indexPath.row]
            let value = movies.values.array[indexPath.row]
            let collectionVC = MovieCollectionViewController(title: value, url: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=US")
            navigationController?.pushViewController(collectionVC, animated: true)
        } else if type == .DVDs {
            let key = dvds.keys.array[indexPath.row]
            println("DVDs -> \(dvds.values.array[indexPath.row]) pressed.")
        }
    }
}
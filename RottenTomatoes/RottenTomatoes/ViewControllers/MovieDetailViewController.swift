//
//  MovieDetailViewController.swift
//  RottenTomatoes
//
//  Created by Will Johansson on 2015-04-19.
//  Copyright (c) 2015 Will Johansson. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    
    var movie : Movie? = nil
    
    convenience init(movie: Movie) {
        self.init()
        self.movie = movie
        self.title = movie.title
    }
    
    init() {
        super.init(nibName: "MovieDetailViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTitle.text = movie!.title
        movieDescription.text = movie!.description
        movieDescription.sizeToFit()

        movieImageView.setImageWithURL(NSURL(string: movie!.poster))
        movieImageView.setImageWithURL(NSURL(string: movie!.posterBig))

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

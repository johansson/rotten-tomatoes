## Rotten Tomatoes

This is a movies app displaying box office and top rental DVDs using the [Rotten Tomatoes API](http://developer.rottentomatoes.com/docs/read/JSON).

Time spent: `approximately 15 hours`, some of which were spent retrying the project basics in multiple approaches, lots of touch ups.

### Features

#### Required

- [x] User can view a list of movies. Poster images load asynchronously.
- [x] User can view movie details by tapping on a cell.
- [x] User sees loading state while waiting for the API.
- [x] User sees error message when there is a network error: http://cl.ly/image/1l1L3M460c3C
- [x] User can pull to refresh the movie list.

#### Optional

- [ ] All images fade in.
- [x] For the larger poster, load the low-res first and switch to high-res when complete.
- [ ] All images should be cached in memory and disk: AppDelegate has an instance of `NSURLCache` and `NSURLRequest` makes a request with `NSURLRequestReturnCacheDataElseLoad` cache policy. I tested it by turning off wifi and restarting the app.
- [ ] Customize the highlight and selection effect of the cell.
- [ ] Customize the navigation bar.
- [ ] Add a tab bar for Box Office and DVD.
- [ ] Add a search bar: pretty simple implementation of searching against the existing table view data.
- [x] Table View of all Movie and DVD JSONs.

### Walkthrough
![Video Walkthrough](walkthrough.gif)

Credits
---------
* [Rotten Tomatoes API](http://developer.rottentomatoes.com/docs/read/JSON)
* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
* [SVProgressHUD](https://github.com/TransitApp/SVProgressHUD)
* Tomato icon by Marco Olgio. Retrieved from Noun project: https://thenounproject.com/term/tomato/7791/
* Clapper icon by Sam Horner. Retrieved from Noun project: https://thenounproject.com/term/clapper-board/51080/
* DVD icon by Sash. Retrieved from Noun project: https://thenounproject.com/term/cd/48534/
* Rotten Tomatoes is a trademark of Flixster, etc. THIS IS NOT AN OFFICIAL CLIENT.


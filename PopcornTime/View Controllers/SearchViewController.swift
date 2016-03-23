//
//  SearchViewController.swift
//  PopcornTime
//
//  Created by Yogi Bear on 3/19/16.
//  Copyright © 2016 PopcornTime. All rights reserved.
//

import UIKit
import PopcornKit
import TVMLKitchen
import Kingfisher

class SearchViewController: UICollectionViewController, UISearchResultsUpdating {
    
    var filteredItems = [Movie]()
    
    var filterString = "" {
        didSet {
            // Return if the filter string hasn't changed.
            guard self.filterString != oldValue else { return }
         
            NetworkManager.sharedManager().fetchMovies(limit: 50, page: 1, quality: "1080p", minimumRating: 0, queryTerm: self.filterString, genre: nil, sortBy: "download_count", orderBy: "desc") { movies, error in
                if let movies = movies {
                    self.filteredItems = movies
                    self.collectionView?.reloadSections(NSIndexSet(index: 0))
                }
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredItems.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // Dequeue a cell from the collection view.
        return collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? SearchCollectionViewCell else { fatalError("Expected to display a `SearchCollectionViewCell`.") }
        cell.movie = self.filteredItems[indexPath.row]
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let movie = self.filteredItems[indexPath.row]
        
        NetworkManager.sharedManager().showDetailsForMovie(movieId: movie.id, withImages: false, withCast: true) { movie, error in
            if let movie = movie {
                NetworkManager.sharedManager().suggestionsForMovie(movieId: movie.id, completion: { movies, error in
                    if let movies = movies {
                        let product = ProductRecipe(movie: movie, suggestions: movies)
                        Kitchen.serve(recipe: product)
                    } else if let _ = error {
                        
                    }
                })
            } else if let _ = error {
                
            }
        }
    }
    
    // MARK: UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.filterString = searchController.searchBar.text ?? ""
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}

class SearchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var movie: Movie! {
        didSet {
            self.label.text = movie.title
            self.imageView.kf_setImageWithURL(NSURL(string: movie.mediumCoverImage)!)
        }
    }
    
    // MARK: Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // These properties are also exposed in Interface Builder.
        self.imageView.adjustsImageWhenAncestorFocused = true
        
        self.label.alpha = 0.0
    }
    
    // MARK: UICollectionReusableView
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.image = nil
        
        // Reset the label's alpha value so it's initially hidden.
        self.label.alpha = 0.0
    }
    
    // MARK: UIFocusEnvironment
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        /*
        Update the label's alpha value using the `UIFocusAnimationCoordinator`.
        This will ensure all animations run alongside each other when the focus
        changes.
        */
        coordinator.addCoordinatedAnimations({ [unowned self] in
            if self.focused {
                self.label.alpha = 1.0
            }
            else {
                self.label.alpha = 0.0
            }
        }, completion: nil)
    }
}

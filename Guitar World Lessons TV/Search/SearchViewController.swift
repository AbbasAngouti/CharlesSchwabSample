//
//  SearchViewController.swift
//  Guitar World Lessons TV
//
//  Created by Abbas Angouti on 11/19/15.
//  Copyright © 2015 Giant Interactive. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showSearchCollectionViewController(sender: AnyObject) {
        //        let storyBoard = UIStoryboard(name: "Browse", bundle: NSBundle.mainBundle())
        
        guard let resultsController = self.storyboard!.instantiateViewControllerWithIdentifier("SearchCollectionViewController") as? SearchCollectionViewController else { fatalError("Unable to instantiate a SearchResultsViewController.") }
        
        // Create and configure a `UISearchController`.
        let searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = resultsController
        searchController.hidesNavigationBarDuringPresentation = false
        
        let searchPlaceholderText = NSLocalizedString("Enter keyword (e.g. blues)", comment: "")
        searchController.searchBar.placeholder = searchPlaceholderText
//        searchController.searchBar.keyboardAppearance = .Default
        
        // Present the search controller
        presentViewController(searchController, animated: true, completion: nil)
    }
}
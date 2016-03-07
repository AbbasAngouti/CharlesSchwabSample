//
//  SearchCollectionViewController.swift
//  Guitar World Lessons TV
//
//  Created by Abbas Angouti on 11/24/15.
//  Copyright © 2015 Giant Interactive. All rights reserved.
//

import UIKit


class SearchCollectionViewController: UICollectionViewController, UISearchResultsUpdating {

    private var allProducts = [ProductOnlyItem]()
    private let cellComposer = DataItemCellComposer()
    
    private var filteredProducts = [ProductOnlyItem]()
    
    var filterString = "" {
        didSet {
            // Return if the filter string hasn't changed.
            guard filterString != oldValue else { return }
            
            // Apply the filter or show all items if the filter string is empty.
            if filterString.isEmpty {
                filteredProducts = allProducts
            }
            else {
                filteredProducts = allProducts.filter { $0.title.localizedStandardContainsString(filterString) }
            }
            
            // Reload the collection view to reflect the changes.
            collectionView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let collectionView = collectionView else { return }

        collectionView.maskView = GradientMaskView(frame: CGRect(origin: CGPoint.zero, size: collectionView.bounds.size))
        
        listProductOnlyOnComplete(.Browse) { (products) -> () in
            self.allProducts = products!
            self.filteredProducts = products!
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.collectionView?.reloadData()
                print(self.allProducts.count)
            })
        }
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.view.backgroundColor = UIColor.clearColor()
        
        guard let collectionView = collectionView, maskView = collectionView.maskView as? GradientMaskView else { return }
        
        /*
        Update the mask view to have fully faded out any collection view
        content above the navigation bar's label.
        */
        maskView.maskPosition.end = topLayoutGuide.length * 0.8
        
        /*
        Update the position from where the collection view's content should
        start to fade out. The size of the fade increases as the collection
        view scrolls to a maximum of half the navigation bar's height.
        */
        let maximumMaskStart = maskView.maskPosition.end + (topLayoutGuide.length * 0.5)
        let verticalScrollPosition = max(0, collectionView.contentOffset.y + collectionView.contentInset.top)
        maskView.maskPosition.start = min(maximumMaskStart, maskView.maskPosition.end + verticalScrollPosition)
        
        /*
        Position the mask view so that it is always fills the visible area of
        the collection view.
        */
        maskView.frame = CGRect(origin: CGPoint(x: 0, y: collectionView.contentOffset.y), size: collectionView.bounds.size)
    }
    
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? ProductItemCollectionViewCell else { fatalError("Expected to display a `ProductItemCollectionViewCell`.") }
        let item = self.filteredProducts[indexPath.row]
        
        // Configure the cell.
        cellComposer.composeCell(cell, withDataItem: item, type: "non-featured")
    }
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        let productVC = mainSB.instantiateViewControllerWithIdentifier("ProductViewController") as! ProductViewController
        productVC.productUUID = filteredProducts[indexPath.row].uuid
        presentViewController(productVC, animated: true, completion: { () -> Void in
            
        })
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredProducts.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier("SearchCell", forIndexPath: indexPath)
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
    
    // MARK: UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterString = searchController.searchBar.text ?? ""
    }


}

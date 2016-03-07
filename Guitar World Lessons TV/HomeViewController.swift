//
//  ViewController.swift
//  Guitar World Lessons TV
//
//  Created by Abbas Angouti on 10/30/15.
//  Copyright © 2015 Giant Interactive. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var containerScrollView: UIScrollView!
        
    @IBOutlet var featuredCollectionView : UICollectionView!
    @IBOutlet var topSellerCollectionView : UICollectionView!
    @IBOutlet var freeLessonsCollectionView : UICollectionView!
    
    private let cellComposer = DataItemCellComposer()
    
    var collectionViews = [UICollectionView]()

    var featuredItems = [FeaturedItem]()
    var topSellers = [ProductOnlyItem]()
    var freeLessons = [ProductOnlyItem]()
    
    let reuseIdentifierFeatured = "FeaturedCell"
    let reuseIdentifierTopSellers = "TopSellersCell"
    let reuseIdentifierFreeLessons = "FreeLessonsCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listFeaturedOnComplete { (result) -> () in
            if let featured = result as [FeaturedItem]! {
                self.featuredItems = featured
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.featuredCollectionView.reloadData()
                })
            }
        }
        
        listProductOnlyOnComplete(.Top) { (result) -> () in
            if let topSellers = result as [ProductOnlyItem]! {
                self.topSellers = topSellers
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.topSellerCollectionView.reloadData()
                })
            }
        }
        
        listProductOnlyOnComplete(.Free) { (result) -> () in
            if let freeLessons = result as [ProductOnlyItem]! {
                self.freeLessons = freeLessons
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.freeLessonsCollectionView.reloadData()
                })
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerScrollView.contentSize = CGSizeMake(1920, 1600)
    }
    
    // MARK: UICollectionViewDelegate methods
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? ProductItemCollectionViewCell else { fatalError("Expected to display a `ProductItemCollectionViewCell`.") }
        var type: String = ""
        var item: ProductOnlyItem?
        if collectionView == featuredCollectionView {
            let featuredItem = self.featuredItems[indexPath.row]
            item = ProductOnlyItem(difficulty: "", genre: "", guitarType: "", instructor: "", price: "", thumbnailUrl: featuredItem.featuredImage, thumbnailUrlMd: "", title: featuredItem.title, tuning: "", uuid: featuredItem.uuid)
            type = "featured"
        } else if collectionView == topSellerCollectionView {
            item = self.topSellers[indexPath.row]
            type = "non-featured"
        } else if collectionView == freeLessonsCollectionView {
            item = self.freeLessons[indexPath.row]
            type = "non-featured"
        }
        
        cellComposer.composeCell(cell, withDataItem: item!, type: type)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 50
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 50
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0.0, left: 50.0, bottom: 0.0, right: 50.0)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        let cellCount: Int
        switch collectionView {
            case featuredCollectionView:
                cellCount = featuredItems.count
            case topSellerCollectionView:
                cellCount = topSellers.count
            case freeLessonsCollectionView:
                cellCount = freeLessons.count
            default:
                cellCount = 0
        }
        return cellCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case featuredCollectionView:
            return collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifierFeatured, forIndexPath: indexPath)
        case topSellerCollectionView:
            return collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifierTopSellers, forIndexPath: indexPath)
        default: // freeLessonsCollectionView:
            return collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifierFreeLessons, forIndexPath: indexPath)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var tappedUuid = ""
        switch collectionView {
            case featuredCollectionView:
                tappedUuid = featuredItems[indexPath.row].uuid
                break
            case topSellerCollectionView:
                tappedUuid = topSellers[indexPath.row].uuid
                break
            case freeLessonsCollectionView:
                tappedUuid = freeLessons[indexPath.row].uuid
                break

            default: break
        }
        
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        let productVC = mainSB.instantiateViewControllerWithIdentifier("ProductViewController") as! ProductViewController
        productVC.productUUID = tappedUuid
        presentViewController(productVC, animated: true, completion: { () -> Void in
//            ND.addObserver(self, selector: "switchToLoginPage:", name: NOTIFICATION_SWITCH_TO_LOGIN_PAGE, object: nil)
        })
    }

//    func switchToLoginPage(notification: NSNotification) {
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            self.tabBarController?.selectedIndex = 5
//        })
//    }
}


//
//  MyLibraryViewController.swift
//  Guitar World Lessons TV
//
//  Created by Abbas Angouti on 11/6/15.
//  Copyright © 2015 Giant Interactive. All rights reserved.
//

import UIKit

class MyLibraryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var lessonsCollectionView: UICollectionView!
    
    @IBOutlet weak var blackBarView: UIView!
    @IBOutlet weak var productTitleLabel: UILabel!
    
    var indicatorContainer = UIView()
    
    var notLoggedInView = UIView()
    var loginButton = UIButton()
    var messageTextView = UITextView()
    
    private let productCellComposer = DataItemCellComposer()
    private let lessonCellComposer = MyLibraryLessonCellComposer()
    
    var productsDict = [String: MyLibraryProductItem]()
    var productsArray = [MyLibraryProductItem]()
    var lessons = [MyLibraryLessonItem]()
    
    var selectedProductUuid: String = "" {
        willSet {
            self.productTitleLabel.text = self.productsDict[newValue]!.title
            self.blackBarView.hidden = false
        }
    }
    
    let reuseIdentifierMyLibraryProduct = "MyLibraryProductCell"
    let reuseIdentifierMyLibraryLesson = "MyLibraryLessonCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productsCollectionView.dataSource = self
        productsCollectionView.delegate = self
        
        lessonsCollectionView.dataSource = self
        lessonsCollectionView.delegate = self
        
        shouldReloadMyLibrary = true
   }
    
    override var preferredFocusedView: UIView? {
        if loggedIn() {
            return productsCollectionView
        } else {
            return loginButton
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        hideActivityIndicator()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !loggedIn() {
            notLoggedInView = UIView(frame: CGRectMake(0, 0, 1920, 1080))
            notLoggedInView.backgroundColor = UIColor.whiteColor()
            
            messageTextView = UITextView(frame: CGRectMake(387, 164, 1147, 190))
            messageTextView.font = UIFont.systemFontOfSize(46, weight: UIFontWeightMedium)
            messageTextView.text = "You need to log in or create an account to purchase lessons or products or see your library."
            messageTextView.userInteractionEnabled = false
            notLoggedInView.addSubview(messageTextView)
            
            loginButton = UIButton(type: UIButtonType.System)
            loginButton.frame = CGRectMake(863, 397, 195, 70)
            
            loginButton.addTarget(self, action: "loginTapped:", forControlEvents: UIControlEvents.PrimaryActionTriggered)
            loginButton.setTitle("Log in", forState: UIControlState.Normal)
            notLoggedInView.addSubview(loginButton)
            
            self.view.addSubview(notLoggedInView)
        } else if shouldReloadMyLibrary {
            self.blackBarView.hidden = true
            notLoggedInView.removeFromSuperview()
            self.showActivityIndicator()
            FIXME()
            // TODO: what if somebody quits the page? think of NSOperate()
            listLibraryOnComplete { (result) -> Void in
                guard result != nil else {
                    print("Empty result!")
                    return
                }
                self.productsDict = result!
                self.productsArray = []
                for product in self.productsDict.values {
                    self.productsArray.append(product)
                }
                self.lessons = self.productsArray[0].lessons
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.productsCollectionView.reloadData()
                    self.hideActivityIndicator()
                    self.selectedProductUuid = self.productsArray[0].uuid
                    self.lessonsCollectionView.reloadData()
                    shouldReloadMyLibrary = false
                })
            }
        }
    }
    
    
    func loginTapped(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tabBarController?.selectedIndex = 5
        })
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let collectionViews = [productsCollectionView, lessonsCollectionView]
        
        for collectionView in collectionViews {
            guard let maskView = collectionView.maskView as? GradientMaskView else { return }
            
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
    }
    
    // MARK: Show/Hide Activity Indicator
    func hideActivityIndicator() {
        self.indicatorContainer.removeFromSuperview()
    }
    
    func showActivityIndicator() {
        indicatorContainer = UIView(frame: CGRectMake(0, 0, 1920, 1080))
//        indicatorContainer.center = view.center
        indicatorContainer.backgroundColor = UIColorFromHex(0xffffff, alpha: 1)
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRectMake(0, 0, 80, 80)
        loadingView.center = indicatorContainer.center
        loadingView.backgroundColor = UIColorFromHex(0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        actInd.center = CGPointMake(loadingView.frame.size.width / 2, loadingView.frame.size.height / 2);
        loadingView.addSubview(actInd)
        indicatorContainer.addSubview(loadingView)
        view.addSubview(indicatorContainer)
        actInd.startAnimating()
    }
    
    // MARK: UICollectionViewDelegate methods
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == productsCollectionView {
            guard cell is ProductItemCollectionViewCell else {
                fatalError("Expected to display a `ProductItemCollectionViewCell`.")
            }
            let product = self.productsArray[indexPath.row]
            let item = ProductOnlyItem(difficulty: product.difficulty, genre: product.genre, guitarType: product.guitarType, instructor: product.instructor, price: product.price, thumbnailUrl: product.thumbnailUrl, thumbnailUrlMd: product.thumbnailUrlMd, title: product.title, tuning: product.tuning, uuid: product.uuid)
            
            // Configure the cell.
            productCellComposer.composeCell(cell, withDataItem: item, type: "non-featured")
        } else {
            guard let cell = cell as? LessonItemCollectionViewCell else {
                fatalError("Expected to display a `LessonItemCollectionViewCell`.")
            }
            let lesson = self.lessons[indexPath.row]
            
            cell.backgroundGrayView.layer.cornerRadius = 20
            
            // Configure the cell.
            lessonCellComposer.composeCell(cell, withDataItem: lesson)
            cell.parentVC = self
            cell.lesson = lesson
        }
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
        if collectionView == productsCollectionView {
            return productsArray.count
        } else {
            return lessons.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView == productsCollectionView {
            return collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifierMyLibraryProduct, forIndexPath: indexPath)
        } else {
            return collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifierMyLibraryLesson, forIndexPath: indexPath)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == productsCollectionView {
            let focusedProductUuid = productsArray[indexPath.row].uuid
            self.selectedProductUuid = focusedProductUuid
            
            lessons = (productsDict[focusedProductUuid]?.lessons)!
            lessons = lessons.sort({ (lesson0: MyLibraryLessonItem, lesson1: MyLibraryLessonItem) -> Bool in
                return lesson0.order < lesson1.order
            })
            lessonsCollectionView.reloadData()
        }
        if collectionView == lessonsCollectionView {
        }
    }
    
    func collectionView(collectionView: UICollectionView, didUpdateFocusInContext context: UICollectionViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
    }

    
    // MARK: - Play video
    func playVideoForLesson(lesson: MyLibraryLessonItem) {
        let videoPlayer = VideoPlayer()
        videoPlayer.playVideo(lesson.video)
        [self.presentViewController(videoPlayer, animated: true, completion: nil)]
    }
}

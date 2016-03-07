//
//  ProductViewController.swift
//  Guitar World Lessons TV
//
//  Created by Abbas Angouti on 11/17/15.
//  Copyright © 2015 Giant Interactive. All rights reserved.
//

import UIKit
import StoreKit

class ProductViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var productUUID = ""
    
    private var productMetaData: Product?
    private var lessons = [MyLibraryLessonItem]()
    private var itemiTunesUuidToPurchase = ""
    private var itemUuidToPurchase = ""
    private var itemPriceToPurchase: Float = 0.0
    private var isProductToBePurchased = false
    
    let reuseIdentifierProductLesson = "ProductLessonCell"
    
    private var focusGuide = UIFocusGuide()
    
    private let lessonCellComposer = MyLibraryLessonCellComposer()
    
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var albumPurchaseButton: UIButton!
    
    @IBOutlet weak var synopsisOrInstructorTextView: UITextView!
    @IBOutlet weak var lessonsCollectionView: UICollectionView!
    @IBOutlet weak var synopsisButton: UIButton!
    @IBOutlet weak var instructorButton: UIButton!
    @IBOutlet weak var synopsisOrInstructorTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addLayoutGuide(self.focusGuide)
        
        synopsisOrInstructorTextView.userInteractionEnabled = true
        synopsisOrInstructorTextView.selectable = true
        synopsisOrInstructorTextView.scrollEnabled = true
        synopsisOrInstructorTextView.panGestureRecognizer.allowedTouchTypes = [UITouchType.Indirect.rawValue]
        
        focusGuide.leftAnchor.constraintEqualToAnchor(albumPurchaseButton.leftAnchor).active = true
        focusGuide.topAnchor.constraintEqualToAnchor(synopsisButton.topAnchor).active = true
        focusGuide.widthAnchor.constraintEqualToAnchor(albumPurchaseButton.widthAnchor).active = true
        focusGuide.heightAnchor.constraintEqualToAnchor(synopsisButton.heightAnchor).active = true
        
        lessonsCollectionView.dataSource = self
        lessonsCollectionView.delegate = self
        
        coverImageView.layer.shadowOpacity = 0.5;
        coverImageView.layer.shadowOffset = CGSizeMake(0.0, 0.5);
        coverImageView.layer.shadowRadius = 5.0;
        
        instructorButton.hidden = true
        synopsisButton.hidden = true
        self.coverImageView.hidden = true
        
        refreshItemData()
    }
    
    override var preferredFocusedView: UIView? {
        return lessonsCollectionView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // TODO: - if this is the only collectionview, remove this array and modify the code appropriately
        let collectionViews = [lessonsCollectionView]
        
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
    
    
    override func viewWillAppear(animated: Bool) {
        ND.removeObserver(self, name: NOTIFICATION_ITEM_PURCHASED, object: nil)
        ND.addObserver(self, selector: "itemPurchased:", name: NOTIFICATION_ITEM_PURCHASED, object: nil)
        
        ND.removeObserver(self, name: NOTIFICATION_ITEM_PURCHASE_FAILED, object: nil)
        ND.addObserver(self, selector: "itemPurchasedFailed:", name: NOTIFICATION_ITEM_PURCHASE_FAILED, object: nil)
        
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
//        refreshItemData()
        super.viewDidAppear(animated)
    }
    
    func refreshItemData() {
        getInfoForUuid(productUUID, success: { (successResult) -> () in
            let success = successResult["success"] as! Bool
            if success {
                self.lessons.removeAll()
                
                let parentDict = successResult["parent"] as! [String: AnyObject]
                
                let infoDict = parentDict["info"] as! [String: AnyObject]
                let artists = (infoDict["artists"] as? [String]) ?? [""]
                let difficulties = (infoDict["difficulties"] as? [String]) ?? [""]
                let genres = infoDict["genres"] as! [String]
                let guitarTypes = infoDict["guitar_types"] as! [String]
                let techniquesUsed = infoDict["techniques_used"] as! [String]
                let tunings = infoDict["tunings"] as! [String]
                let instructorName = infoDict["instructor_name"] as! String
                let runTime = infoDict["runtime"] as! String
                let priceStr = infoDict["price"] as! String
                let price = Float(priceStr)!
                let productInfo = ProductInfo(artists: artists, difficulties: difficulties, genres: genres, guitarTypes: guitarTypes, techniquesUsed: techniquesUsed, tunings: tunings, instructorName: instructorName, runTime: runTime, price: price)
                
                let instructorDict = parentDict["instructor"] as! [String: AnyObject]
                let instructorBio = instructorDict["instructor_bio"] as! String
                let instructorNameRedundance = infoDict["instructor_name"] as! String
                let productInstructor = ProductInstructor(instructorBio: instructorBio, instructorName:  instructorNameRedundance)
                
                let title = (parentDict["title"] as! String).decodeEnt()
                // TODO: can we use this image for other pages, too? like Free, Top, Browser, Search,
                let sourceImage = parentDict["source_image"] as! String
                let infoHtml = parentDict["info_html"] as! String
                let instructorHtml = (parentDict["instructor_html"] as! String).decodeEnt()
                let itunesUuid = parentDict["itunes_uuid"] as! String
                let pdf = parentDict["pdf"] as! String
                let synopsis = (parentDict["synopsis"] as! String).decodeEnt()
                let video = parentDict["video"] as! String
                let isFree = parentDict["is_free"] as! Bool
                let productIsLicensed = parentDict["is_licensed"] as! Bool
                
                self.productMetaData = Product(info: productInfo, instructor: productInstructor, infoHtml: infoHtml, instructorHtml: instructorHtml, iTunesUuid: itunesUuid, pdf: pdf, sourceImage: sourceImage, synopsis: synopsis, title: title, video: video, isFree: isFree, isLicensed: productIsLicensed)
                
                // let's get lessons
                let lessonsDictArray = successResult["children"] as! [[String: AnyObject]]
                for lessonDict in lessonsDictArray {
                    let iTunesUuid = lessonDict["itunes_uuid"] as! String
                    let isFree = lessonDict["is_free"] as! Bool
                    let lessonDescription = (lessonDict["description"] as! String).decodeEnt()
                    var difficulty = "" // difficulty is not available in some JSON results
                    if let optionalDifficulty = (lessonDict["difficulty"] as? String) {
                        difficulty = optionalDifficulty
                    }
                    let genre = (lessonDict["genre"] as? String) ?? ""
                    let guitarType = (lessonDict["guitar_type"] as? String) ?? "" // guitar_type
                    let infoHtml = lessonDict["info_html"] as! String // guitar_type
                    let instructor = (lessonDict["instructor"] as? String) ?? ""
                    let isLicensed = lessonDict["is_licensed"] as! Bool
                    let price = (lessonDict["price"] as? String) ?? ""
                    let pdf = lessonDict["pdf"] as! String
                    let runtime = lessonDict["runtime"] as! String
                    let thumbnailUrl = (lessonDict["thumbnail_url"] as? String) ?? "" // thumbnail_url
                    let lessonTitle = (lessonDict["title"] as! String).decodeEnt()
                    let tuning = (lessonDict["tuning"] as? String) ?? ""
                    let uuid = lessonDict["uuid"] as! String
                    let video = lessonDict["video"] as! String
                    let order = lessonDict["order"] as! Int
                    
                    let aLesson = MyLibraryLessonItem(lessonDescription: lessonDescription, difficulty: difficulty, genre: genre, guitarType: guitarType, infoHtml: infoHtml, isFree: isFree, instructor: instructor, isLicensed: isLicensed, iTunesUuid: iTunesUuid, price: price, pdf: pdf, runtime: runtime, thumbnailUrl: thumbnailUrl, title: lessonTitle, tuning: tuning, uuid: uuid, video: video, order: order)
                    
                    self.lessons.append(aLesson)
                    
                }
                
                self.lessons.sortInPlace({ (lesson0: MyLibraryLessonItem, lesson1: MyLibraryLessonItem) -> Bool in
                    return lesson0.order < lesson1.order
                })
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let allLessonsLicensed = self.lessons.reduce(false, combine: { (Bool, lesson) -> Bool in
                        return true && lesson.isLicensed
                    })
                    if productIsLicensed || allLessonsLicensed {
                        self.albumPurchaseButton.hidden = true
                        self.albumPurchaseButton.enabled = false
                    } else {
                        self.albumPurchaseButton.hidden = false
                        self.albumPurchaseButton.enabled = true
                    }
                    ImageLoader.sharedLoader.imageForUrl(sourceImage, completionHandler: { (image, url) -> () in
                        self.coverImageView.image = image
                        self.albumPurchaseButton.setTitle("$\(price) Buy", forState: UIControlState.Normal)
                        self.productTitle.text = title
                        self.synopsisOrInstructorTextView.text = self.productMetaData!.synopsis
                        self.synopsisOrInstructorTitleLabel.text = "Synopsis"
                        self.instructorButton.hidden = false
                        self.synopsisButton.hidden = false
                        self.coverImageView.hidden = false
                        self.lessonsCollectionView.reloadData()
                    })
                })
            }
            
            }) { (failureResult) -> () in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    //TODO: show the error message in an alert view
                })
                print(failureResult)
        }
    }
    
    func showActivityIndicatorWithMessage(message: String) {
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        let activityIndicatorVC = mainSB.instantiateViewControllerWithIdentifier("ActivityIndicatorViewController") as! ActivityIndicatorViewController
        activityIndicatorVC.message = message
        presentViewController(activityIndicatorVC, animated: true, completion: { () -> Void in
            
        })
    }
    
    // MARK: - purchase whole procust
    @IBAction func buyAll(sender: UIButton) {
        if loggedIn() {
            if !productsOniTunesConnectedLoaded {
                showActivityIndicatorWithMessage("Please wait while fetching the list of products to purchase.")
            } else {
                if getProductIdsOniTunesConnect().contains(productMetaData!.iTunesUuid) {
                    var itemToPurchase = SKProduct()
                    itemUuidToPurchase = self.productUUID
                    itemiTunesUuidToPurchase = productMetaData!.iTunesUuid
                    itemPriceToPurchase = productMetaData!.info.price
                    isProductToBePurchased = true
                    let productsToPurchase = GWIAPHelper.sharedInstance.productsToPurchase
                    for (_, product) in productsToPurchase.enumerate() {
                        if product.productIdentifier == self.itemiTunesUuidToPurchase {
                            itemToPurchase = product
                            break
                        }
                    }
                    
                    let payment = SKPayment(product: itemToPurchase)
                    if !payment.productIdentifier.isEmpty {
                        self.showActivityIndicatorWithMessage("Wait while registering your purchase!")
                        GWIAPHelper.sharedInstance.buyProduct(itemToPurchase, withUuid: productUUID)
                    } else {
                        // TODO: take care of empty product id. will it happen at all?
                    }
                    
                }
            }
            
        } else { // login required to do the purchase
            showLoginNeed()
        }
    }
    
    func showLoginNeed() {
        let title = NSLocalizedString("Log in required!", comment: "")
        let message = NSLocalizedString("You need to log in or create an account to purchase lessons or products.", comment: "")
        let loginButtonTitle = NSLocalizedString("OK", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        // Create the actions.
        let loginAction = UIAlertAction(title: loginButtonTitle, style: .Cancel) { _ in
        }
        
        // Add the actions.
        alertController.addAction(loginAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Purchase resutls
    func itemPurchased(notification: NSNotification) {
        //        let uuidDict = notification.userInfo as! [String: String]
        //        if itemUuidToPurchase == productIdentifier && uuidDict["uuid"]! == productUUID {
        saveLicenseForUUID(itemUuidToPurchase, authCode: "zzz", amount: itemPriceToPurchase, onSuccess: { (successResult) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                ND.postNotificationName(NOTIFICATION_FINILIZE_PURCHASE, object: nil)
                print("A product/lesson registered!")
                shouldReloadMyLibrary = true
                if !self.isProductToBePurchased {
                    for lesson in self.lessons {
                        if lesson.uuid == self.itemUuidToPurchase {
                            lesson.isLicensed
                        }
                    }
                }
                setShouldUpdateLibrary(true)
                self.refreshItemData()
            })
            }, onFailure: { (failureResult) -> () in
                print("a product couldn't register!")
                print("failure result: \(failureResult)");
                //TODO: show an alert view saying: "Purchase failed"
        })
        //        }
    }
    
    func itemPurchasedFailed(notification: NSNotification) {
        let productIdentifier = notification.object as! String
        let uuidDict = notification.userInfo as! [String: String]
        
        ND.postNotificationName(NOTIFICATION_FAILED_PURCHASE, object: self)
        
        if itemUuidToPurchase == productIdentifier && uuidDict["uuid"]! == productUUID {
            // TODO: so what?
        }
    }
    
    // MARK: UICollectionViewDelegate methods
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        guard let cell = cell as? LessonItemCollectionViewCell else {
            fatalError("Expected to display a `LessonItemCollectionViewCell`.")
        }
        let optionalLesson: MyLibraryLessonItem? = lessons[indexPath.row]
        if let lesson = optionalLesson {
            cell.backgroundGrayView.layer.cornerRadius = 20
            //        cell.playOrPurchaseImageView.layer.cornerRadius = 10
//            FIXME()
            // comment out the line below
            //        cell.playOrPurchaseImageView.image = textOverImage("Play", inImage: UIImage(named: "playOrBuyButtonBackgroundImage")!, atPoint: cell.playOrPurchaseImageView.center)
//            if lesson.isLicensed || lesson.isFree {
//                //            cell.backgroundGrayView.backgroundColor = UIColor.blueColor()
//            } else {
//                cell.backgroundGrayView.backgroundColor = UIColor.grayColor()
//            }
            
            // Configure the cell.
            lessonCellComposer.composeCell(cell, withDataItem: lesson)
            cell.lesson = self.lessons[indexPath.row]
            cell.parentVC = self
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
            return UIEdgeInsets(top: 20.0, left: 50, bottom: 20.0, right: 50)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return lessons.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifierProductLesson, forIndexPath: indexPath)
    }
    
    
    func playOrpurchaseLesson(lesson: MyLibraryLessonItem) {
        if loggedIn() {
            if lesson.isLicensed { // already purchased. play the video
                self.playVideoWithUrl(lesson.video)
            } else { // buy it
                if !productsOniTunesConnectedLoaded {
                    showActivityIndicatorWithMessage("Please wait while fetching the list of products to purchase or register if the product is free.")
                } else {
                    if getProductIdsOniTunesConnect().contains(lesson.iTunesUuid) {
                        var itemToPurchase = SKProduct()
                        itemiTunesUuidToPurchase = lesson.iTunesUuid
                        itemUuidToPurchase = lesson.uuid
                        isProductToBePurchased = false
                        itemPriceToPurchase = Float(lesson.price)!
                        let lessonsToPurchase = GWIAPHelper.sharedInstance.productsToPurchase
                        for (_, lessonItem) in lessonsToPurchase.enumerate() {
                            if lessonItem.productIdentifier == self.itemiTunesUuidToPurchase {
                                itemToPurchase = lessonItem
                                break
                            }
                        }
                        
                        let payment = SKPayment(product: itemToPurchase)
                        if !payment.productIdentifier.isEmpty {
                            self.showActivityIndicatorWithMessage("Wait while registering your purchase!")
                            GWIAPHelper.sharedInstance.buyProduct(itemToPurchase, withUuid: productUUID)
                        } else {
                            // TODO: take care of empty product id. will it happen at all?
                        }
                    }
                }
            }
        } else { // login required to do the purchase
            showLoginNeed()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func collectionView(collectionView: UICollectionView, didUpdateFocusInContext context: UICollectionViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
    }
    
    
    func textOverImage(drawText: NSString, inImage: UIImage, atPoint:CGPoint)->UIImage{
        
        // Setup the font specific variables
        let textColor: UIColor = UIColor.redColor()
        let textFont: UIFont = UIFont(name: "Helvetica Bold", size: 40)!
        
        //Setup the image context using the passed image.
        UIGraphicsBeginImageContext(inImage.size)
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
        ]
        
        //Put the image into a rectangle as large as the original image.
        inImage.drawInRect(CGRectMake(0, 0, inImage.size.width, inImage.size.height))
        
        // Creating a point within the space that is as bit as the image.
        let rect: CGRect = CGRectMake(atPoint.x, atPoint.y, inImage.size.width, inImage.size.height)
        
        //Now Draw the text into an image.
        drawText.drawInRect(rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //And pass it back up to the caller.
        return newImage
    }

    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocusInContext(context, withAnimationCoordinator: coordinator)
        
        guard let nextFocusedView = context.nextFocusedView else { return }
        
        // When the focus engine focuses on the focus guide, we can programmatically tell it which element should be focused next.
        switch nextFocusedView {
        case self.synopsisButton:
            self.focusGuide.preferredFocusedView = self.albumPurchaseButton
            
        case self.albumPurchaseButton:
            self.focusGuide.preferredFocusedView = self.synopsisButton
            
        default:
            self.focusGuide.preferredFocusedView = nil
        }
        
        if self.synopsisOrInstructorTextView.focused {
            synopsisOrInstructorTextView.textColor = UIColor.whiteColor()
            synopsisOrInstructorTextView.backgroundColor = UIColor.darkGrayColor()
            synopsisOrInstructorTextView.layer.cornerRadius = 10
        } else {
            synopsisOrInstructorTextView.textColor = UIColor.blackColor()
            synopsisOrInstructorTextView.backgroundColor = UIColor.clearColor()
            synopsisOrInstructorTextView.layer.cornerRadius = 0
        }
    }
    
    // MARK: - Play video 
    func playVideoWithUrl(url: String) {
        let videoPlayer = VideoPlayer()
        videoPlayer.playVideo(url)
        [self.presentViewController(videoPlayer, animated: true, completion: nil)]
    }
    
    
    // MARK: - Pop up synopsis or instructor
    func showSynopsisOrInstrocutorWithTitleForLesson(lesson: MyLibraryLessonItem) {
        let soiVC = storyboard!.instantiateViewControllerWithIdentifier("synopsisOrInstructorViewController") as! SynopsisOrInstructorViewController
        soiVC.lesson = lesson
        soiVC.parentVC = self
        presentViewController(soiVC, animated: true) { }
    }
    
    @IBAction func synopsisOrInstructorTapped(sender: AnyObject) {
        let tappedButton = sender as! UIButton
        if tappedButton.tag == 100 {
            synopsisOrInstructorTextView.text = self.productMetaData!.synopsis
            synopsisOrInstructorTitleLabel.text = "Synopsis"
        } else if tappedButton.tag == 200 {
            synopsisOrInstructorTextView.text = self.productMetaData!.instructorHtml
            synopsisOrInstructorTitleLabel.text = "Instructor"
        }
    }
    
}

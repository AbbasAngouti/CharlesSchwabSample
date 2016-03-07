//
//  Constants.swift
//  Guitar World Lessons TV
//
//  Created by Abbas Angouti on 10/30/15.
//  Copyright © 2015 Giant Interactive. All rights reserved.
//

import Foundation
import UIKit
import StoreKit

let URL_SERVICES = "https://guitarworldlessons.com"
let CONFIG_SERVICES_URL = "services_url"
let CONFIG_SESSION = "GWConfigSession"
let CONFIG_FEATURED_ITEMS = "GWConfigStoreFeatured"
let CONFIG_TOPSELLERS_TIEMS = "GWConfigTopSellers"
let CONFIG_FREELESSONS_ITEMS = "GWConfigFreeLessons"
let CONFIG_ALL_PRODUCTONLY_ITEMS = "GWConfigAllProductOnly"
let CONFIG_USERNAME = "GWConfigUsername"
let CONFIG_PASSWORD = "GWConfigPassword"
let CONFIG_USER_ID = "GWConfigUserId"
let CONFIG_SUBSCRIBED = "GWConfigSubscribed"
let CONFIG_PRODUCT_IDS_ON_ITUES_CONNECT = "GWConfigProductIdsOniTunesConnect"
let CONFIG_PURCHASE_LICENSE_LIST = "GWConfigPurchaseLicenseList"
let CONFIG_SHOULD_UPDATE_LIBRARY = "GWConfigShouldUpdateLibrary"

let NOTIFICATION_ITEM_PURCHASED       = "GWIAPHelperItemPurchasedNotification"
let NOTIFICATION_ITEM_PURCHASE_FAILED = "GWIAPHelperItemPurchaseFailedNotification"
let NOTIFICATION_PRODUCTS_ON_ITUNES_CONNECTED_LOADED = "GWProductsOniTunesConnectedLoadedNotification"
//let NOTIFICATION_SWITCH_TO_LOGIN_PAGE = "GWSwitchToLoginPageNotification"
let NOTIFICATION_FINILIZE_PURCHASE = "GWFinalizePurchaseNotification"
let NOTIFICATION_FAILED_PURCHASE = "GWFailedPurchaseNotification"

let CONFIG_PRODUCTS_ON_ITUNES_CONNECTED_LOADED = "GWConfigProductsOniTunesConnectedLoaded"

var shouldReloadMyLibrary = true

var _postRequestQueue: NSOperationQueue? = nil
let UD = NSUserDefaults.standardUserDefaults()
let ND = NSNotificationCenter.defaultCenter()

var productsOniTunesConnectedLoaded = false

func setupQueue() {
    if _postRequestQueue == nil {
        _postRequestQueue = NSOperationQueue()
        _postRequestQueue?.maxConcurrentOperationCount = 5
        _postRequestQueue?.name = "com.giantinteractive.gwl.post_request_queue"
    }
}


func loggedIn() -> Bool {
    guard getSession() != nil else {
        return false
    }
    
    if getSession()!.length() > 0 {
        return true
    } else {
        return false
    }
}


//func getProductsOniTunesConnectedLoaded() -> Bool {
//    let isLoaded = UD.boolForKey("CONFIG_PRODUCTS_ON_ITUNES_CONNECTED_LOADED")
//    return UD.boolForKey("CONFIG_PRODUCTS_ON_ITUNES_CONNECTED_LOADED")
//}
//
//func setProductsOniTunesConnectedLoaded(isLoaded: Bool) {
//    UD.setBool(isLoaded, forKey: CONFIG_PRODUCTS_ON_ITUNES_CONNECTED_LOADED)
//    UD.synchronize()
//}


func getServicesUrl() -> String {
    return UD.stringForKey(CONFIG_SERVICES_URL) ?? URL_SERVICES
}


func setSession(session: String) {
    UD.setValue(session, forKey: CONFIG_SESSION)
    UD.synchronize()
}

func getSession() -> String? {
    return UD.stringForKey(CONFIG_SESSION) ?? ""
}


//func getProductOnlyItems(group: ProductGroup) -> [ProductOnlyItem] {
//    var productOnlyItems = [ProductOnlyItem]()
//    
//    var productOnlyItemsArchived: [AnyObject]?
//    
//    switch group {
//    case .Top:
//        productOnlyItemsArchived = UD.valueForKey(CONFIG_TOPSELLERS_TIEMS) as? [AnyObject]
//        break
//    case .Free:
//        productOnlyItemsArchived = UD.valueForKey(CONFIG_FREELESSONS_ITEMS) as? [AnyObject]
//    case .Browse:
//        productOnlyItemsArchived = UD.valueForKey(CONFIG_ALL_PRODUCTONLY_ITEMS) as? [AnyObject]
//    }
//    
//    guard productOnlyItemsArchived?.count > 0 else {
//        return productOnlyItems
//    }
//    
//    for productOnlyItemArchived in productOnlyItemsArchived! {
//        let productOnlyItem = NSKeyedUnarchiver.unarchiveObjectWithData(productOnlyItemArchived as! NSData)
//        if productOnlyItem is ProductOnlyItem {
//            productOnlyItems.append(productOnlyItem as! ProductOnlyItem)
//        }
//    }
//    
//    return productOnlyItems
//}

//func setProductOnlyItems(group: ProductGroup, productOnlyItems: [ProductOnlyItem]) {
//    var items = [NSData]()
//    for productOnlyItem in productOnlyItems {
//        let item = NSKeyedArchiver.archivedDataWithRootObject(productOnlyItem)
//        items.append(item)
//    }
//    
//    switch group {
//    case .Top:
//        UD.setValue(items, forKey: CONFIG_TOPSELLERS_TIEMS)
//    case .Free:
//        UD.setValue(items, forKey: CONFIG_FREELESSONS_ITEMS)
//    case .Browse:
//        UD.setValue(items, forKey: CONFIG_ALL_PRODUCTONLY_ITEMS)
//    }
//    
//    UD.synchronize()
//}


func requestUrl(url: String, isPost:Bool, jsonData: NSData, onSuccess:[String: AnyObject] -> (), onFailure:Dictionary<String, String> -> ()) {
    setupQueue()
    
    let request = NSMutableURLRequest(URL: NSURL(string: url)!)
    if isPost {
        request.HTTPMethod = "POST"
        request.setValue("\(jsonData.length)", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    } else {
        request.HTTPMethod = "GET"
    }
    request.HTTPBody = jsonData
    
    let session = getSession()
    if (session != nil) {
        request.setValue(getSession(), forHTTPHeaderField: "session")
    } else {
        
    }
    
    request.setValue(session, forHTTPHeaderField: "session")
    
    let urlSession = NSURLSession.sharedSession()
    let task = urlSession.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
        guard (data != nil), let requestResponse = response as? NSHTTPURLResponse where requestResponse.statusCode == 200 else {
            onFailure(["success": "0", "message": "Connection failure with server"])
            return
        }
        
        do {
            let resp = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String: AnyObject]

            if let success = resp["success"] as? Bool {
                if !success {
                    
                    if let failureMessage = resp["message"] as! String! {
                        onFailure(["success": "0", "message": failureMessage])
                    } else {
                        onFailure(["success": "0", "message": "Unknown error happend"])
                    }
                    
                    
//                    onFailure(resp as! Dictionary<String, String>)
//                    return
                }
            }

            onSuccess(resp)
        } catch {
            onFailure(["success": "0", "message": "Server failed with unknown response."])
            return
        }
        }
    )
    
    task.resume()
    
}

// MARK: - Product IDs to purchase; comes from our server
func listProductsIdsOniTunesConnectOnComplete(success:[String] -> (), failure: String -> ()) {
    let iTunesUUIDsUrl = "\(getServicesUrl())/api/v1/itunesUUIDS"
    requestUrl(iTunesUUIDsUrl, isPost: false, jsonData: NSData(), onSuccess: { successResult -> () in
        let status = successResult["success"] as! Bool
        if status {
            setProductIdsOniTunesConnect(successResult["message"] as! [String])
        }
        
        success(successResult["message"] as! [String])
        }) { (failureResult) -> () in
            if let failureMessage = failureResult["message"] as String! {
                failure(failureMessage)
            } else {
                failure("Unknown error happend.")
            }
    }
}

func getProductIdsOniTunesConnect() -> [String] {
    var productIdsOniTunesConnect = [String]()
    
    let productIdsOniTunesConnectArchived = UD.arrayForKey(CONFIG_PRODUCT_IDS_ON_ITUES_CONNECT) as? [String]
    guard productIdsOniTunesConnectArchived?.count > 0 else {
        return productIdsOniTunesConnect
    }
    
    for productIdOniTunesConnectArchived in productIdsOniTunesConnectArchived! {
        productIdsOniTunesConnect.append(productIdOniTunesConnectArchived)
    }
    
    return productIdsOniTunesConnect
}

func setProductIdsOniTunesConnect(pids: [String]) {
    UD.setObject(pids, forKey: CONFIG_PRODUCT_IDS_ON_ITUES_CONNECT)
    UD.synchronize()
}

func listProductsToPurchaseOnComplete(complete: [SKProduct]? -> ()) {
    GWIAPHelper.sharedInstance.requestProductsWithCompletionHandler { (success, products) -> () in
        if success {
            complete(products)
        }
    }
}


// MARK: -
func getInfoForUuid(uuid: String, success: [String: AnyObject] -> (), failure: String -> ()) {
    let mString = "\(getServicesUrl())/api/v1/products/\(uuid)"
    requestUrl(mString, isPost: false, jsonData: NSData(), onSuccess: { (successResult) -> () in
        success(successResult)
        }) { (failureResult) -> () in
            let failureMessage = failureResult["message"]!
            failure(failureMessage)
    }
}

// MARK: -
func listFeaturedOnComplete(complete: [FeaturedItem]? -> ()) {
    let serviceUrl = "\(getServicesUrl())/api/v1/products/featured/"
    
    requestUrl(serviceUrl,
        isPost: false, jsonData: NSData(), onSuccess: { (result) -> () in
            if let featuredMovies = result["message"] as? [AnyObject] {
                var featuredItems = [FeaturedItem]()
                for var i = 0; i<featuredMovies.count; ++i {
                    let featuredMovie = featuredMovies[i] as! NSDictionary
        
                    let featuredImage = featuredMovie["featured_image"] as! String
                    let isHero = Bool(featuredMovie["isHero"] as! Int)
                    let title = (featuredMovie["title"] as! String).decodeEnt()
                    let uuid = featuredMovie["uuid"] as! String
                    
                    let featuredItem: FeaturedItem = FeaturedItem(featuredImage: featuredImage, isHero: isHero, title: title, uuid: uuid)
                    
                    featuredItems.append(featuredItem)
                }
                complete(featuredItems)
            }
        }) { (dict) -> () in
            complete(nil)
    }
}


func listProductOnlyOnComplete(group: ProductGroup, complete: [ProductOnlyItem]? -> ()) {
    var serviceUrl = ""
    switch group {
    case .Top:
        serviceUrl = "\(getServicesUrl())/api/v1/products/topsellers/"
        break
    case .Free:
        serviceUrl = "\(getServicesUrl())/api/v1/products/free/"
        break
    case .Browse:
        serviceUrl = "\(getServicesUrl())/api/v1/products/all/"
        break
    }
    
    requestUrl(serviceUrl,
        isPost: false, jsonData: NSData(), onSuccess: { (result) -> () in
            if let products = result["message"] as? [AnyObject] {
                var productOnlyItems = [ProductOnlyItem]()
                for var i = 0; i<products.count; ++i {
                    let product = products[i] as! NSDictionary
                    
                    let difficulty = product["difficulty"] as! String
                    let genre = product["genre"] as! String
                    let guitarType = product["guitar_type"] as! String // guitar_type
                    let instructor = product["instructor"] as! String
                    let price = product["price"] as! String
                    // extracting cover image
                    var thumbnailUrl = (product["thumbnail_url"] as! String).stringByReplacingOccurrencesOfString("-88x122", withString: "") // thumbnail_url
                    thumbnailUrl = thumbnailUrl.stringByReplacingOccurrencesOfString("-85x122", withString: "")
                    thumbnailUrl = thumbnailUrl.stringByReplacingOccurrencesOfString("-86x122", withString: "")
                    thumbnailUrl = thumbnailUrl.stringByReplacingOccurrencesOfString("jpg.", withString: "jpg")

                    let thumbnailUrlMd = product["thumbnail_url_md"] as! String // thumbnail_url_md
                    let title = (product["title"] as! String).decodeEnt()
                    let tuning = product["tuning"] as! String
                    let uuid = product["uuid"] as! String
                    
                    let productOnlyItem = ProductOnlyItem(difficulty: difficulty, genre: genre, guitarType: guitarType, instructor: instructor, price: price, thumbnailUrl: thumbnailUrl, thumbnailUrlMd: thumbnailUrlMd, title: title, tuning: tuning, uuid: uuid)
                    
                    productOnlyItems.append(productOnlyItem)
                }
                complete(productOnlyItems)
            }
        }) { (dict) -> () in
            complete(nil)
    }
}


// MARK: - My Library
func listLibraryOnComplete(complete: [String: MyLibraryProductItem]? -> ()) {
    let serviceUrl = String(format: "%@/api/v1/members/licensed/%@", arguments: [getServicesUrl(), getSession()!])
    requestUrl(serviceUrl,
        isPost: false, jsonData: NSData(), onSuccess: { (result) -> () in
            if let products = result["message"] as? [AnyObject] {
                var productOnlyItems = [String: MyLibraryProductItem]()
                for var i = 0; i<products.count; ++i {
                    let product = products[i] as! NSDictionary
                    
                    let productDescription = product["description"] as! String
                    let difficulty = product["difficulty"] as! String
                    let genre = product["genre"] as! String
                    let guitarType = product["guitar_type"] as! String // guitar_type
                    let instructor = product["instructor"] as! String
                    let isLicensed = product["is_licensed"] as! Bool
                    let price = (product["price"] as? String) ?? ""
                    let pdf = product["pdf"] as! String
                    let runtime = product["runtime"] as! String
                    let thumbnailUrl = product["thumbnail_url"] as! String // thumbnail_url
                    let thumbnailUrlMd = product["thumbnail_url_md"] as! String // thumbnail_url_md
                    let title = (product["title"] as! String).decodeEnt()
                    let tuning = product["tuning"] as! String
                    let uuid = product["uuid"] as! String
                    let video = product["video"] as! String
                    
                    var lessons = [MyLibraryLessonItem]()
                    if let rawLessons = product["lessons"] as? [AnyObject] {
                        for var j = 0; j < rawLessons.count; j++ {
                            let rawLesson = rawLessons[j] as! NSDictionary
                            
                            let lessonDescription = (rawLesson["description"] as! String).decodeEnt()
                            let difficulty = rawLesson["difficulty"] as! String
                            let genre = rawLesson["genre"] as! String
                            let guitarType = rawLesson["guitar_type"] as! String // guitar_type
                            let infoHtml = rawLesson["info_html"] as! String // guitar_type
                            let instructor = rawLesson["instructor"] as! String
                            let isLicensed = rawLesson["is_licensed"] as! Bool
                            let price = (rawLesson["price"] as? String) ?? ""
                            let pdf = rawLesson["pdf"] as! String
                            let runtime = rawLesson["runtime"] as! String
                            let thumbnailUrl = rawLesson["thumbnail_url"] as! String // thumbnail_url
                            //        let thumbnailUrlMd = rawLesson["thumbnail_url_md"] as! String // thumbnail_url_md
                            let title = (rawLesson["title"] as! String).decodeEnt()
                            let tuning = rawLesson["tuning"] as! String
                            let uuid = rawLesson["uuid"] as! String
                            let video = rawLesson["video"] as! String
                            let order = rawLesson["order"] as! Int
                            
                            let lesson = MyLibraryLessonItem(lessonDescription: lessonDescription, difficulty: difficulty, genre: genre, guitarType: guitarType, infoHtml: infoHtml, isFree: true, instructor: instructor, isLicensed: isLicensed, iTunesUuid: "", price: price, pdf: pdf, runtime: runtime, thumbnailUrl: thumbnailUrl, title: title, tuning: tuning, uuid: uuid, video: video, order: order)
                            
                            lessons.append(lesson)
                        }
                    }
                    
                    let productOnlyItem = MyLibraryProductItem(productDescription: productDescription, difficulty: difficulty, genre: genre, guitarType: guitarType, instructor: instructor, isLicensed: isLicensed, lessons: lessons, price: price, pdf: pdf, runtime: runtime, thumbnailUrl: thumbnailUrl, thumbnailUrlMd: thumbnailUrlMd, title: title, tuning: tuning, uuid: uuid, video: video)
                    
                    productOnlyItems[uuid] = productOnlyItem
                }
                complete(productOnlyItems)
            }
        }) { (dict) -> () in
            complete(nil)
    }
}

// MARK: - User Authentication
func performLogin(username: String, password: String, success:[String: String] -> (), failure: String -> () ) {
    setupQueue()
    
    let mString = "\(getServicesUrl())/services/authentication.php?action=login&email=\(username)&password=\(password)"
    let request = NSMutableURLRequest(URL: NSURL(string: mString)!)
    request.HTTPMethod = "GET"

    request.HTTPBody = NSData()
    
    let urlSession = NSURLSession.sharedSession()
    let task = urlSession.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
        guard (data != nil), let requestResponse = response as? NSHTTPURLResponse where requestResponse.statusCode == 200 else {
            failure("Connection failure with server")
            return
        }
        
        if error != nil {
            failure((error?.localizedDescription)!)
            return
        }
        
        do {
            let resp = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! Dictionary<String, AnyObject>
            let status = resp["status"] as! Bool
            if status {
                var result = [String: String]()
                let authToken = resp["authToken"] as! String
                result["authToken"] = authToken
                
                let message = resp["message"] as! String
                result["message"] = message
                
                let session = resp["session"] as! String
                result["session"] = session
                
                let subscribed = resp["subscribed"] as! String
                result["subscribed"] = subscribed
                
                success(result)
            } else {
                failure(resp["message"] as! String)
            }
            
        } catch {
            failure("Server failed with unknown response.")
            return
        }
        }
    )
    
    task.resume()
}

func verifySessionOnSuccess(success: () -> (), failure:() -> () ) {
    let mString = String(format: "%@/services/login.php?action=verify", arguments: [getServicesUrl()])
    requestUrl(mString, isPost: false, jsonData: NSData(), onSuccess: { (successResult) -> () in
        if let successful = successResult["success"] as? Bool {
            if successful {
                success()
            } else {
                failure()
            }
        }
        }) { (failureResult) -> () in
            failure()
    }
}

func requestForPasswordReset(email: String, success: [String: String] -> (), failure: String -> () ) {
    let mString = "\(getServicesUrl())/services/resetPassword.php?action=resetPassword&email=\(email)"
    requestUrl(mString, isPost: false, jsonData: NSData(), onSuccess: { (successResult) -> () in
        var resultDict = [String: String]()
        
        let status = successResult["status"] as! Bool
        if status {
            resultDict["message"] = successResult["message"] as? String
            success(resultDict)
        } else {
            let failureMessage = successResult["message"] as? String
            failure(failureMessage!)
        }
        }) { (failureResult) -> () in
            let failureMessage = failureResult["message"]!
            failure(failureMessage)
    }
}


func setUsername(username: String) {
    UD.setValue(username, forKey: CONFIG_USERNAME)
    UD.synchronize()
}

func getUsername() -> String? {
    return UD.stringForKey(CONFIG_USERNAME)
}


// MARK: - Registration
func performRegister(username: String, password: String, subscribe: Bool, firstName: String, lastName: String, postalCode: String, success:[String: String] -> (), failure: String -> () ) {
    let subscribeStr = subscribe ? "1" : "0"
    let mString = "\(getServicesUrl())/api/v1/members?email=\(username)&password=\(password)&subscribe=\(subscribeStr)&firstName=\(firstName)&lastName=\(lastName)&postalCode=\(postalCode)"
    
    requestUrl(mString, isPost: false, jsonData: NSData(), onSuccess: { (successResult) -> () in
        var resultDict = [String: String]()
        
        let status = successResult["status"] as! Bool
        if status {
            let authToken = successResult["authToken"] as! String
            let subscribed = successResult["subscribed"] as! String
            let session = successResult["session"] as! String
            
            resultDict["authToken"] = authToken
            resultDict["subscribed"] = subscribed
            resultDict["status"] = String(status)
            resultDict["session"] = session
            
            success(resultDict)
        } else {
            failure(successResult["message"] as! String)
        }
    
        }) { (failureResult) -> () in
            failure(failureResult["message"]!)
    }
    
}


// MARK: -
func setPassword(password: String) {
    UD.setValue(password, forKey: CONFIG_PASSWORD)
    UD.synchronize()
}

func getPassword() -> String? {
    return UD.stringForKey(CONFIG_PASSWORD)
}


func setUserID(userId: String) {
    UD.setValue(userId, forKey: CONFIG_USER_ID)
    UD.synchronize()
}

func getUserID() -> String? {
    return UD.stringForKey(CONFIG_USER_ID)
}

func setSubscribed(subscribed: Bool) {
    UD.setValue(subscribed, forKey: CONFIG_SUBSCRIBED)
    UD.synchronize()
}

func getSubscribed() -> Bool {
    return UD.boolForKey(CONFIG_SUBSCRIBED)
}


// MARK: - Image Loader
// will be used to download images from URL
class ImageLoader {
    
    var cache = NSCache()
    
    class var sharedLoader : ImageLoader {
        struct Static {
            static let instance : ImageLoader = ImageLoader()
        }
        return Static.instance
    }
    
    func imageForUrl(urlString: String, completionHandler:(image: UIImage?, url: String) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () in
            let data: NSData? = self.cache.objectForKey(urlString) as? NSData
            
            if let goodData = data {
                let image = UIImage(data: goodData)
                dispatch_async(dispatch_get_main_queue(), {() in
                    completionHandler(image: image, url: urlString)
                })
                return
            }
            
            let downloadTask: NSURLSessionDataTask = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: urlString)!, completionHandler: {(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                if (error != nil) {
                    completionHandler(image: nil, url: urlString)
                    return
                }
                
                if data != nil {
                    let image = UIImage(data: data!)
                    self.cache.setObject(data!, forKey: urlString)
                    dispatch_async(dispatch_get_main_queue(), {() in
                        completionHandler(image: image, url: urlString)
                    })
                    return
                }
            })
            downloadTask.resume()
        })
    }
}

// MARK: - In-app Purchase
func setShouldUpdateLibrary(shouldUpdateLibrary: Bool) {
    UD.setObject(shouldUpdateLibrary ? "1" : "0", forKey: CONFIG_SHOULD_UPDATE_LIBRARY)
    UD.synchronize()
}

func getShouldUpdateLibrary() -> Bool {
    return UD.boolForKey(CONFIG_SHOULD_UPDATE_LIBRARY)
}

// MARK: - License Related Queries
// TODO: do we need this?
func restoreLicensesOnComplete(completer: [String] -> ()) {
    let mString = String(format: "%@/services/license.php?action=get", arguments: [getServicesUrl()])
    requestUrl(mString, isPost: false, jsonData: NSData(), onSuccess: { (successResult) -> () in
        }) { (failureResult) -> () in
            
    }
}

func saveLicenseForUUID(uuid: String, authCode: String, amount: Float, onSuccess:(String) -> (), onFailure:(String) -> () ) {
    let dict = ["uuid": uuid, "auth_code": authCode, "source" : "iOS", "amount": String(format: "%f", arguments: [amount])]
    do {
        let  dictData = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
        let mString = String(format: "%@/services/license.php?action=set", arguments: [getServicesUrl()])
        requestUrl(mString, isPost: true, jsonData: dictData, onSuccess: { (successResult) -> () in
            if let successMessage = successResult["message"] as! String! {
                onSuccess(successMessage)
            } else {
                onSuccess("Unknown error happend: \(__FUNCTION__)")
            }

            }, onFailure: { (failureResult) -> () in
                if let failureMessage = failureResult["message"] as String! {
                    onFailure(failureMessage)
                } else {
                    onFailure("Unknown error happend: \(__FUNCTION__)")
                }
        })
    } catch {
        onFailure("Unknown error happend: \(__FUNCTION__)")
    }
    
}


// MARK: - Input Authentications
func isAValidPassword(password: String) -> Bool {
    let alphaSet = NSCharacterSet.alphanumericCharacterSet() // just alphanumeric
    return password.stringByTrimmingCharactersInSet(alphaSet) == ""
}

func isAValidString(string: String) -> Bool {
    let validStrCharSet = NSMutableCharacterSet(charactersInString: "- ")
    validStrCharSet.formUnionWithCharacterSet(NSCharacterSet.alphanumericCharacterSet())
    return string.stringByTrimmingCharactersInSet(validStrCharSet) == ""
}


func isAValidEmail(email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    let range = email.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
    let result = range != nil ? true : false
    return result
}


func characterEncodeString(input: String) -> String {
    let charactersToEscape = "!*'();:@&=+$,/?%#[]\" "
    let allowedCharacters = NSMutableCharacterSet(charactersInString: charactersToEscape).invertedSet
    return input.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacters)!
}



func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0) -> UIColor {
    let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
    let blue = CGFloat(rgbValue & 0xFF)/256.0
    
    return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
}

@available(*, deprecated=1.0, message="I'm not deprecated, please ***FIXME**")
func FIXME() {
}

// MARK: - Extensions
extension String {

    func decodeEnt() -> String {
        let encodedData = self.dataUsingEncoding(NSUTF8StringEncoding)!
        let attributedOptions : [String: AnyObject] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
        ]
        
        do {
            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            return attributedString.string
        } catch {
            return self
        }
    }
    
    func length() -> Int {
        return self.characters.count
    }
    
    func boolValue() -> Bool{
        if self == "No" || self == "NO" || self == "FALSE" || self == "false" || self == "0" {
            return false
        } else {
            return true
        }
    }
}
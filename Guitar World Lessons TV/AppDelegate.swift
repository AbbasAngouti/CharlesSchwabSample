//
//  AppDelegate.swift
//  Guitar World Lessons TV
//
//  Created by Abbas Angouti on 10/30/15.
//  Copyright © 2015 Giant Interactive. All rights reserved.
//

import UIKit
import StoreKit
//import Fabric
//import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
//        Fabric.with([Crashlytics.self])
        listProductsIdsOniTunesConnectOnComplete({ (products) -> () in
            productsOniTunesConnectedLoaded = false
            dispatch_async(dispatch_get_main_queue(), { 
                listProductsToPurchaseOnComplete({ resultsFromiTunesConnect -> () in
                    let unwrappedResults: [SKProduct]! = resultsFromiTunesConnect
                    GWIAPHelper.sharedInstance.productsToPurchase = unwrappedResults
                    productsOniTunesConnectedLoaded = true
                    ND.postNotificationName(NOTIFICATION_PRODUCTS_ON_ITUNES_CONNECTED_LOADED, object: nil)
                    print("number of products on iTunes Connect: \(unwrappedResults.count)")
                })
            })
            
            }) { (errorMessage) -> () in
                // TODO: Take care of this error
        }
        
        performLogin()
        
        return true
    }

    
    func performLogin() {
        if loggedIn() {
            // TODO: show a toast saying "Restoring your session ..."
            verifySessionOnSuccess({
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.restorePurchases()
                    // TODO: dismiss the alert view
                })
                }, failure: {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        // TODO: dismiss the alert view
                        // TODO: show another one saying: "Your session has timed out, or could not be restored.  Please login."
                    })
                    
            })
        }
    }
    
    func restorePurchases() {
        restoreLicensesOnComplete { (result) -> () in
//            setLicenses(result)
        }
    }
//    - (void)restorePurchases {
//    [GWServices restoreLicensesOnComplete:^(NSArray *results) {
//    dispatch_async( dispatch_get_main_queue(), ^{
//    [GWSettings setLicenses:results];
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REFRESH_LICENSES object:nil];
//    });
//    }];
//    }
    
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


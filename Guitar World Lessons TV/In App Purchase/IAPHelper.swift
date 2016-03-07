//
//  IAPHelper.swift
//  Guitar World Lessons TV
//
//  Created by Abbas Angouti on 11/16/15.
//  Copyright © 2015 Giant Interactive. All rights reserved.
//

import UIKit
import StoreKit

class IAPHelper: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    var productsToPurchase: [SKProduct]
    
    private var productUuid: String = ""
    // an instance variable to store the SKProductsRequest will be issued to retrieve a list of products, while it is active
    private var _productsRequest: SKProductsRequest?
    
    // keeps track of the completion handler for the outstanding products request, ...
    typealias RequestProductsCompletionHandler = (success: Bool, products: [SKProduct]?) -> ()
    private var _completionHandler: RequestProductsCompletionHandler?
    
    // the list of product identifiers passed in,
    private var productIdentifiers: Set<String>
    
    // the list of product identifiers that have been previously purchased.
    private var _purchasedProductIdentifiers: Set<String>
    
    init(withProductIdentifiers productIdentifiers: Set<String>) {
        
        // store product identifiers
        self.productIdentifiers = productIdentifiers
        
        // check for previously purchased products
        _purchasedProductIdentifiers = Set<String>()
        
        
        for productIdentifier in self.productIdentifiers {
            let productPurchased = UD.boolForKey(productIdentifier)
            if productPurchased {
                _purchasedProductIdentifiers.insert(productIdentifier)
//                print("previously purchased: \(productIdentifier)")
            } else {
//                print("Not purchased: \(productIdentifier)")
            }
        }
        
        productsToPurchase = [SKProduct]();
        
        super.init()
        
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    }
    
    
    func requestProductsWithCompletionHandler(completionHandler: RequestProductsCompletionHandler) {
        //TODO: not sure if we need this line:👇🏾
        _completionHandler = completionHandler
        
        // Create a new instance of SKProductsRequest, which is the Apple-written class that contains the code to pull the info from iTunes Connect
        _productsRequest = SKProductsRequest(productIdentifiers: self.productIdentifiers)
        _productsRequest!.delegate = self
        _productsRequest!.start()
    }
    
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        print("Loaded products ...");
        _productsRequest = SKProductsRequest();
        
        let skProducts = response.products;
//        for skProduct in skProducts {
//            print(String(format: "Found product: %@ – Product: %@ – Price: %0.2f", arguments: [skProduct.productIdentifier, skProduct.localizedTitle, skProduct.price.floatValue]))
//        }
        
        if (_completionHandler == nil) {
            print("parent is NULL");
        } else {
            _completionHandler!(success: true, products: skProducts);
            _completionHandler = nil;
        }
    }
    
    
    func request(request: SKRequest, didFailWithError error: NSError) {
        let message = UIAlertController(title: "Failed to load list of products.",
            message: nil, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
            print("Failed to load list of products.");
            self._productsRequest = nil;
            if((self._completionHandler) != nil) {
                self._completionHandler!(success: false, products: nil);
                self._completionHandler = nil;
            }
        }
        
        message.addAction(cancelAction)
        
        // TODO: how to present this? delegation? Maybe👇🏾
//        self.presentViewController(message, animated: true, completion: nil)
    }
    
    
    func productPurchased(productIdentifier: String) -> Bool {
        return _purchasedProductIdentifiers.contains(productIdentifier)
    }
    
    
    func buyProduct(product: SKProduct, withUuid uuid:String) {
        print("Buying \(product.productIdentifier)...")
        productUuid = uuid
        let payment = SKPayment(product: product)
        SKPaymentQueue.defaultQueue().addPayment(payment)
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .Purchased:
                completeTransaction(transaction)
                break
            case .Failed:
                failedTransaction(transaction)
                break
            case .Restored:
                restoreTransaction(transaction)
                break
            default:
                break
            }
        }
    }
    
    // called when the transaction was successful
    func completeTransaction(transaction: SKPaymentTransaction) {
        print("Complete Transaction...")
        provideContentForProductIdentifier(transaction.payment.productIdentifier)
        UD.boolForKey(transaction.payment.productIdentifier)
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
    }
    
    func provideContentForProductIdentifier(productIdentifier: String) {
        print("provideContentForProductIdentifier...")
        let uuidDict = ["uuid" : productUuid]
        ND.postNotificationName(NOTIFICATION_ITEM_PURCHASED, object: productIdentifier, userInfo: uuidDict)
    }
    
    // called when a transaction has failed
    func failedTransaction(transaction: SKPaymentTransaction) {
        print("Failed Transaction...")
        if transaction.error?.code != SKErrorPaymentCancelled {
            print("Transaction error: \(transaction.error?.localizedDescription)!")
            
            let message = UIAlertController(title: "Transaction Failed!",
                message: nil, preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
                print("Transaction error: \(transaction.error?.localizedDescription)");
            }
            
            message.addAction(cancelAction)
            
            // TODO: how to present this? delegation? Maybe👇🏾
            //        self.presentViewController(message, animated: true, completion: nil)
            
            
        }
        
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)

        let uuidDict = ["uuid" : productUuid]
        ND.postNotificationName(NOTIFICATION_ITEM_PURCHASE_FAILED, object: transaction.payment.productIdentifier, userInfo: uuidDict)
    }
    
    // called when a transaction has been restored and successfully completed
    func restoreTransaction(transaction: SKPaymentTransaction) {
        print("Restore Transaction...")
        
        
        let message = UIAlertController(title: "Restored successfully!",
            message: nil, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (action) -> Void in
            print("Enjoy!");
        }
        
        message.addAction(cancelAction)
        
        // TODO: how to present this? delegation? Maybe👇🏾
        //        self.presentViewController(message, animated: true, completion: nil)
        
        provideContentForProductIdentifier((transaction.originalTransaction?.payment.productIdentifier)!)
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
        
    }    
    
}

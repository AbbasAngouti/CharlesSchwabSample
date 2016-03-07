//
//  MyLibraryLessonCellComposer.swift
//  Guitar World Lessons TV
//
//  Created by Abbas Angouti on 12/3/15.
//  Copyright © 2015 Giant Interactive. All rights reserved.
//

import UIKit

class MyLibraryLessonCellComposer {
    // MARK: Properties
    
    /// Cache used to store processed images, keyed on `DataItem` identifiers.
    static private var processedImageCache = NSCache()
    
    /**
     A dictionary of `NSOperationQueue`s for `ProductItemCollectionViewCell`s. The
     queues contain operations that process images for `DataItem`s before updating
     the cell's `UIImageView`.
     */
    private var operationQueues = [LessonItemCollectionViewCell: NSOperationQueue]()
    
    // MARK: Implementation
    
    func composeCell(cell: UICollectionViewCell, withDataItem dataItem: AnyObject) {
        // Cancel any queued operations to process images for the cell.
        if let cell = cell as? LessonItemCollectionViewCell, dataItem = dataItem as? MyLibraryLessonItem {
            let operationQueue = operationQueueForCell(cell)
            operationQueue.cancelAllOperations()
            
            // Set the cell's properties.
            cell.representedDataItem = dataItem
            cell.titleLabel.text =  dataItem.title//.decodeEnt()
            cell.subtitleLabel.text = dataItem.lessonDescription//.decodeEnt()
            cell.runtimeLabel.text = "Runtime: \(dataItem.runtime)"
            if let priceLabel = cell.priceLabel {
                priceLabel.text = "Price: $\(dataItem.price)"
                if dataItem.isFree {
                    priceLabel.text = "Free"
                }
            }
           
//            /*
//            Initial rendering of a jpeg image can be expensive. To avoid stalling
//            the main thread, we create an operation to process the `DataItem`'s
//            image before updating the cell's image view.
//            
//            The execution block is added after the operation is created to allow
//            the block to check if the operation has been cancelled.
//            */
//            let processImageOperation = NSBlockOperation()
//            
//            processImageOperation.addExecutionBlock { [unowned processImageOperation] in
//                // Ensure the operation has not been cancelled.
//                guard !processImageOperation.cancelled else { return }
//                
//                ImageLoader.sharedLoader.imageForUrl(dataItem.thumbnailUrl, completionHandler: { (image, url) -> () in
//                    // Store the processed image in the cache.
//                    //                let downloadedImage = UIImage(image)
//                    //                guard let downloadedImage = self.processImageNamed(image!) else { return }
//                    DataItemCellComposer.processedImageCache.setObject(image!, forKey: dataItem.uuid)
//                    
//                    NSOperationQueue.mainQueue().addOperationWithBlock {
//                        // Check that the cell is still showing the same `DataItem`.
//                        guard dataItem == cell.representedDataItem else { return }
//                        
//                        // Update the cell's `UIImageView` and then fade it into view.
//                        cell.imageView.alpha = 0.0
//                        cell.imageView.image = image
//                        
//                        UIView.animateWithDuration(0.25) {
//                            cell.imageView.alpha = 1.0
//                        }
//                    }
//                })
//            }
//            
//            operationQueue.addOperation(processImageOperation)
        }
        
    }
    
    // MARK: Convenience
    
    /**
    Returns the `NSOperationQueue` for a given cell. Creates and stores a new
    queue if one doesn't already exist.
    */
    private func operationQueueForCell(cell: LessonItemCollectionViewCell) -> NSOperationQueue {
        if let queue = operationQueues[cell] {
            return queue
        }
        
        let queue = NSOperationQueue()
        operationQueues[cell] = queue
        
        return queue
    }
    
    /**
     Loads a UIImage for a given name and returns a version that has been drawn
     into a `CGBitmapContext`.
     */
    private func processImageNamed(imageName: String) -> UIImage? {
        // Load the image.
        guard let image = UIImage(named: imageName) else { return nil }
        
        /*
        We only need to process jpeg images. Do no processing if the image
        name doesn't have a jpg suffix.
        */
        guard imageName.hasSuffix(".jpg") else { return image }
        
        // Create a `CGColorSpace` and `CGBitmapInfo` value that is appropriate for the device.
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.PremultipliedLast.rawValue | CGBitmapInfo.ByteOrder32Little.rawValue
        
        // Create a bitmap context of the same size as the image.
        let imageWidth = Int(Float(image.size.width))
        let imageHeight = Int(Float(image.size.height))
        
        let bitmapContext = CGBitmapContextCreate(nil, imageWidth, imageHeight, 8, imageWidth * 4, colorSpace, bitmapInfo)
        
        // Draw the image into the graphics context.
        guard let imageRef = image.CGImage else { fatalError("Unable to get a CGImage from a UIImage.") }
        CGContextDrawImage(bitmapContext, CGRect(origin: CGPoint.zero, size: image.size), imageRef)
        
        // Create a new `CGImage` from the contents of the graphics context.
        guard let newImageRef = CGBitmapContextCreateImage(bitmapContext) else { return image }
        
        // Return a new `UIImage` created from the `CGImage`.
        return UIImage(CGImage: newImageRef)
    }
}

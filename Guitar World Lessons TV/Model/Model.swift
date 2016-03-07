//
//  Model.swift
//  Guitar World Lessons TV
//
//  Created by Abbas Angouti on 11/5/15.
//  Copyright © 2015 Giant Interactive. All rights reserved.
//

import Foundation

enum ProductGroup {
    case Top, Free, Browse
}

struct ProductInstructor {
    let instructorBio, instructorName: String
}

struct ProductInfo {
    let artists, difficulties, genres, guitarTypes, techniquesUsed, tunings: [String]
    let instructorName, runTime : String
    let price: Float
}

struct Product {
    let info: ProductInfo
    let instructor: ProductInstructor
    let infoHtml, instructorHtml, iTunesUuid, pdf, sourceImage, synopsis, title, video: String
    let isFree, isLicensed: Bool
}


struct Lesson {
    let description, difficulty, infoHtml, iTunesUuid, pdf, runTime, title, uuid, video: String
    let order: Int
    let price: Float
    let isFree, isLicensed: Bool
}


class FeaturedItem: NSObject, NSCoding { // Carousel items
    let featuredImage: String
    let isHero: Bool
    let title: String
    let uuid: String
    
    init (featuredImage: String, isHero: Bool, title: String, uuid: String) {
        self.featuredImage = featuredImage
        self.isHero = isHero
        self.title = title
        self.uuid = uuid
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(featuredImage, forKey: "featuredImage")
        aCoder.encodeObject(isHero, forKey: "isHero")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(uuid, forKey: "uuid")
    }
    
    required init?(coder aDecoder: NSCoder) {
        let featuredImage = aDecoder.decodeObjectForKey("featuredImage") as! String
        let isHero = aDecoder.decodeObjectForKey("isHero") as! Bool
        let title = aDecoder.decodeObjectForKey("title") as! String
        let uuid = aDecoder.decodeObjectForKey("uuid") as! String
        
        self.featuredImage = featuredImage
        self.isHero = isHero
        self.title = title
        self.uuid = uuid
    }
}


class ProductOnlyItem: NSObject, NSCoding { // Free, Top, All, items
    
    let difficulty: String
    let genre: String
    let guitarType: String // guitar_type
    let instructor: String
    let price: String
    let thumbnailUrl: String // thumbnail_url
    let thumbnailUrlMd: String // thumbnail_url_md
    let title: String
    let tuning: String
    let uuid: String
    
    init (difficulty: String, genre: String, guitarType: String, instructor: String, price: String, thumbnailUrl: String, thumbnailUrlMd: String, title: String, tuning: String, uuid: String) {
        self.difficulty = difficulty
        self.genre = genre
        self.guitarType = guitarType // guitar_type
        self.instructor = instructor
        self.price = price
        self.thumbnailUrl = thumbnailUrl // thumbnail_url
        self.thumbnailUrlMd = thumbnailUrlMd // thumbnail_url_md
        self.title = title
        self.tuning = tuning
        self.uuid = uuid
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(difficulty, forKey: "difficulty")
        aCoder.encodeObject(genre, forKey: "genre")
        aCoder.encodeObject(guitarType, forKey: "guitar_type")
        aCoder.encodeObject(instructor, forKey: "instructor")
        aCoder.encodeObject(price, forKey: "price")
        aCoder.encodeObject(thumbnailUrl, forKey: "thumbnail_url")
        aCoder.encodeObject(thumbnailUrlMd, forKey: "thumbnail_url_md")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(tuning, forKey: "tuning")
        aCoder.encodeObject(uuid, forKey: "uuid")
    }
    
    required init?(coder aDecoder: NSCoder) {
        let difficulty = aDecoder.decodeObjectForKey("difficulty") as! String
        let genre = aDecoder.decodeObjectForKey("genre") as! String
        let guitarType = aDecoder.decodeObjectForKey("guitar_type") as! String // guitar_type
        let instructor = aDecoder.decodeObjectForKey("instructor") as! String
        let price = aDecoder.decodeObjectForKey("price") as! String
        let thumbnailUrl = aDecoder.decodeObjectForKey("thumbnail_url") as! String // thumbnail_url
        let thumbnailUrlMd = aDecoder.decodeObjectForKey("thumbnail_url_md") as! String // thumbnail_url_md
        let title = aDecoder.decodeObjectForKey("title") as! String
        let tuning = aDecoder.decodeObjectForKey("tuning") as! String
        let uuid = aDecoder.decodeObjectForKey("uuid") as! String
        
        self.difficulty = difficulty
        self.genre = genre
        self.guitarType = guitarType // guitar_type
        self.instructor = instructor
        self.price = price
        self.thumbnailUrl = thumbnailUrl // thumbnail_url
        self.thumbnailUrlMd = thumbnailUrlMd // thumbnail_url_md
        self.title = title
        self.tuning = tuning
        self.uuid = uuid
    }
}


// MARK: - My Library Product and Lesson Items
class MyLibraryLessonItem: NSObject, NSCoding { // My Library items
    
    let lessonDescription: String
    let difficulty: String
    let genre: String
    let guitarType: String // guitar_type
    let infoHtml: String
    let isFree : Bool
    let instructor: String
    let isLicensed: Bool
    let iTunesUuid : String
    let price: String
    let pdf: String
    let runtime: String
    let thumbnailUrl: String // thumbnail_url
    let title: String
    let tuning: String
    let uuid: String
    let video: String
    let order: Int
    
    init (lessonDescription: String, difficulty: String, genre: String, guitarType: String, infoHtml: String, isFree: Bool, instructor: String, isLicensed: Bool, iTunesUuid: String, price: String, pdf: String, runtime: String, thumbnailUrl: String, title: String, tuning: String, uuid: String, video: String, order: Int) {
        self.lessonDescription = lessonDescription
        self.difficulty = difficulty
        self.genre = genre
        self.guitarType = guitarType // guitar_type
        self.infoHtml = infoHtml
        self.isFree = isFree
        self.instructor = instructor
        self.isLicensed = isLicensed
        self.iTunesUuid = iTunesUuid
        self.price = price
        self.pdf = pdf
        self.runtime = runtime
        self.thumbnailUrl = thumbnailUrl // thumbnail_url
        self.title = title
        self.tuning = tuning
        self.uuid = uuid
        self.video = video
        self.order = order
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(lessonDescription, forKey: "description")
        aCoder.encodeObject(difficulty, forKey: "difficulty")
        aCoder.encodeObject(genre, forKey: "genre")
        aCoder.encodeObject(guitarType, forKey: "guitar_type")
        aCoder.encodeObject(infoHtml, forKey: "info_html")
        aCoder.encodeObject(isFree, forKey: "is_Free")
        aCoder.encodeObject(instructor, forKey: "instructor")
        aCoder.encodeObject(isLicensed, forKey: "is_licensed")
        aCoder.encodeObject(iTunesUuid, forKey: "itunes_uuid")
        aCoder.encodeObject(price, forKey: "price")
        aCoder.encodeObject(pdf, forKey:  "pdf")
        aCoder.encodeObject(runtime, forKey: "runtime")
        aCoder.encodeObject(thumbnailUrl, forKey: "thumbnail_url")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(tuning, forKey: "tuning")
        aCoder.encodeObject(uuid, forKey: "uuid")
        aCoder.encodeObject(video, forKey: "video")
        aCoder.encodeObject(order, forKey: "order")
    }
    
    required init?(coder aDecoder: NSCoder) {
        let lessonDescription = aDecoder.decodeObjectForKey("description") as! String
        let difficulty = aDecoder.decodeObjectForKey("difficulty") as! String
        let genre = aDecoder.decodeObjectForKey("genre") as! String
        let guitarType = aDecoder.decodeObjectForKey("guitar_type") as! String // guitar_type
        let infoHtml = aDecoder.decodeObjectForKey("info_html") as! String // guitar_type
        let isFree = aDecoder.decodeObjectForKey("is_free") as! Bool
        let instructor = aDecoder.decodeObjectForKey("instructor") as! String
        let isLicensed = aDecoder.decodeObjectForKey("is_licensed") as! Bool
        let iTunesUuid = aDecoder.decodeObjectForKey("itunes_uuid") as! String
        let price = aDecoder.decodeObjectForKey("price") as! String
        let pdf = aDecoder.decodeObjectForKey("pdf") as! String
        let runtime = aDecoder.decodeObjectForKey("runtime") as! String
        let thumbnailUrl = aDecoder.decodeObjectForKey("thumbnail_url") as! String // thumbnail_url
        let title = aDecoder.decodeObjectForKey("title") as! String
        let tuning = aDecoder.decodeObjectForKey("tuning") as! String
        let uuid = aDecoder.decodeObjectForKey("uuid") as! String
        let video = aDecoder.decodeObjectForKey("video") as! String
        let order = aDecoder.decodeObjectForKey("order") as! Int
        
        self.lessonDescription = lessonDescription
        self.difficulty = difficulty
        self.genre = genre
        self.guitarType = guitarType // guitar_type
        self.infoHtml = infoHtml
        self.isFree = isFree
        self.instructor = instructor
        self.isLicensed = isLicensed
        self.iTunesUuid = iTunesUuid
        self.price = price
        self.pdf = pdf
        self.runtime = runtime
        self.thumbnailUrl = thumbnailUrl // thumbnail_url
        self.title = title
        self.tuning = tuning
        self.uuid = uuid
        self.video = video
        self.order = order
    }
}

class MyLibraryProductItem: NSObject, NSCoding { // My Library items
    // FIXME: something is wrong! too much duplication.
    let productDescription: String
    let difficulty: String
    let genre: String
    let guitarType: String // guitar_type
    let instructor: String
    let isLicensed: Bool
    let lessons: [MyLibraryLessonItem]
    let price: String
    let pdf: String
    let runtime: String
    let thumbnailUrl: String // thumbnail_url
    let thumbnailUrlMd: String // thumbnail_url_md
    let title: String
    let tuning: String
    let uuid: String
    let video: String
    
    init (productDescription: String, difficulty: String, genre: String, guitarType: String, instructor: String, isLicensed: Bool, lessons: [MyLibraryLessonItem], price: String, pdf: String, runtime: String, thumbnailUrl: String, thumbnailUrlMd: String, title: String, tuning: String, uuid: String, video: String) {
        self.productDescription = productDescription
        self.difficulty = difficulty
        self.genre = genre
        self.guitarType = guitarType // guitar_type
        self.instructor = instructor
        self.isLicensed = isLicensed
        self.lessons = lessons
        self.price = price
        self.pdf = pdf
        self.runtime = runtime
        self.thumbnailUrl = thumbnailUrl // thumbnail_url
        self.thumbnailUrlMd = thumbnailUrlMd // thumbnail_url_md
        self.title = title
        self.tuning = tuning
        self.uuid = uuid
        self.video = video
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(productDescription, forKey: "description")
        aCoder.encodeObject(difficulty, forKey: "difficulty")
        aCoder.encodeObject(genre, forKey: "genre")
        aCoder.encodeObject(guitarType, forKey: "guitar_type")
        aCoder.encodeObject(instructor, forKey: "instructor")
        aCoder.encodeObject(isLicensed, forKey: "is_licensed")
        aCoder.encodeObject(lessons, forKey: "lessons")
        aCoder.encodeObject(price, forKey: "price")
        aCoder.encodeObject(pdf, forKey:  "pdf")
        aCoder.encodeObject(runtime, forKey: "runtime")
        aCoder.encodeObject(thumbnailUrl, forKey: "thumbnail_url")
        aCoder.encodeObject(thumbnailUrlMd, forKey: "thumbnail_url_md")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(tuning, forKey: "tuning")
        aCoder.encodeObject(uuid, forKey: "uuid")
        aCoder.encodeObject(uuid, forKey: "video")
    }
    
    required init?(coder aDecoder: NSCoder) {
        let productDescription = aDecoder.decodeObjectForKey("description") as! String
        let difficulty = aDecoder.decodeObjectForKey("difficulty") as! String
        let genre = aDecoder.decodeObjectForKey("genre") as! String
        let guitarType = aDecoder.decodeObjectForKey("guitar_type") as! String // guitar_type
        let instructor = aDecoder.decodeObjectForKey("instructor") as! String
        let isLicensed = aDecoder.decodeObjectForKey("is_licensed") as! Bool
        let lessons = aDecoder.decodeObjectForKey("lessons") as! [MyLibraryLessonItem]
        let price = aDecoder.decodeObjectForKey("price") as! String
        let pdf = aDecoder.decodeObjectForKey("pdf") as! String
        let runtime = aDecoder.decodeObjectForKey("runtime") as! String
        let thumbnailUrl = aDecoder.decodeObjectForKey("thumbnail_url") as! String // thumbnail_url
        let thumbnailUrlMd = aDecoder.decodeObjectForKey("thumbnail_url_md") as! String // thumbnail_url_md
        let title = aDecoder.decodeObjectForKey("title") as! String
        let tuning = aDecoder.decodeObjectForKey("tuning") as! String
        let uuid = aDecoder.decodeObjectForKey("uuid") as! String
        let video = aDecoder.decodeObjectForKey("video") as! String
        
        self.productDescription = productDescription
        self.difficulty = difficulty
        self.genre = genre
        self.guitarType = guitarType // guitar_type
        self.instructor = instructor
        self.isLicensed = isLicensed
        self.lessons = lessons
        self.price = price
        self.pdf = pdf
        self.runtime = runtime
        self.thumbnailUrl = thumbnailUrl // thumbnail_url
        self.thumbnailUrlMd = thumbnailUrlMd // thumbnail_url_md
        self.title = title
        self.tuning = tuning
        self.uuid = uuid
        self.video = video
    }
}
// MARK: -

//
//  Utility.swift
//  动物世界
//
//  Created by zhangzhiqiang on 2020/7/10.
//  Copyright © 2020 zhangzhiqiang. All rights reserved.
//

import Foundation
import GRDB

open class Utility: NSObject {

    class func saveFamilyImages(image: String, title: String) {
        let fa = axFamilyImages()
        fa.Images = image
        fa.Titles = title
        
        try! DBPool.write { db in
            do {
                try fa.insert(db)
            } catch let error as DatabaseError {
                print(error.localizedDescription)
            }
        }
    }
    
    class func saveFamilyImagesUrl(image: String? = nil, title: String? = nil,imagePath: String) {
        let fa = axFamilyImages()
        fa.Images = image
        fa.Titles = title
        fa.ImageUrl = imagePath

        try! DBPool.write { db in
            do {
                try fa.insert(db)
            } catch let error as DatabaseError {
                print(error.localizedDescription)
            }
        }
    }
    
}

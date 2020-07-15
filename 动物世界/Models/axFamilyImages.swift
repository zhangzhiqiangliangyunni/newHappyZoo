//
//  axFamilyImages.swift
//  动物世界
//
//  Created by zhangzhiqiang on 2020/7/10.
//  Copyright © 2020 zhangzhiqiang. All rights reserved.
//

import GRDB

class axFamilyImages: Record {
    var Images: String?
    var Titles: String?
    var ImageUrl: String?
    var Time: Double = Date().timeIntervalSince1970

    override init() {
        super.init()
    }

    override class var databaseTableName: String {
        return "axFamilyImages"
    }

    override func insert(_ db: Database) throws {
        try super.insert(db)
    }

    required init(row: Row) {
        Time = row["Time"]
        Images = row["Images"]
        Titles = row["Titles"]
        ImageUrl = row["ImageUrl"]
        super.init(row: row)
    }

    override func encode(to container: inout PersistenceContainer) {
        container["Time"] = Time
        container["Images"] = Images
        container["Titles"] = Titles
        container["ImageUrl"] = ImageUrl
    }

    var persistentDictionary: [String : DatabaseValueConvertible?] {
        var returnDic = [String : DatabaseValueConvertible?]()
        returnDic.updateValue(Time, forKey: "Time")
        returnDic.updateValue(Titles, forKey: "Titles")
        returnDic.updateValue(Images, forKey: "Images")
        returnDic.updateValue(ImageUrl, forKey: "ImageUrl")
        return returnDic
    }
}

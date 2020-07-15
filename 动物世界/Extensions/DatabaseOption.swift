//
//  DatabaseOption.swift
//  动物世界
//
//  Created by zhangzhiqiang on 2020/7/10.
//  Copyright © 2020 zhangzhiqiang. All rights reserved.
//

import UIKit
import GRDB
import Palau
import PromiseKit

var DBQueue: DatabaseQueue! //允许多线程并发访问
var DBPool: DatabasePool!   //线程安全的防止并发访问,在每一个时刻，都有一个单独的线程使用数据库.

class DatabaseOption: NSObject {

    let liveDBFileName = "FamilyImagesDB.sqlite"
    
    func setupLiveDatabase() { //application: UIApplication
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        let databasePath = documentsPath.appendingPathComponent(liveDBFileName)
        print(databasePath)
        DBQueue = try! DatabaseQueue(path: databasePath)
        DBQueue.setupMemoryManagement(in: UIApplication.shared)
        
        DBPool = try! DatabasePool(path: databasePath)
        DBPool.setupMemoryManagement(in: UIApplication.shared)
        updateColumn()
    }
    
     //MARK: Modal添加新字段后，要在DB中保持一致
     func updateColumn() {
         try! DBPool.write { db in
             do {
                 
                 //如果没有,创建axFamilyImages表
                 if let _ = try String.fetchOne(db, sql: "select sql from sqlite_master where tbl_name = 'axFamilyImages' and type = 'table'") {
                     
                 } else {
                     try db.execute(
                         sql: "CREATE TABLE IF NOT EXISTS axFamilyImages (Time real NOT NULL DEFAULT(0),Images text,Titles text,ImageUrl text)"
                     )
                 }
          
             }
             catch let error as DatabaseError {
                 print(error.description)
             }
         }

     }
    
    
}

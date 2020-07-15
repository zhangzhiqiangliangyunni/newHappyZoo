//
//  Singleton.swift
//  动物世界
//
//  Created by zhangzhiqiang on 2020/6/14.
//  Copyright © 2020 zhangzhiqiang. All rights reserved.
//

import Foundation

class mySingleton: NSObject {
    
    var dataSourceImgsSingleton:[ImageSource] = [ImageSource]()
    var noteSource: String = ""
    
    @objc static let shareInstance = mySingleton()
    
    private override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clearAll() {
        dataSourceImgsSingleton.removeAll()
        noteSource.removeAll()
    }
}

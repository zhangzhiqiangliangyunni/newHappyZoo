//
//  PalauDefaults + default.swift
//  动物世界
//
//  Created by zhangzhiqiang on 2020/7/9.
//  Copyright © 2020 zhangzhiqiang. All rights reserved.
//

import Foundation
import Palau

extension PalauDefaults {

    //UserDefault储存相册选取或者拍照得到的图片 和 对应图片下自定义的名字 title
    public static var albumOrTakePictureGetImages: PalauDefaultsEntry<[(String,String)]> {
        get { return value("albumOrTakePictureGetImages") }
        set { }
    }

}

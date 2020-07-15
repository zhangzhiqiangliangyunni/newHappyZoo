//
//  AlertSelectView.swift
//  动物世界
//
//  Created by zhangzhiqiang on 2020/6/14.
//  Copyright © 2020 zhangzhiqiang. All rights reserved.
//

import UIKit

class AlertSelectView: UIView {
    
    var takePictureBlock: (() -> Void)?
    func takePicture(_ block: @escaping () -> Void) {
        takePictureBlock = block
    }
    
    var selectPictureBlock: (() -> Void)?
    func selectPicture(_ block: @escaping () -> Void) {
        selectPictureBlock = block
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func TakePicture(_ sender: UIButton) {
        if let takePictureBlock = takePictureBlock{
            takePictureBlock()
        }
    }
    
    @IBAction func selectPicture(_ sender: UIButton) {
        if let selectPictureBlock = selectPictureBlock{
            selectPictureBlock()
        }
    }
    
    @IBAction func exitBtnAction(_ sender: Any) {
        self.superview?.removeFromSuperview()
    }
    
}

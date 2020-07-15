//
//  addNewItemCell.swift
//  动物世界
//
//  Created by zhangzhiqiang on 2020/6/13.
//  Copyright © 2020 zhangzhiqiang. All rights reserved.
//

import UIKit

class addNewItemCell: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!
    

    var clickBgImgViewBlock: (() -> Void)?
    func clickBgView(_ block: @escaping () -> Void) {
        clickBgImgViewBlock = block
    }
  
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    func setUI() {
        let tap1 = UITapGestureRecognizer()
        tap1.addTarget(self, action: #selector(tapAction))
        bgView.addGestureRecognizer(tap1)
    }
    
    //点击图片要显示的效果
    @objc func tapAction() {
        clickBgImgViewBlock?()
    }


}

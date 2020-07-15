//
//  CustomPickerView.swift
//  AldeloExpress
//
//  Created by jiangxia on 16/9/12.
//  Copyright © 2016年 Aldelo. All rights reserved.
//

import UIKit

class CustomPickerView: UIView {
    
    var themeColor = UIColor(rgba: "#1086FF")
    
    var defalutSelected: Int = 0 {
        didSet {
            myPickView?.selectRow(defalutSelected, inComponent: 0, animated: true)
        }
    }
    
    var dataArray = [String]() {
        didSet {
            if myPickView != nil {
                myPickView.reloadAllComponents()
            }
        }
    }
    
    typealias GetPickerText = (_ text: String?) -> Void
    var getPickerText: GetPickerText?
    
    typealias GetPickerIndex = (_ index: Int) -> Void
    var getPickerIndex: GetPickerIndex?
    
    
    fileprivate var myPickView: UIPickerView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createPickerView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createPickerView()
    }
    
    func createPickerView() {
        
        myPickView = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        myPickView.layer.masksToBounds = true
        myPickView.layer.cornerRadius = 10
        myPickView.layer.borderColor = themeColor.cgColor
        myPickView.layer.borderWidth = 6
        myPickView.backgroundColor = UIColor.clear
        myPickView.delegate = self
        myPickView.dataSource = self
        
        let displayBgView = UIView()
        displayBgView.backgroundColor = themeColor
        addSubview(displayBgView)
        displayBgView.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(-8)
            make.right.equalTo(snp.right).offset(8)
            make.centerY.equalTo(snp.centerY)
            make.height.equalTo(50)
        }
        addSubview(myPickView)
        
        myPickView.snp.makeConstraints { (make) in
            make.edges.equalTo(snp.edges)
        }
    }
    
}

extension CustomPickerView: UIPickerViewDelegate,UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArray.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return self.frame.size.height / 5
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let str = dataArray[row]
        let attStr = NSMutableAttributedString (string: str, attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
        return attStr
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 取Text
        if let getPickerText = getPickerText {
            getPickerText(dataArray[row])
        }
        
        // 取Index
        getPickerIndex?(row)
    }
}


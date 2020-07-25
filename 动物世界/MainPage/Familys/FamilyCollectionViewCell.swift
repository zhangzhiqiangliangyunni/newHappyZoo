//
//  FamilyCollectionViewCell.swift
//  动物世界
//
//  Created by zhangzhiqiang on 2020/6/11.
//  Copyright © 2020 zhangzhiqiang. All rights reserved.
//

import UIKit

class FamilyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var displayImage: UIButton!
    
    @IBOutlet weak var EditTextField: EditItemView!
    
    @IBOutlet weak var clearBtn: UIButton!
    
    var cellIndex: Int = 0
    
    var editTextFieldBlock: (() -> Void)?
    func editTextField(_ block: @escaping () -> Void) {
        editTextFieldBlock = block
    }
    
    var endEditTextFieldBlock: (() -> Void)?
    func endEditTextField(_ block: @escaping () -> Void) {
        endEditTextFieldBlock = block
    }
    
    var clickDisplayImgViewBlock: ((Int) -> Void)?
    func clickDisplayImg(_ block: @escaping (Int) -> Void) {
        clickDisplayImgViewBlock = block
    }
    
    var getInputTextBlock :((String?, Int) ->Void)?
    func getInputText(_ block :@escaping ((String?,Int) ->Void)) {
        getInputTextBlock = block
    }
    
    var delete: ((Int?) -> Void)?
    var longPress: ((Int?) -> Void)?
    
    func setupContent(displayImage: UIImage, familyText: String){
        self.displayImage.setBackgroundImage(displayImage, for: .normal)
        self.EditTextField.originText = familyText
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        clearBtn.layer.cornerRadius = 18
        clearBtn.isHidden = true
        
        let str = NSAttributedString(string: "输入对应人物名字", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 18)])
        EditTextField.attributePlaceHolder = str
        
        EditTextField.keyboardType = CustomerKeyboardType.systemType(type: .default, length: 50)
        EditTextField.font = UIFont.boldSystemFont(ofSize: 17)
        EditTextField.hasSelectedShadow = true
        EditTextField.inputText.autocapitalizationType = .sentences
        EditTextField.textColor = UIColor.black
        EditTextField.attributePlaceHolder = str
        
        EditTextField.didBeiginEditHandler = {[unowned self] in
            self.EditTextField.textColor = UIColor.black
            self.editTextFieldBlock?()
        }
        
        EditTextField.didEndEditHandler = { [unowned self] in
            
            EditItemView.hideKeyboard()
            self.EditTextField.textColor = UIColor.black
            
            if let text = self.EditTextField.originText?.trim(), hasElement(text) {
                self.getInputTextBlock?(text, self.cellIndex)
            }else{
                self.getInputTextBlock?("", self.cellIndex)
            }
            
            self.endEditTextFieldBlock?()
            
        }
        
        //cell长按抖动
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction))
        longpress.minimumPressDuration = 1.0
        addGestureRecognizer(longpress)
    }
    
    @objc func longPressAction(gesture: UILongPressGestureRecognizer) {
           if gesture.state == .began {
            longPress?(cellIndex)
           }
       }

    @IBAction func clearAction(_ sender: Any) {
        delete?(cellIndex)
    }
    
    @IBAction func clickImgBtnAction(_ sender: Any) {
        clickDisplayImgViewBlock?(cellIndex)
    }

}

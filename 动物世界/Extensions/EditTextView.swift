//
//  EditTextView.swift
//  动物世界
//
//  Created by zhangzhiqiang on 2020/7/5.
//  Copyright © 2020 zhangzhiqiang. All rights reserved.
//

import UIKit

@IBDesignable class EditTextView: UIView {
    
    let selectView = SelectedBgView(frame: CGRect.zero)
    var placeHolderLabel: UILabel!
    var textView: UITextView!
    
    var shouldBeginHandler: (() -> Bool)?
    var shouldEndHandler: (() -> Bool)?
    var canDidchangeHandler: (() -> Void)?
    var beginEditHandler: (() -> Void)?
    var endEditHandeler:  (() -> Void)?
    var canEnterReturn: Bool = true
    var limitLength: Int? = nil
    
    var text: String? {
        get {
            return textView.text
        }
        set {
            textView.text = newValue
            if hasPlaceholder && !hasElement(newValue) {
                placeHolderLabel.isHidden = false
            } else {
                placeHolderLabel.isHidden = true
            }
        }
    }
    
    @IBInspectable var bgColor: UIColor = UIColor(rgba: "#464646") {
        didSet {
            textView.backgroundColor = bgColor
        }
    }
    
    @IBInspectable var  hasPlaceholder: Bool = true {
        didSet {
            placeHolderLabel.isHidden = !hasPlaceholder
        }
    }
    
    var attributePlaceholder: NSAttributedString? {
        didSet {
            if let attributePlaceholder = attributePlaceholder {
                placeHolderLabel.attributedText = attributePlaceholder
            } else {
                placeHolderLabel.attributedText = nil
            }
        }
    }
    
    var font: UIFont = UIFont.boldSystemFont(ofSize: 18) {
        didSet {
            textView.font = font
        }
    }
    
    @IBInspectable var textColor = UIColor(rgba: "#FFFFFF") {
        didSet {
            textView.textColor = textColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        
        backgroundColor = UIColor.clear
        
        textView = UITextView(frame: CGRect.zero)
        textView.showsHorizontalScrollIndicator = false
        textView.showsVerticalScrollIndicator = false
        textView.delegate = self
        textView.autocapitalizationType = .none
        textView.textAlignment = .center
        textView.keyboardAppearance = .dark
        
        placeHolderLabel = UILabel(frame: CGRect.zero)
        placeHolderLabel.textAlignment = .center
        
        selectView.isHidden = true
        
        addSubview(selectView)
        addSubview(textView)
        addSubview(placeHolderLabel)
        
        selectView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        textView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        placeHolderLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0))
        }
    }
    
    func hideKeyboard() {
        textView.resignFirstResponder()
        selectView.isHidden = true
    }
}


extension EditTextView: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if let shouldBeginHandler = shouldBeginHandler {
            return shouldBeginHandler()
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if let shouldEndHandler = shouldEndHandler {
            return shouldEndHandler()
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        selectView.isHidden = false
        placeHolderLabel.isHidden = true
        textView.backgroundColor = UIColor.clear
        
        beginEditHandler?()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        selectView.isHidden = true
        textView.backgroundColor = bgColor
        
        if !hasElement(textView.text) && hasPlaceholder {
            placeHolderLabel.isHidden = false
        } else {
            placeHolderLabel.isHidden = true
        }
        
        endEditHandeler?()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        canDidchangeHandler?()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" && canEnterReturn {
            textView.resignFirstResponder()
            return false
        }
        
        if text != "" {
            if let max = limitLength {
                if let oldCount = textView.text?.utf16.count {
                    let count = oldCount + text.utf16.count
                    return count <= max
                }
            }
        }
        return true
    }
}

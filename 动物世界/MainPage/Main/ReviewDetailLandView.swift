//
//  ReviewDetailLandView.swift
//  动物世界
//
//  Created by zhangzhiqiang on 2020/7/5.
//  Copyright © 2020 zhangzhiqiang. All rights reserved.
//

import UIKit
import LeanCloud

class ReviewDetailLandView: UIView {
    
    @IBOutlet weak var noteView: EditTextView!
    @IBOutlet weak var submit: UIButton!
    
    var removeDetailLandViewBlock: (() -> Void)?
    func removeDetailLandView(_ block: @escaping () -> Void) {
        removeDetailLandViewBlock = block
    }
    
    deinit {
        //self移除之后要保证ReviewSubmitView的用户交互打开
        removeDetailLandViewBlock?()
    }
 
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    
    func configView() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 16
        self.alpha = 0.95
        
        noteView.textView.layer.cornerRadius = 16
        noteView.clipsToBounds = true
        submit.layer.cornerRadius = 10
        noteView.attributePlaceholder = reuqireString("写下你想要对我们说的话...")
        noteView.textView.textAlignment = .left
        noteView.placeHolderLabel.textAlignment = .center
        noteView.text = mySingleton.shareInstance.noteSource
        noteView.hasPlaceholder = true
        noteView.font = UIFont.boldSystemFont(ofSize: 18)
        noteView.canEnterReturn = false
        noteView.textColor = UIColor.white
        noteView.limitLength = 500
        self.submit.isUserInteractionEnabled = false
        
        noteView.canDidchangeHandler = {[weak self] in
            if hasElement(self?.noteView.text?.trim()) {
                self?.submit.backgroundColor = UIColor(rgba: "#8FC9B7")
                self?.submit.setTitleColor(UIColor.black, for: .normal)
                self?.submit.setImage(UIImage(named: "MerchantServiceApplicationSubmit"), for: .normal)
                self?.submit.isUserInteractionEnabled = true
            }else{
                self?.submit.backgroundColor = UIColor.clear
                self?.submit.setTitleColor(UIColor.gray, for: .normal)
                self?.submit.setImage(UIImage(named: "HelpDisableSubmitSupportCase"), for: .normal)
                self?.submit.isUserInteractionEnabled = false
            }
            
            if hasElement(self?.noteView.text?.trim()){
                if let note = self?.noteView.text {
                    mySingleton.shareInstance.noteSource = note
                }else{
                    self?.noteView.attributePlaceholder = self?.reuqireString("留下你想要对我们说的话...") //Notes
                }
            }
        }
        
        noteView.beginEditHandler = {[weak self] in
            guard let `self` = self else { return }
            self.noteView.textColor = UIColor.black
            
            UIView.animate(withDuration: TimeInterval(0.2), delay: 0, options: UIView.AnimationOptions.curveLinear, animations: { [weak self] in
                self?.frame.origin.y = (self?.frame.origin.y ?? 0) - UIScreen.main.bounds.size.height/4 + 30
            })
        }
        
        noteView.endEditHandeler = {[weak self] in
            guard let `self` = self else { return }
            self.noteView.textColor = UIColor.black
            self.noteView.bgColor = UIColor(rgba: "#FAFAF9")
            mySingleton.shareInstance.noteSource = ""
            
            if hasElement(self.noteView.text?.trim()){
                if let note = self.noteView.text {
                    mySingleton.shareInstance.noteSource = note
                }else{
                    self.noteView.attributePlaceholder = self.reuqireString("留下你想要对我们说的话...") //Notes
                }
                
                UIView.animate(withDuration: TimeInterval(0.2), delay: 0, options: UIView.AnimationOptions.curveLinear, animations: { [weak self] in
                    self?.frame.origin.y = (self?.frame.origin.y ?? 0) + UIScreen.main.bounds.size.height/4 - 30
                })
            }
        }
    }
    
    @IBAction func submitAction(_ sender: Any) {
    
        //使用LeanCloud获取用户评价
        DispatchQueue.global().async {
            do {
                let testObject = LCObject(className: "TestObject")
                try testObject.set("words", value: mySingleton.shareInstance.noteSource)
                let result = testObject.save()
                if let error = result.error {
                    print(error)
                }
            } catch {
                print(error)
            }
        }

        //动画移除self
        self.noteView.textView.endEditing(true)
        EditItemView.hideKeyboard()
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.frame.origin.y = -(self?.frame.height ?? 0)
        }, completion: { [weak self] _ in
            mySingleton.shareInstance.noteSource = ""
            self?.superview?.removeFromSuperview()
        })
    }
    
    @IBAction func exitAction(_ sender: Any) {

        self.noteView.textView.endEditing(true)
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.frame.origin.y = -(self?.frame.height ?? 0)
        }, completion: { [weak self] _ in
            self?.superview?.superview?.removerCover()
        })
        
    }
    
    func reuqireString(_ name: String) -> NSAttributedString? {
        let requiredStr = NSAttributedString(string: name, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 20)])
        return requiredStr
    }
    
}

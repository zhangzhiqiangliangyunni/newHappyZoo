//
//  EDCEditItemView.swift
//  AldeloExpress
//
//  Created by WangHui on 16/7/5.
//  Copyright © 2016年 Aldelo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Palau
import SnapKit

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


var currentEditingView: EditItemView?

enum CustomerKeyboardType {
    case systemType(type: UIKeyboardType, length: Int?)
    case customNumPad(size: CGSize?, length: Int?, onlyUseNum: Bool) // 默认400 * 400 onlyUseNum为true的时候 0和00就是字面值 否则为10, 100
    case customPicker(size: CGSize?, dataArray: [String]) // 默认View.Width * 160.0
    case otherCustomPad                                   // 如果使用在BeginEidting中其他自定义键盘 设置这个枚举
}

// 键盘与TextFiled的对齐方式
enum KeyboardAlign {
    case right, center, left
}

//@IBDesignable
class EditItemView: UIView {

    fileprivate let disposeBag = DisposeBag()
    
    @IBInspectable var defaultBgColor: UIColor = UIColor(rgba: "#DADADA") {
        didSet {
            backgroundColor = defaultBgColor
        }
    }
    
    @IBInspectable var selectedBgColor: UIColor = UIColor(rgba: "#FFF69F") {
        didSet {
            selectBackView.bgColor = selectedBgColor
        }
    }
    
    var headerIcon: UIImageView!
    var tailIcon: UIImageView!
    var inputText: MyTextField!
    var titleLabel: UILabel!
    var inputTextlength = Int.max //能输入的最大字符长度。

    fileprivate var tempTextPlaceHolder: String?
    fileprivate var tempAttributePlaceHolder: NSAttributedString?
    var selectBackView: SelectedBgView! // 阴影背景
    var keyboard: UIView! // 可以重写键盘的闭包 覆盖默认处理
    
    
    // MARK: - 可添加操作
    typealias AfterAddKeyboardHandler = () -> Void
    var afterAddKeyboardHandler: AfterAddKeyboardHandler?

    typealias ShouldBeiginEditHandler = () -> Bool
    var shouldBeiginEditHandler: ShouldBeiginEditHandler?
    
    typealias ShouldEndEditHandler = () -> Bool
    var shouldEndEditHandler: ShouldEndEditHandler?
    
    typealias DidBeiginEditHandler = () -> Void
    var didBeiginEditHandler: DidBeiginEditHandler?
    
    typealias DidEndEditHandler = () -> Void
    var didEndEditHandler: DidEndEditHandler?
    
    // 可对输入的数据进行处理 如：格式化
    typealias ChangeTextHandler = (_ text: String?) -> String?
    var changeTextHandler: ChangeTextHandler?
    
    // CustomNumPad: 删除时的额外处理
    typealias DeleteNumPadHandler = (_ text: String?) -> String?
    var deleteNumPadHandler: DeleteNumPadHandler?
    
    // CustomNumPad: Done时的额外处理
    typealias DoneNumPadHandler = (_ text: String?) -> Void
    var doneNumPadHandler: DoneNumPadHandler?
    
    
    // MARK: - 属性
    
    // Header Image
    @IBInspectable var hasHeaderImage: Bool = true {
        didSet {
            setNeedsUpdateConstraints()
            updateConstraintsIfNeeded()
        }
    }
    
    @IBInspectable var headerImage: UIImage? {
        didSet {
            headerIcon.image = headerImage
        }
    }
    
    var headerImageSize: CGSize? {
        didSet {
            setNeedsUpdateConstraints()
            updateConstraintsIfNeeded()
        }
    }
    
    /// {width, height}
    @IBInspectable var headerImageSizeString: String? {
        didSet {
            if let headerImageSizeString = headerImageSizeString  {
                headerImageSize = NSCoder.cgSize(for: headerImageSizeString)
            }
        }
    }
    
    @IBInspectable var headerSpace: Double = 15 {
        didSet {
            setNeedsUpdateConstraints()
            updateConstraintsIfNeeded()
        }
    }
    
    // Tail Image
    @IBInspectable var hasTailImage: Bool = true {
        didSet {
            setNeedsUpdateConstraints()
            updateConstraintsIfNeeded()
        }
    }
    
    @IBInspectable var tailImage: UIImage? {
        didSet {
            tailIcon.image = tailImage
        }
    }
    
    var tailImageSize: CGSize? {
        didSet {
            setNeedsUpdateConstraints()
            updateConstraintsIfNeeded()
        }
    }
    
    /// {width, height}
    @IBInspectable var tailImageSizeString: String? {
        didSet {
            if let tailImageSizeString = tailImageSizeString  {
                tailImageSize = NSCoder.cgSize(for: tailImageSizeString)
            }
        }
    }
    
    @IBInspectable var tailSpace: Double = 15 {
        didSet {
            setNeedsUpdateConstraints()
            updateConstraintsIfNeeded()
        }
    }
    
    @IBInspectable var tailImageY: Double = 0.0 {
        didSet {
            setNeedsUpdateConstraints()
            updateConstraintsIfNeeded()
        }
    }
    
    
    // Input Text
    @IBInspectable var textHeaderSpace: Double = 8 {
        didSet {
            setNeedsUpdateConstraints()
            updateConstraintsIfNeeded()
        }
    }
    
    @IBInspectable var textTailSpace: Double = 8 {
        didSet {
            setNeedsUpdateConstraints()
            updateConstraintsIfNeeded()
        }
    }
    
    // 系统键盘时使用
    fileprivate var shouldChangeText: Bool = true
    fileprivate var tempOriginText: String?
    
    // 原始值 设置原始值得时候 先给text赋值
    var originText: String? {
        didSet {
            if shouldChangeText {
                text = originText
            }
            if originText == nil {
                tempOriginText = nil
            }            
            rx_text.onNext(originText ?? "")  // do next

            NotificationCenter.default.post(name: Notification.Name(rawValue: "AutoLogout"), object: nil)

        }
    }
    
    // 显示的值
    @IBInspectable fileprivate var text: String? {
        set {
            if newValue == nil {
                if tempTextPlaceHolder != nil {
                    inputText.placeholder = tempTextPlaceHolder
                }
                if tempAttributePlaceHolder != nil {
                    inputText.attributedPlaceholder = tempAttributePlaceHolder
                }
            }
            
            inputText.text = newValue
        }
        get {
            return inputText.text
        }
    }

    @IBInspectable var placeHolder: String? {
        didSet {
            if let placeHolder = placeHolder {
                inputText.placeholder = placeHolder
            } else {
                inputText.placeholder = nil
            }
            tempTextPlaceHolder = placeHolder
        }
    }
    
    @IBInspectable var attributePlaceHolder: NSAttributedString? {
        didSet {
            inputText.attributedPlaceholder = attributePlaceHolder
            tempAttributePlaceHolder = attributePlaceHolder
        }
    }
    
    @IBInspectable var secureText: Bool = false {
        didSet {
            inputText.isSecureTextEntry = secureText
        }
    }
    
    @IBInspectable var selected: Bool = false {
        didSet {
            if selected {
                shouldAddShadow = true
                
                if !hasSelectedShadow {
                    backgroundColor = selectedBgColor
                }
                
                inputText.placeholder = nil
                inputText.attributedPlaceholder = nil
                
                if currentEditingView != self {
                    addKeyboard()
                }
                
                currentEditingView = self
                
            } else {
                
                shouldAddShadow = false
                
                backgroundColor = defaultBgColor
                
                if hasElement(text?.trim()) {
                    inputText.placeholder = nil
                    inputText.attributedPlaceholder = nil
                } else {
                    inputText.placeholder = tempTextPlaceHolder
                    // 只有当tempAttributePlaceHolder有值的时候 才设置attributePlaceHolder 否则会覆盖placeHolder
                    if let tempAttributePlaceHolder = tempAttributePlaceHolder {
                        inputText.attributedPlaceholder = tempAttributePlaceHolder
                    }
                }
                
                removeKeyboard()
                
                // 重置isManualTap状态
                inputText.isManualTap = false
            }
        }
    }
    
    @IBInspectable var textColor: UIColor = UIColor.gray {
        didSet {
            inputText.textColor = textColor
        }
    }
    
    var font: UIFont = UIFont.systemFont(ofSize: 26) {
        didSet {
            inputText.font = font
        }
    }
    
    // 输入内容的限制长度(原始值的长度originText)
    fileprivate var limitLength: Int? = 0
    var keyboardType: CustomerKeyboardType = .systemType(type: .default, length: nil) {
        didSet {
            switch keyboardType {
            case .systemType(let type, let length):
                inputText.keyboardType = type
                limitLength = length
                inputTextlength = length ?? Int.max
            default:
                initKeyboard()
            }
        }
    }
    var keyboardAlign: KeyboardAlign = .center
    var keyboardAppearance: UIKeyboardAppearance = .dark {
        didSet {
            inputText.keyboardAppearance = keyboardAppearance
        }
    }
    
    var rx_text = PublishSubject<String>()
    
    // Title Label 设置
    @IBInspectable var titleColor: UIColor = UIColor.gray {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    
    var titleFont: UIFont = UIFont.boldSystemFont(ofSize: 26) {
        didSet {
            titleLabel.font = titleFont
        }
    }

    @IBInspectable var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    // title的宽度
    @IBInspectable var titleWidth: CGFloat = 0.0 {
        didSet {
            setNeedsUpdateConstraints()
            updateConstraintsIfNeeded()
        }
    }
    
    // MARK: - 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    func initView() {
        selectBackView = SelectedBgView(frame: bounds)
        headerIcon = UIImageView()
        tailIcon = UIImageView()
        inputText = MyTextField()
        titleLabel = UILabel()
        
        // inputText.backgroundColor = UIColor.brownColor()
        addSubview(selectBackView)
        addSubview(headerIcon)
        addSubview(tailIcon)
        addSubview(inputText)
        addSubview(titleLabel)
        
        selectBackView.isHidden = true
        sendSubviewToBack(selectBackView)
        
        // 设置圆角
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        // 背景色
        backgroundColor = defaultBgColor
        
        // 输入框 样式
        inputText.textAlignment = .center
        inputText.font = font
        inputText.textColor = textColor
        inputText.delegate = self
        inputText.autocapitalizationType = .none
        inputText.autocorrectionType = .no
        inputText.keyboardAppearance = .dark
        inputText.adjustsFontSizeToFitWidth = true
        
        titleLabel.textAlignment = .left
        titleLabel.font = titleFont
        titleLabel.textColor = titleColor
        titleLabel.backgroundColor = UIColor.clear
        
        selectBackView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }

        // 默认布局 除headerSpace和tailSpace外其他的间距 默认是8
        headerIcon.snp.makeConstraints { (make) in
            make.width.equalTo(60)
            make.left.equalTo(snp.left).offset(headerSpace)
            make.top.equalTo(snp.top).offset(8)
            make.bottom.equalTo(snp.bottom).offset(-8)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.width.equalTo(titleWidth)
            make.top.equalTo(snp.top).offset(8)
            make.bottom.equalTo(snp.bottom).offset(-8)
            make.left.equalTo(headerIcon.snp.right)
        }
        
        // 当宽度不够的时候 优先满足headerIcon
        tailIcon.snp.makeConstraints { (make) in
            make.width.equalTo(60)
            make.right.equalTo(snp.right).offset(-tailSpace)
            make.top.equalTo(snp.top).offset(8)
            make.bottom.equalTo(snp.bottom).offset(-8)
        }
        
        inputText.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(textHeaderSpace)
            make.top.equalTo(snp.top).offset(8)
            make.right.equalTo(tailIcon.snp.left).offset(-textTailSpace)
            make.bottom.equalTo(snp.bottom).offset(-8)
        }
        
        // 当宽度不够的时候 优先满足Icon
        inputText.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: NSLayoutConstraint.Axis.horizontal)
        inputText.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
        
        textChanged()
    }
    
    // MARK: - 布局
    override class var requiresConstraintBasedLayout : Bool {
        return true
    }
    
    override func updateConstraints() {
        
        titleLabel.snp.remakeConstraints { (make) in
            make.width.equalTo(titleWidth)
            make.top.equalTo(snp.top).offset(8)
            make.bottom.equalTo(snp.bottom).offset(-8)
            make.left.equalTo(headerIcon.snp.right)
        }
        
        if hasHeaderImage && hasTailImage{
            
            headerIcon.snp.remakeConstraints { (make) in
                if let headerImageSize = headerImageSize {
                    make.width.equalTo(headerImageSize.width)
                    make.height.equalTo(headerImageSize.height)
                    make.centerY.equalTo(snp.centerY)
                    make.left.equalTo(snp.left).offset(headerSpace)
                } else {
                    make.width.equalTo(60)
                    make.left.equalTo(snp.left).offset(headerSpace)
                    make.top.equalTo(snp.top).offset(8)
                    make.bottom.equalTo(snp.bottom).offset(-8)
                }
            }
            
            tailIcon.snp.remakeConstraints { (make) in
                if let tailImageSize = tailImageSize {
                    make.width.equalTo(tailImageSize.width)
                    make.height.equalTo(tailImageSize.height)
                    make.centerY.equalTo(snp.centerY).offset(tailImageY)
                    make.right.equalTo(snp.right).offset(-tailSpace)
                } else {
                    make.width.equalTo(60)
                    make.right.equalTo(snp.right).offset(-tailSpace)
                    make.top.equalTo(snp.top).offset(8)
                    make.bottom.equalTo(snp.bottom).offset(-8)
                }
            }
            
            inputText.snp.remakeConstraints { (make) in
                make.left.equalTo(titleLabel.snp.right).offset(textHeaderSpace)
                make.top.equalTo(snp.top).offset(8)
                make.right.equalTo(tailIcon.snp.left).offset(-textTailSpace)
                make.bottom.equalTo(snp.bottom).offset(-8)
                
            }
            
        } else if hasHeaderImage {
            
            headerIcon.snp.remakeConstraints { (make) in
                if let headerImageSize = headerImageSize {
                    make.width.equalTo(headerImageSize.width)
                    make.height.equalTo(headerImageSize.height)
                    make.centerY.equalTo(snp.centerY)
                    make.left.equalTo(snp.left).offset(headerSpace)
                } else {
                    make.width.equalTo(60)
                    make.left.equalTo(snp.left).offset(headerSpace)
                    make.top.equalTo(snp.top).offset(8)
                    make.bottom.equalTo(snp.bottom).offset(-8)
                }
            }
            
            tailIcon.snp.remakeConstraints { (make) in
                make.size.equalTo(CGSize.zero)
                make.right.equalTo(snp.right)
            }
            
            inputText.snp.remakeConstraints { (make) in
                make.left.equalTo(titleLabel.snp.right).offset(textHeaderSpace)
                make.top.equalTo(snp.top).offset(8)
                make.right.equalTo(tailIcon.snp.left).offset(-textTailSpace)
                make.bottom.equalTo(snp.bottom).offset(-8)
            }
            
        } else if hasTailImage {
        
            headerIcon.snp.remakeConstraints { (make) in
                make.size.equalTo(CGSize.zero)
                make.left.equalTo(snp.left)
            }
            
            tailIcon.snp.remakeConstraints { (make) in
                if let tailImageSize = tailImageSize {
                    make.width.equalTo(tailImageSize.width)
                    make.height.equalTo(tailImageSize.height)
                    make.centerY.equalTo(snp.centerY).offset(tailImageY)
                    make.right.equalTo(snp.right).offset(-tailSpace)
                } else {
                    make.width.equalTo(60)
                    make.right.equalTo(snp.right).offset(-tailSpace)
                    make.top.equalTo(snp.top).offset(8)
                    make.bottom.equalTo(snp.bottom).offset(-8)
                }
            }
            
            inputText.snp.remakeConstraints { (make) in
                make.left.equalTo(titleLabel.snp.right).offset(textHeaderSpace)
                make.top.equalTo(snp.top).offset(8)
                make.right.equalTo(tailIcon.snp.left).offset(-textTailSpace)
                make.bottom.equalTo(snp.bottom).offset(-8)
            }

            
        } else {
            headerIcon.snp.remakeConstraints { (make) in
                make.size.equalTo(CGSize.zero)
                make.left.equalTo(snp.left)
            }
            
            tailIcon.snp.remakeConstraints { (make) in
                make.size.equalTo(CGSize.zero)
                make.right.equalTo(snp.right)
            }
            
            inputText.snp.remakeConstraints { (make) in
                make.left.equalTo(titleLabel.snp.right).offset(textHeaderSpace)
                make.top.equalTo(snp.top).offset(8)
                make.right.equalTo(snp.right).offset(-textTailSpace)
                make.bottom.equalTo(snp.bottom).offset(-8)
            }
        }
        
        super.updateConstraints()
    }
    
    @IBInspectable var hasSelectedShadow: Bool = false
    
    var shouldAddShadow: Bool = false {
        didSet {
            if hasSelectedShadow && shouldAddShadow {
                // setNeedsDisplay()
                selectBackView.isHidden = !shouldAddShadow
            } else {
                selectBackView.isHidden = true
            }
        }
    }
    
    override func draw(_ rect: CGRect) {

    }

}

class SelectedBgView: UIView {
    
    var bgColor: UIColor = UIColor(rgba: "#FFF69F") {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var addRadius: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        //// Shadow Declarations
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.gray.withAlphaComponent(0.7)
        shadow.shadowOffset = CGSize(width: 0.9, height: 0.5)
        shadow.shadowBlurRadius = 3
        
        //// Rectangle Drawing
        var rectanglePath = UIBezierPath(roundedRect: rect, cornerRadius: 10)
        if !addRadius {
            rectanglePath = UIBezierPath(roundedRect: rect, cornerRadius: 0)
        }
        bgColor.setFill()
        rectanglePath.fill()
        
        ////// Rectangle Inner Shadow
        context?.saveGState()
        context?.clip(to: rectanglePath.bounds)
        context?.setShadow(offset: CGSize(width: 0, height: 0), blur: 0)
        context?.setAlpha(((shadow.shadowColor as! UIColor).cgColor).alpha)
        context?.beginTransparencyLayer(auxiliaryInfo: nil)
        let rectangleOpaqueShadow = (shadow.shadowColor as! UIColor).withAlphaComponent(1)
        context?.setShadow(offset: shadow.shadowOffset, blur: shadow.shadowBlurRadius, color: rectangleOpaqueShadow.cgColor)
        context?.setBlendMode(.sourceOut)
        context?.beginTransparencyLayer(auxiliaryInfo: nil)
        
        rectangleOpaqueShadow.setFill()
        rectanglePath.fill()
        
        context?.endTransparencyLayer()
        context?.endTransparencyLayer()
        context?.restoreGState()
    }
    
}

// MARK: - UITextFieldDelegate
extension EditItemView: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        // 忽略Tab键
        if let tempTextField = textField as? MyTextField {
            if !tempTextField.isManualTap {return false}
        }
                
        if let shouldBeiginEditHandler = shouldBeiginEditHandler {
            if shouldBeiginEditHandler() == false {
                return false
            }
        }
        
        if currentEditingView != self {
            // 移除键盘
            if currentEditingView?.keyboard != nil {
                currentEditingView?.keyboard.removeFromSuperview()
            }
            
            // 判断当前是否是系统键盘 不是的话 取消编辑
            switch keyboardType {
            case .systemType:
                break
            default:
                currentEditingView?.inputText.endEditing(true)
                currentEditingView?.inputText.resignFirstResponder()
                break
            }
            
            if let doneNumPadHandler = currentEditingView?.doneNumPadHandler {
                doneNumPadHandler(currentEditingView?.originText)
            }
            
            currentEditingView?.selected = false
            selected = true
            
        } else {
            // 如果是当前编辑的View 只需要设置编辑状态
            if !hasSelectedShadow {
                backgroundColor = selectedBgColor
            } else {
                shouldAddShadow = true
            }

            inputText.placeholder = nil
            inputText.attributedPlaceholder = nil
        }
        
        var shouldBegin = true
        switch keyboardType {
        case .systemType:
            shouldBegin = true
            
            if changeTextHandler != nil {
                text = originText
            }
            
            if hasSelectedShadow {
                inputText.textColor = UIColor.black
            }
            
            break
        default:
            shouldBegin = false
            break
        }
        
        return shouldBegin
    }
    
    // 只有系统键盘才会BeginEdit => EndEditing
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if let shouldEndEditHandler = shouldEndEditHandler {
            if shouldEndEditHandler() == false {
                return false
            }
        }
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        didBeiginEditHandler?()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if hasSelectedShadow {
            inputText.textColor = textColor
        }
        
        selected = false
        
        // 如果系统键盘时需要格式化 可以在end的时候处理 在shouldChangeCharactersInRange 中文时有问题
        if let changeTextHandler = changeTextHandler {
            tempOriginText = originText
            text = changeTextHandler(originText)
        }
        
        didEndEditHandler?()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
       /* 代码和textFieldShouldEndEditing重复执行
        if let endEditHandler = endEditHandler {
            if endEditHandler() == false {
                return false
            }
        }
        
        shouldAddShadow = false
 
        if let changeTextHandler = changeTextHandler {
            tempOriginText = originText
            text = changeTextHandler(text: originText)
        }*/
        
        // 使用rxswift的话监听rx_text的话return会直接回收键盘
        // EditItemView.hideKeyboard()
        
        return true
    }
    
    func textChanged() {
        // 监听inputText变化 不添加在shouldChangeCharactersInRange是因为中文输入法时不走 无法设置originText
        inputText.rx.text.subscribe(onNext: {[unowned self] (text) in
            switch self.keyboardType {
            case .systemType(_, let length):
                self.shouldChangeText = false
                
                // 键盘输入模式  // 简体中文输入，包括简体拼音，健体五笔，简体手写
                if let lang = self.inputText.textInputMode?.primaryLanguage, let selectRange = self.inputText.markedTextRange, lang.hasPrefix("zh-") {
                    //获取高亮部分
                    let position = self.inputText.position(from: selectRange.start, offset: 0)
                    if position == nil {
//                        if length > 0 && text?.utf16.count > length {
//                            self.text = String(text![..<text!.index(text!.startIndex, offsetBy: length!)])
//                        }
                        self.text = text
                    } else {
                        // 有高亮选择的字符串，则暂不对文字进行统计和限制
                    }
                } else {
//                    if length > 0 && text?.utf16.count > length {
//                        self.text = String(text![..<text!.index(text!.startIndex, offsetBy: length!)])
//                    }
                    self.text = text
                }
                
                if self.tempOriginText != nil {
                    self.originText = self.tempOriginText
                    self.tempOriginText = nil
                } else {
                    self.originText = self.text
                }
                
                self.shouldChangeText = true // 重新设为true是为了在设置originTex的时候可以清空Text
            default:
                break // 不是系统键盘 不考虑
            }
        }).disposed(by: disposeBag)
    }
    
    // 处理不能输入的限定
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\t" {
            return false
        } else {
            if string != "" {
//                if let oldCount = textField.text?.utf16.count {
//                    let count = oldCount + string.utf16.count
//                    return count <= inputTextlength
//                }
                if let str = textField.text as NSString? {
                    let count = str.replacingCharacters(in: range, with: string).utf16.count
                    return count <= inputTextlength
                }
            }
            return true
        }
    }
    
    /* 中文输入法有问题 处理orignText放到了textChanged中
     func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // orignText处理
        if originText == nil  {
            originText = string
        } else if limitLength > 0 && originText?.characters.count >= limitLength  && string != "" {
            if originText?.characters.count > limitLength {
                originText = originText?.substringToIndex(originText!.startIndex.advancedBy(limitLength!))
            }
        } else {
            var s = NSString(string: originText!)
            s = s.stringByReplacingCharactersInRange(range, withString: string)
            originText = s as String
        }
        
        if let changeTextHandler = changeTextHandler {
            text = changeTextHandler(text: originText)
            return false
        }
        
        return false
    }*/
}

// MARK: - 键盘相关方法
extension EditItemView {
    
    // 外部调用时使用 如点击button完成处理的时候
    class func hideKeyboard() {
        
        if currentEditingView != nil {
            
            switch currentEditingView!.keyboardType {
            case .systemType:
                currentEditingView?.inputText.resignFirstResponder()
                break
            default:
                if currentEditingView?.keyboard != nil {
                    currentEditingView?.keyboard.removeFromSuperview()
                }
                break
            }

            if let doneNumPadHandler = currentEditingView?.doneNumPadHandler {
                doneNumPadHandler(currentEditingView?.originText)
            }
            
            currentEditingView?.selected = false
            currentEditingView = nil
        }
    }
    
    // MARK: - 自定义键盘
    fileprivate func initKeyboard() {
        
        // 没有SuperView 直接返回 无法添加键盘
        if superview == nil {
            return
        }
        
        switch keyboardType {
        case .customNumPad(let size, let length, let onlyUseNum):
            
            limitLength = length
            inputTextlength = length ?? Int.max
            
//            if size != nil {
//                keyboard = VerifyCodePad(frame:CGRect(x: 0, y: 0, width: size!.width, height: size!.height))
//            } else {
//                keyboard = VerifyCodePad(frame:CGRect(x: 0, y: 0, width: 400, height: 400))
//            }
            
            // 添加键盘的处理方法
//            let pad = keyboard as! VerifyCodePad
//            pad.edgeColor = UIColor(rgba: "#2B2B2B")
//            pad.color = UIColor(rgba: "#1086FF")
            
//            _ = pad.getNumber({ [unowned self](pad, num) in
//
//                // 如果只是使用字面的数字
//                var strNum = "\(num)"
//                if onlyUseNum {
//                    if num == 10 {
//                        strNum = "0"
//                    } else if num == 100 {
//                        strNum = "00"
//                    }
//                }
//
//                if self.originText == nil {
//                    self.originText = strNum
//                } else if self.limitLength > 0 && self.originText?.count >= self.limitLength {
//                    if self.originText?.count > self.limitLength {
//                        if let originText = self.originText {
//                            self.originText = String(originText[..<originText.index(originText.startIndex, offsetBy: self.limitLength!)])
//                        }
////                        self.originText = self.originText?.substring(to: self.originText!.characters.index(self.originText!.startIndex, offsetBy: self.limitLength!))
//                    }
//                    // == do nothing
//                } else {
//                    self.originText = self.originText! + strNum
//                }
//
//                if let changeTextHandler = self.changeTextHandler {
//                    self.text = changeTextHandler(self.originText)
//                }
//            })
            
//            _ = pad.deleteNumber({ [unowned self] in
//                if hasElement(self.originText) {
//                    var str = NSString(string: self.originText!)
//                    if str.length >= 2 {
//                        str = str.substring(to: str.length - 1) as NSString
//                    } else {
//                        str = ""
//                    }
//                    self.originText = str as String
//
//                    if let deleteNumPadHandler = self.deleteNumPadHandler {
//                        self.text = deleteNumPadHandler(self.originText)
//                    }
//                }
//            })
            
//            _ = pad.done({ [unowned self] in
//
//                self.shouldAddShadow = false
//
//                EditItemView.hideKeyboard()
//
//                // 执行了两次
//                /*if let doneNumPadHandler = self.doneNumPadHandler {
//                    doneNumPadHandler(text: self.originText)
//                }*/
//            })
            break
        case .customPicker(let size, let dataArray):
            if size != nil {
                keyboard = CustomPickerView(frame: CGRect(x: 0, y: 0, width: size!.width, height: size!.height))
            } else {
                keyboard = CustomPickerView(frame: CGRect(x: 0, y: 0, width: 200, height: 150))
            }
            
            let pad = keyboard as! CustomPickerView
            pad.dataArray = dataArray
            pad.defalutSelected = 0
            
            pad.getPickerText = { [unowned self] (str) in
                
                self.originText = str
                
                if let changeTextHandler = self.changeTextHandler {
                    self.text = changeTextHandler(self.originText)
                }
            }
            break
        default:
            break
        }
    }
    
    fileprivate func getViewController() -> UIViewController? {
        var next = superview
        
        while next != nil {
            
            let nextResponder = next?.next
            
            if nextResponder is UIViewController {
                return (nextResponder as! UIViewController)
            }
            
            next = next?.superview
        }
        
        return nil
    }
    
    fileprivate func removeKeyboard() {
        switch keyboardType {
        case .systemType:
            break
        default:
            if keyboard != nil {
                keyboard.removeFromSuperview()
            }
            break
        }
    }

    fileprivate func addKeyboard() {
        
        // 系统键盘和其他自定义键盘不需要处理
        switch keyboardType {
        case .systemType, .otherCustomPad:
            return
        default:
            break
        }
        
        // 没有父ViewController 不添加键盘
        guard let viewController = getViewController() else { return }
        
        // 创建键盘
        if keyboard == nil {
            initKeyboard()
        }
        viewController.view.addSubview(keyboard)
        keyboard.alpha = 0
        
        // 重新设置frame 将键盘放在中心位置下面
        guard let window = UIApplication.shared.keyWindow else { return }
        switch keyboardType {
        case .customNumPad(let size, let length, _):
            limitLength = length
            inputTextlength = length ?? Int.max
            if size != nil {
                keyboard.frame = CGRect(x: window.center.x - size!.width / 2, y: window.bounds.size.height, width: size!.width, height: size!.height)
            } else {
                let width: CGFloat = 400.0
                let height: CGFloat =  400.0
                keyboard.frame = CGRect(x: window.center.x - width / 2, y: window.bounds.size.height, width: width, height: height)
            }
            break
        case .customPicker(let size, let dataArray):
            if size != nil {
                keyboard.frame = CGRect(x: window.center.x  - size!.width / 2, y: window.bounds.size.height, width: size!.width, height: size!.height)
            } else {
                let width: CGFloat = bounds.width
                let height: CGFloat =  160.0
                keyboard.frame = CGRect(x: window.center.x - width / 2, y: window.bounds.size.height, width: width, height: height)
            }
            
            let pad = keyboard as! CustomPickerView
            pad.dataArray = dataArray
            
            break
        default:
            break
        }
        
        // 弹出键盘
        let rect = convert(bounds, to: viewController.view)
        let padCenter = CGPoint(x: rect.origin.x + rect.width / 2.0, y: rect.origin.y + rect.height + 8 + keyboard.frame.size.height / 2.0)
        let padRight = CGPoint(x: rect.origin.x, y: rect.origin.y + rect.height + 8)
        let padLeft = CGPoint(x: rect.origin.x + rect.width - keyboard.frame.size.width, y: rect.origin.y + rect.height + 8)
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            
            guard let _ = self else { return }
            
            switch self!.keyboardAlign {
            case .right:
                self!.keyboard.frame.origin = padRight
                break
            case .center:
                self!.keyboard.center = padCenter
                break
            case .left:
                self!.keyboard.frame.origin = padLeft
                break
            }
            
            self!.keyboard.alpha = 1.0
        }) 
        
        // 添加完键盘后设置text
        text = originText
        if let changeTextHandler = changeTextHandler {
            text = changeTextHandler(self.originText)
        }
        
        // 添加完键盘后的操作
        if let afterAddKeyboardHandler = afterAddKeyboardHandler {
            afterAddKeyboardHandler()
        }
    }
}

// MARK: - Helper Method
extension EditItemView {
    
    class func autoFillString(_ orignString: String?, fillString: String, length: Int) -> String {
        
        var fillLength: Int = length
        var result: String = ""
        
        if let orignString = orignString  {
            
            if orignString.count > length {
                result = String(orignString[..<orignString.index(orignString.startIndex, offsetBy: length)])
                return result
            } else if length <= 0 {
                result = orignString
                return result
            }
            
            result = orignString
            fillLength = length - orignString.count
        }
        
        for _ in 0..<fillLength {
            result.append(fillString)
        }
        
        return result
    }
    
    class func splitString(_ orignString: String, splitString: String, splitCount: Int) -> String {
        
        var result = ""
        
        let str = NSString(string: orignString)
        
        if str.length <= splitCount {
            result = str as String
            return result
        }
        
        var index = 0
        while true {
            
            var subStr = ""
            
            if index + splitCount >= str.length {
                subStr = str.substring(from: index)
                result = result.appendingFormat("%@", subStr)
                break
            }
            
            subStr = str.substring(with: NSMakeRange(index, splitCount))
            
            if !hasElement(result) {
                result = subStr + splitString
            } else {
                result = result.appendingFormat("%@%@", subStr, splitString)
            }
            
            index += splitCount
        }
        
        return result
    }
}

// 创建一个继承自UITextField的子类 是因为直接重写becomeFirstResponder 会导致光标不能出现
class MyTextField: UITextField {
    // 是否点击还是tab的标识 点击Tab键的时候会调用textshouldbeginEditing 添加的键盘方法会被调用
    var isManualTap: Bool = false
    
    @discardableResult
    open override func becomeFirstResponder() -> Bool {
        isManualTap = true
        return super.becomeFirstResponder()
    }
}

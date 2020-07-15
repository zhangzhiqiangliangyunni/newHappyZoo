//
//  ThemePicker.swift
//  SwiftTheme
//
//  Created by Gesen on 16/1/25.
//  Copyright © 2016年 Gesen. All rights reserved.
//

import UIKit

open class ThemePicker: NSObject, NSCopying {
    
    public typealias ValueType = () -> AnyObject?
    
    var value: ValueType
    
    required public init(v: @escaping ValueType) {
        value = v
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func copy(with zone: NSZone?) -> Any {
        return type(of: self).init(v: value)
    }
    
}

//添加Font
open class ThemeFontPicker: ThemePicker {
    public convenience init(keyPath: String) {
         self.init(v: { return ThemeManager.fontForKeyPath(keyPath) })
    }
    
    open class func pickerWithKeyPath(_ keyPath: String) -> ThemeFontPicker {
        return ThemeFontPicker(keyPath: keyPath)
    }
}

open class ThemeColorPicker: ThemePicker {
    
    public convenience init(keyPath: String) {
        self.init(v: { return ThemeManager.colorForKeyPath(keyPath) })
    }

    public convenience init(colors: String...) {
        self.init(v: { return ThemeManager.colorForArray(colors as [AnyObject]) })
    }
    
    open class func pickerWithKeyPath(_ keyPath: String) -> ThemeColorPicker {
        return ThemeColorPicker(keyPath: keyPath)
    }
    
    open class func pickerWithColors(_ colors: [String]) -> ThemeColorPicker {
        return ThemeColorPicker(v: { return ThemeManager.colorForArray(colors as [AnyObject]) })
    }
    
}

open class ThemeImagePicker: ThemePicker {
    
    public convenience init(keyPath: String) {
        self.init(v: { return ThemeManager.imageForKeyPath(keyPath) })
    }
    
    public convenience init(names: String...) {
        self.init(v: { return ThemeManager.imageForArray(names as [AnyObject]) })
    }
    
    public convenience init(images: UIImage...) {
        self.init(v: { return ThemeManager.elementForArray(images) })
    }
    
    open class func pickerWithKeyPath(_ keyPath: String) -> ThemeImagePicker {
        return ThemeImagePicker(keyPath: keyPath)
    }
    
    open class func pickerWithNames(_ names: [String]) -> ThemeImagePicker {
        return ThemeImagePicker(v: { return ThemeManager.imageForArray(names as [AnyObject]) })
    }
    
    open class func pickerWithImages(_ images: [UIImage]) -> ThemeImagePicker {
        return ThemeImagePicker(v: { return ThemeManager.elementForArray(images) })
    }
    
}

open class ThemeCGFloatPicker: ThemePicker {
    
    public convenience init(keyPath: String) {
        self.init(v: { return ThemeManager.numberForKeyPath(keyPath) as AnyObject })
    }
    
    public convenience init(floats: CGFloat...) {
        self.init(v: { return ThemeManager.elementForArray(floats as [AnyObject]) })
    }
    
    open class func pickerWithKeyPath(_ keyPath: String) -> ThemeCGFloatPicker {
        return ThemeCGFloatPicker(keyPath: keyPath)
    }
    
    open class func pickerWithFloats(_ floats: [CGFloat]) -> ThemeCGFloatPicker {
        return ThemeCGFloatPicker(v: { return ThemeManager.elementForArray(floats as [AnyObject]) })
    }
    
}

open class ThemeCGColorPicker: ThemePicker {
    
    public convenience init(keyPath: String) {
        self.init(v: { return ThemeManager.colorForKeyPath(keyPath)?.cgColor })
    }
    
    public convenience init(colors: String...) {
        self.init(v: { return ThemeManager.colorForArray(colors as [AnyObject])?.cgColor })
    }
    
    open class func pickerWithKeyPath(_ keyPath: String) -> ThemeCGColorPicker {
        return ThemeCGColorPicker(keyPath: keyPath)
    }
    
    open class func pickerWithColors(_ colors: [String]) -> ThemeCGColorPicker {
        return ThemeCGColorPicker(v: { return ThemeManager.colorForArray(colors as [AnyObject])?.cgColor })
    }
    
}

open class ThemeDictionaryPicker: ThemePicker {
    
    public convenience init(dicts: [String: AnyObject]...) {
        self.init(v: { return ThemeManager.elementForArray(dicts as [AnyObject]) })
    }
    
    open class func pickerWithDicts(_ dicts: [[String: AnyObject]]) -> ThemeDictionaryPicker {
        return ThemeDictionaryPicker(v: { return ThemeManager.elementForArray(dicts as [AnyObject]) })
    }
    
}

open class ThemeStatusBarStylePicker: ThemePicker {
    
    var styles: [UIStatusBarStyle]?
    var animated = true
    
    public convenience init(keyPath: String) {
        self.init(v: { return ThemeManager.stringForKeyPath(keyPath) as AnyObject })
    }
    
    public convenience init(styles: UIStatusBarStyle...) {
        self.init(v: { return 0 as AnyObject })
        self.styles = styles
    }
    
    open class func pickerWithKeyPath(_ keyPath: String) -> ThemeStatusBarStylePicker {
        return ThemeStatusBarStylePicker(keyPath: keyPath)
    }
    
    open class func pickerWithStyles(_ styles: [UIStatusBarStyle]) -> ThemeStatusBarStylePicker {
        let picker = ThemeStatusBarStylePicker(v: { return 0 as AnyObject })
        picker.styles = styles
        return picker
    }
    
    func currentStyle(_ value: AnyObject?) -> UIStatusBarStyle {
        if let styles = styles {
            if styles.indices ~= ThemeManager.currentThemeIndex {
                return styles[ThemeManager.currentThemeIndex]
            }
        }
        if let styleString = value as? String {
            switch styleString {
            case "UIStatusBarStyleDefault"      : return .default
            case "UIStatusBarStyleLightContent" : return .lightContent
            default: break
            }
        }
        return .default
    }
    
}

class ThemeStatePicker: ThemePicker {
    
    typealias ValuesType = [UInt: ThemePicker]
    
    var values = ValuesType()
    
    convenience init(picker: ThemePicker, withState state: UIControl.State) {
        self.init(v: { return 0 as AnyObject })
        _ = self.setPicker(picker, forState: state)
    }
    
    class func pickerWithPicker(_ picker: ThemePicker, andState state: UIControl.State) -> ThemeStatePicker {
        return ThemeStatePicker(picker: picker, withState: state)
    }
    
    func setPicker(_ picker: ThemePicker, forState state: UIControl.State) -> Self {
        values[state.rawValue] = picker
        return self
    }
}

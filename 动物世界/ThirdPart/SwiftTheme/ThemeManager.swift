//
//  ThemeManager.swift
//  SwiftTheme
//
//  Created by Gesen on 16/1/22.
//  Copyright © 2016年 Gesen. All rights reserved.
//

import UIKit

public let ThemeUpdateNotification = "ThemeUpdateNotification"

public enum ThemePath {
    
    case mainBundle
    case sandbox(Foundation.URL)
    
    public var URL: Foundation.URL? {
        switch self {
        case .mainBundle        : return nil
        case .sandbox(let path) : return path
        }
    }
    
    public func plistPathByName(_ name: String) -> String? {
        switch self {
        case .mainBundle:        return Bundle.main.path(forResource: name, ofType: "plist")
        case .sandbox(let path): return Foundation.URL(string: name + ".plist", relativeTo: path)?.path
        }
    }
}

open class ThemeManager: NSObject {
    
    public static var animationDuration = 0.3
    
    public fileprivate(set) static var currentTheme      : NSDictionary?
    public fileprivate(set) static var currentThemePath  : ThemePath?
    public fileprivate(set) static var currentThemeIndex : Int = 0
    
    open class func setTheme(_ index: Int) {
        currentThemeIndex = index
        NotificationCenter.default.post(name: Notification.Name(rawValue: ThemeUpdateNotification), object: nil)
    }
    
    open class func setTheme(_ plistName: String, path: ThemePath) {
        guard let plistPath = path.plistPathByName(plistName)         else {
            print("SwiftTheme WARNING: Not find plist '\(plistName)' with: \(path)")
            return
        }
        guard let plistDict = NSDictionary(contentsOfFile: plistPath) else {
            print("SwiftTheme WARNING: Not read plist '\(plistName)' with: \(plistPath)")
            return
        }
        self.setTheme(plistDict, path: path)
    }
    
    open class func setTheme(_ dict: NSDictionary, path: ThemePath) {
        currentTheme = dict
        currentThemePath = path
        NotificationCenter.default.post(name: Notification.Name(rawValue: ThemeUpdateNotification), object: nil)
    }
    
}

extension ThemeManager {
    
    public class func colorForArray(_ array: [AnyObject]) -> UIColor? {
        guard let rgba = elementForArray(array) else { return nil }
        guard let color = try? UIColor(rgba_throws: rgba as! String) else {
            print("SwiftTheme WARNING: Not convert rgba \(rgba) in array: \(array)[\(currentThemeIndex)]")
            return nil
        }
        return color
    }
    
    public class func imageForArray(_ array: [AnyObject]) -> UIImage? {
        guard let imageName = elementForArray(array) else { return nil }
        guard let image = UIImage(named: imageName as! String) else {
            print("SwiftTheme WARNING: Not found image name '\(imageName)' in array: \(array)[\(currentThemeIndex)]")
            return nil
        }
        return image
    }
    
    public class func elementForArray<T: AnyObject>(_ array: [T]) -> T? {
        let index = ThemeManager.currentThemeIndex
        guard  array.indices ~= index else {
            print("SwiftTheme WARNING: Not found element in array: \(array)[\(currentThemeIndex)]")
            return nil
        }
        return array[index]
    }
    
}

extension ThemeManager {
    
    public class func stringForKeyPath(_ keyPath: String) -> String? {
        guard let string = currentTheme?.value(forKeyPath: keyPath) as? String else {
            print("SwiftTheme WARNING: Not found string key path: \(keyPath)")
            return nil
        }
        return string
    }
    
    public class func numberForKeyPath(_ keyPath: String) -> NSNumber? {
        guard let number = currentTheme?.value(forKeyPath: keyPath) as? NSNumber else {
            print("SwiftTheme WARNING: Not found number key path: \(keyPath)")
            return nil
        }
        return number
    }
    
    public class func dictionaryForKeyPath(_ keyPath: String) -> NSDictionary? {
        guard let dict = currentTheme?.value(forKeyPath: keyPath) as? NSDictionary else {
            print("SwiftTheme WARNING: Not found dictionary key path: \(keyPath)")
            return nil
        }
        return dict
    }
    

    
    public class func colorForKeyPath(_ keyPath: String) -> UIColor? {
        guard let rgba = stringForKeyPath(keyPath) else { return nil }
        guard let color = try? UIColor(rgba_throws: rgba) else {
            print("SwiftTheme WARNING: Not convert rgba \(rgba) at key path: \(keyPath)")
            return nil
        }
        return color
    }
    
    public class func imageForKeyPath(_ keyPath: String) -> UIImage? {
        guard let imageName = stringForKeyPath(keyPath) else { return nil }
        if let filePath = currentThemePath?.URL?.appendingPathComponent(imageName).path {
            guard let image = UIImage(contentsOfFile: filePath) else {
                print("SwiftTheme WARNING: Not found image at file path: \(filePath)")
                return nil
            }
            return image
        } else {
            guard let image = UIImage(named: imageName) else {
                print("SwiftTheme WARNING: Not found image name at main bundle: \(imageName)")
                return nil
            }
            return image
        }
    }
    
    //添加Font
    public class func fontForKeyPath(_ keyPath: String) -> UIFont? {
        guard let fontValue = stringForKeyPath(keyPath) else { return nil }
        let ar = fontValue.components(separatedBy: ",")
        if ar.count > 1 {
            let fontName = ar[0]
            let size = ar[1] as NSString
            guard let font = UIFont(name: fontName, size: CGFloat(size.floatValue)) else {
                print("SwiftTheme WARNING: Not convert font \(fontValue) at key path: \(keyPath)")
                return nil
            }
            return font
        } else {
            return nil
        }
    }
    
}

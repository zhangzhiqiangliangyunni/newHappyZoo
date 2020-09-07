//
//  UIControl+Action.swift
//  动物世界
//
//  Created by zhangzhiqiang on 2020/5/17.
//  Copyright © 2020 zhangzhiqiang. All rights reserved.
//

import Foundation

// MARK: - UIControl 添加 闭包

/// UIControl 的 Target-Action 转换为闭包的‘辅助类’
class ClosureSleeve {
    
    let closure: () -> ()
    
    init(attachTo: AnyObject, closure: @escaping () -> ()) {
        self.closure = closure
        objc_setAssociatedObject(attachTo, "[\(arc4random())]", self, .OBJC_ASSOCIATION_RETAIN)
    }
    
    @objc func invoke() {
        closure()
    }
}


/// 将UIControl 的 Target-Action 转换为闭包
//extension UIControl {
//    func addAction(for controlEvents: UIControl.Event = .primaryActionTriggered, action: @escaping () -> ()) {
//        let sleeve = ClosureSleeve(attachTo: self, closure: action)
//        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
//    }
//}

extension NSRegularExpression {
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}

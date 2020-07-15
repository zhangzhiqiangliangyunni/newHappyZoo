//
//  Tools.swift
//  动物世界
//
//  Created by zhangzhiqiang on 2020/5/16.
//  Copyright © 2020 zhangzhiqiang. All rights reserved.
//
import UIKit

func isIpadPro12() -> Bool {
    if UIScreen.main.bounds.width == 1366.0 || UIScreen.main.bounds.height == 1366.0 {
        return true
    } else {
        return false
    }
}

typealias Task = (_ cancel : Bool) -> ()

@discardableResult
func delay(_ time:TimeInterval, task:@escaping ()->()) ->  Task? {
    func dispatch_later(_ block:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: block)
    }
    var closure: (() -> Void)? = task
    var result: Task?
    let delayedClosure: Task = { cancel in
        if let internalClosure = closure {
            if (cancel == false) {
                DispatchQueue.main.async(execute: internalClosure);
            }
        }
        closure = nil
        result = nil
    }
    result = delayedClosure
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(false)
        }
    }
    return result;
}

func hasElement(_ str: String?, excludeNull: Bool = false) -> Bool {
    if let string = str {
        if excludeNull {
            if !string.isEmpty && string.lowercased() != "null" && string.lowercased() != "(null)" && string.lowercased() != "<null>" {
                return true
            }
        } else {
            if !string.isEmpty {
                return true
            }
        }
    }
    return false
}

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}



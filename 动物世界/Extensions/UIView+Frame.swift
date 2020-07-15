//
//  UIView+Frame.swift
//  动物世界
//
//  Created by zhangzhiqiang on 2020/5/17.
//  Copyright © 2020 zhangzhiqiang. All rights reserved.
//

import Foundation
import RxSwift

extension UIView {
    
    // 快速获得 W 和 H
    var w : CGFloat{
        return self.bounds.width
    }
    var h : CGFloat{
        return self.bounds.height
    }
}

func getCurrentVC() -> UIViewController? {
    var result: UIViewController? = nil
    if let window = UIApplication.shared.windows.last {
        var keyWindow = window
        
        if window.windowLevel != UIWindow.Level.normal {
            let windows = UIApplication.shared.windows
            for tmpWin in windows {
                if tmpWin.windowLevel == UIWindow.Level.normal {
                    keyWindow = tmpWin
                    break
                }
            }
        }

        func getCurrentVC(root: UIViewController?) -> UIViewController? {
            var currentVC: UIViewController? = nil
            var rootVC = root
            
            while rootVC?.presentedViewController != nil {
                rootVC = rootVC?.presentedViewController
            }
            
            if let vc = rootVC as? UITabBarController {
                currentVC = getCurrentVC(root: vc.selectedViewController)
            } else if let vc = rootVC as? UINavigationController {
                currentVC = getCurrentVC(root: vc.visibleViewController)
            } else {
                currentVC = rootVC
            }
            
            return currentVC
        }
        
        result = getCurrentVC(root: keyWindow.rootViewController)
    }
    return result
}


//alertView添加点击背景
let disposeBag = DisposeBag()
extension UIView {

    func setCornersRadius(_ positions :UIRectCorner) {
        let maskpath = UIBezierPath.init(roundedRect:self.bounds, byRoundingCorners: positions, cornerRadii: CGSize(width: 10, height: 0))
        let maskLayer =  CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskpath.cgPath
        self.layer.mask = maskLayer
        self.layer.masksToBounds = true
    }
    
    
    func addMoveInAnimation() {
        layer.removeAllAnimations()
        let transition = CATransition()
        transition.duration = 1.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType(rawValue: "moveIn")
        transition.subtype = CATransitionSubtype.fromBottom
        layer.add(transition, forKey: "moveIn")
    }
    
    //fullScreen: 全屏view， close button，y 往下移
    @objc func addSubViewWithCover(_ view: UIView, blur: Bool, fullScreen: Bool = false, addColseBtn :Bool = true, canDisappare: Bool = true ,closeBeforeHandle :(()->Void)? = nil) {
        
        Sound.play(type: .popup)
        
        self.endEditing(true)
        if blur {
            
            let cover = UIView(frame: bounds)
            cover.tag = 888888
            addSubview(cover)
            
            let darkView = UIView(frame: bounds)
            darkView.backgroundColor = UIColor.black
            darkView.tag = 777777
            darkView.alpha = 0
            cover.addSubview(darkView)
            darkView.alpha = 0.8
            
            let button = UIButton(frame: bounds)
            cover.addSubview(button)
            
            button.rx.tap
                .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
                .subscribe(onNext: { [unowned self] in
                    if let handle = closeBeforeHandle {
                        handle()
                    }else {
                        self.removerCover()
                    }
                }).disposed(by: disposeBag)
            
            button.isUserInteractionEnabled = canDisappare

            isUserInteractionEnabled = false
            let tempCenter = view.center
            view.center = CGPoint(x: tempCenter.x, y: -UIScreen.main.bounds.height)
            cover.addSubview(view)
            
            UIView.animate(withDuration: 0.2, animations: {
                view.center = tempCenter
            }) { _ in
                self.isUserInteractionEnabled = true
            }
            
        } else {
            let cover = UIView(frame: bounds)
            cover.tag = 999999
            addSubview(cover)
            
            let button = UIButton(frame: bounds)
            cover.addSubview(button)
            button.addTarget(self, action: #selector(removerCover), for: .touchUpInside)
            
            let snap = view.snapshotView(afterScreenUpdates: true)
            snap?.center = CGPoint(x: view.center.x, y: view.frame.origin.y)
            snap?.layer.anchorPoint = CGPoint(x: 0.0, y: 0)
            view.isHidden = true
            
            cover.addSubview(view)
            cover.addSubview(snap!)

            isUserInteractionEnabled = false

            UIView.animate(withDuration: 0.2, animations: {
                snap?.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
            }) { _ in
                snap?.removeFromSuperview()
                view.isHidden = false
                self.isUserInteractionEnabled = true
            }
            
        }

        func getCenterPoint(_ padWidth: CGFloat, padHeight: CGFloat) -> CGPoint {
            return CGPoint(x: self.bounds.origin.x + (self.bounds.width - padWidth) / 2, y: self.bounds.origin.y + (self.bounds.height - padHeight) / 2)
        }
        
    }

   @objc func removerCover(_ removeAll :Bool = false) {
        if let cover = viewWithTag(999999) {
            for v in cover.subviews {
                if !(v is UIButton) {
                    let snap = v.snapshotView(afterScreenUpdates: true)
                    snap?.center = CGPoint(x: v.center.x, y: v.frame.origin.y)
                    snap?.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
                    cover.addSubview(snap!)
                    v.isHidden = true
                    isUserInteractionEnabled = false
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        snap?.transform = CGAffineTransform.init(scaleX: 0, y: 0)
                        snap?.alpha = 0
                    }) { _ in
                        v.removeFromSuperview()
                        cover.removeFromSuperview()
                        self.isUserInteractionEnabled = true
                    }
                    
                }
            }
        } else if let cover = viewWithTag(888888){
            for v in cover.subviews {
                if !(v is UIButton) {
                    let snap = v.snapshotView(afterScreenUpdates: true)
                    snap?.center = CGPoint(x: v.center.x, y: v.frame.origin.y)
                    snap?.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
                    cover.addSubview(snap!)
//                    v.isHidden = true
//                    isUserInteractionEnabled = false
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        snap?.transform = CGAffineTransform.init(scaleX: 0, y: 0)
                        snap?.alpha = 0
                    }) { _ in
                        v.removeFromSuperview()
                        cover.removeFromSuperview()
                        self.isUserInteractionEnabled = true
                    }
                    
                }
            }
    }
        
        let covers = subviews.filter { $0.tag == 888888 }
        var cover: UIView?
        if covers.count > 1 {
            cover = covers.last
            
            //删除所有的
            if removeAll {
                for view in covers {
                    if view != cover {
                        view.removeFromSuperview()
                    }
                }
            }
            
        } else {
            cover = covers.first
        }

        EditItemView.hideKeyboard()
    }
}


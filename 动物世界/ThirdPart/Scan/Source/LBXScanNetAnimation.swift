//
//  LBXScanNetAnimation.swift
//  swiftScan
//
//  Created by lbxia on 15/12/9.
//  Copyright © 2015年 xialibing. All rights reserved.
//

import UIKit

class LBXScanNetAnimation: UIImageView {

    var isAnimationing = false
    var animationRect:CGRect = CGRect.zero
    fileprivate lazy var imgView = UIImageView()
    
    
    static public func instance()->LBXScanNetAnimation
    {
        return LBXScanNetAnimation()
    }
    
    func startAnimatingWithRect(animationRect:CGRect, parentView:UIView, image:UIImage?)
    {
        imgView.image = image
        self.frame = animationRect
        imgView.frame = self.bounds
        addSubview(imgView)
        self.clipsToBounds = true
        self.animationRect = animationRect
        parentView.addSubview(self)
        
        self.isHidden = false;
        isAnimationing = true;
        
        if (image != nil)
        {
           stepAnimation()
        }
       
       
        
    }
    
    @objc func stepAnimation()
    {
        if (!isAnimationing) {
            return;
        }
        
        imgView.frame.origin.y = -imgView.h
        self.alpha = 0.0;
        
        UIView.animate(withDuration: 1.2, animations: { () -> Void in
            self.alpha = 1.0;
            self.imgView.frame.origin.y = 0
            }, completion:{ (value: Bool) -> Void in
                
                self.perform(#selector(LBXScanNetAnimation.stepAnimation), with: nil, afterDelay: 0.3)
               
        })
        
    }
    
    func stopStepAnimating()
    {
        self.isHidden = true;
        isAnimationing = false;
    }

}

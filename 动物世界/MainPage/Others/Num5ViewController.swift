//
//  Num5ViewController.swift
//  动物世界
//
//  Created by ni li on 2020/5/20.
//  Copyright © 2020 zhangzhiqiang. All rights reserved.
//

import UIKit

class Num5ViewController: UIViewController {

     @IBOutlet weak var navigaView: UIView!
     @IBOutlet weak var backBtn: UIButton!
     @IBOutlet weak var themeTitle: UILabel!
    
    //四大主要控件
    @IBOutlet weak var toppingActivateView: UIView!
    @IBOutlet weak var leadingActivateView: UIView!
    @IBOutlet weak var trailingActivateView: UIView!
    @IBOutlet weak var bottomingActivateView: UIView!
     
     var closeNum5VCBlock: (() -> Void)?
     func closeNum5(_ block: @escaping () -> Void) {
         closeNum5VCBlock = block
     }
    
     override func viewDidLoad() {
         super.viewDidLoad()
         setupUI()
     }
    
    func setupUI(){
        let tap1 = UITapGestureRecognizer()
        tap1.addTarget(self, action: #selector(tap1Action))
        toppingActivateView.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer()
        tap2.addTarget(self, action: #selector(tap2Action))
        leadingActivateView.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer()
        tap3.addTarget(self, action: #selector(tap3Action))
        bottomingActivateView.addGestureRecognizer(tap3)
        
        let tap4 = UITapGestureRecognizer()
        tap4.addTarget(self, action: #selector(tap4Action))
        trailingActivateView.addGestureRecognizer(tap4)
    }
    
    @objc func tap1Action(){
        toppingActivateView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        Sound.play(type: .click)
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.toppingActivateView.transform = CGAffineTransform.identity
        },
                       completion: { Void in()
                        
                        let vc = OthersViewController(nibName: nil, bundle: nil)
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                        
        }
        )
        
    }
    
    @objc func tap2Action(){
        leadingActivateView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        Sound.play(type: .click)
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.leadingActivateView.transform = CGAffineTransform.identity
        },
                       completion: { Void in()
                        
                        let vc = OthersViewController(nibName: nil, bundle: nil)
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                        
        }
        )
        
    }
    
    @objc func tap3Action(){
        bottomingActivateView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        Sound.play(type: .click)
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.bottomingActivateView.transform = CGAffineTransform.identity
        },
                       completion: { Void in()
                        
                        let vc = OthersViewController(nibName: nil, bundle: nil)
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
        }
        )
        
    }
    
    @objc func tap4Action(){
        trailingActivateView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        Sound.play(type: .click)
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.trailingActivateView.transform = CGAffineTransform.identity
        },
                       completion: { Void in()
                        
                        let vc = OthersViewController(nibName: nil, bundle: nil)
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                        
        }
        )
        
    }
     
     @IBAction func backAction(_ sender: Any) {
     
         UIView.animate(withDuration: 0.5, animations: {
             self.closeNum5VCBlock?()
         }, completion: { _ in
             self.view.removeFromSuperview()
            (UIApplication.shared.delegate as? AppDelegate)?.num5VC = nil
         })
     }
}

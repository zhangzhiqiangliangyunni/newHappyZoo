//
//  ReadAnimalsNameView.swift
//  动物世界
//
//  Created by zhangzhiqiang on 2020/7/9.
//  Copyright © 2020 zhangzhiqiang. All rights reserved.
//

import UIKit

class ReadAnimalsNameView: UIView {

    //var isPlay = true  //是否正在播放
    var icon: UIImageView!
    var titleLabel: UILabel!
    var lang:Int = 0
    
    //get url from cloud
    typealias getUrlBlock = (String)->()
    var getBlock: getUrlBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configView()
    }
    
    func configView() {
        
        self.backgroundColor = UIColor(rgba: "#284F60")
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 30
        self.alpha = 0.8
        
        icon = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height * 2/3))
        icon.image = UIImage(named: "yinpinbofang2")
        icon.contentMode = .center
        icon.isExclusiveTouch = true
        addSubview(icon)
        
        titleLabel = UILabel(frame: CGRect(x: 10, y: self.frame.height * 2/3, width: self.frame.width - 20, height: self.frame.height/3 - 10))
        titleLabel.text = "朗读"
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = UIFont.boldSystemFont(ofSize: 13)
        
        addSubview(titleLabel)
        
        //pan
        let pan = UIPanGestureRecognizer(target: self, action: #selector(ReviewSubmitView.handlePan(_:)))
        self.addGestureRecognizer(pan)
    }
    
    
    @objc func handlePan(_ pan: UIPanGestureRecognizer) {
        let trans = pan.location(in: self.superview)
        pan.view?.center = trans
        pan.setTranslation(CGPoint.zero, in: self.superview)
    }
    
    //MARK: 调接口，取得url
    func getVideoURL() {
        //        let gloableIdentifier = (getCurrentVC() is CashierIn) ? mySingleton.sharedInstance.currentVC : identifier
        //        if
        //            let title =  gloableIdentifier == nil ? mySingleton.sharedInstance.currentVC : gloableIdentifier ,
        //            let url = Utility.getShowVideoTutorialURL(with : title == "015_cashCount" ? "005_cashier" : title),
        //            let appDelegate = UIApplication.shared.delegate as? AppDelegate, appDelegate.helpVideoViewController == nil {
        //            let video = Video(URL: url, title: title, index: 0)
        //            let vc = HelpVideoVC(nibName: nil, bundle: nil)
        //            vc.showSideView = 0
        //            vc.videoTitle = video.title
        //            vc.url = video.URL
        //
        //            //self只能在VC-deinit之后才能再次点击
        //            vc.removeBlock = { [weak self] in
        //                self?.icon.isUserInteractionEnabled = true
        //            }
        //
        //            let window = UIApplication.shared.windows[0]
        //            vc.view.frame = UIScreen.main.bounds
        //            vc.view.mj_y = UIScreen.main.bounds.size.height
        //            appDelegate.helpVideoViewController = vc
        //            window?.addSubview(vc.view)
        //            UIView.animate(withDuration: 0.3) {
        //                vc.view.mj_y = 0
        //            }
        //        }
        //        else {
        //            self.icon.isUserInteractionEnabled = true
        //        }
    }
    
}

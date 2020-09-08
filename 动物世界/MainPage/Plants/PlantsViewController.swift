//
//  PlantsViewController.swift
//  动物世界
//
//  Created by ni li on 2020/5/25.
//  Copyright © 2020 zhangzhiqiang. All rights reserved.
//

import UIKit
import SnapKit

class PlantsViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    var index: Int = 0
    var j: Int = 0
    var tempValue: Int = 0
    var pageView: UIView!
    var imageView: UIImageView!
    var bgView: UIView!
    var swipeLeft: UISwipeGestureRecognizer?
    var swipeRight: UISwipeGestureRecognizer?
    var readView: ReadAnimalsNameView!
    
    //type:(1,2,3,4) 国，工，外，公
    var type : Int = 0
    var images:[String] {
        if type == 1{
            return ["奇瑞QQ","瑞虎3X","奇瑞E3","艾瑞泽5","奇瑞A3","奇瑞小蚂蚁","瑞虎5X","星途","瑞虎7","瑞虎8","凯翼X5","捷途X80","飞13","飞14","飞15","飞16","飞17","飞18","飞19","飞20","飞21","飞22","飞23","飞24","飞25"]
        }else if type == 2{
            return ["地1","地2","地3","地4","地5","地6","地7","地8","地9","地10","地11","地12","地13","地14","地15","地16","地17","地18","地19","地20","地21","地22","地23","地24","地25","地26","地27","地28","地29","地30","地31","地32","地33","地34","地35","地36","地37","地38"]
        }else if type == 3{
            return ["土1","土2","土3","土4","土5","土5",]
        }else if type == 4{
            return ["水1","水2","水3","水4","水5","水6","水7","水8","水9","水10","水11","水12","水13","水14","水15","水16","水17","水18","水19","水20","水21","水22","水23","水24","水25","水26","水27","水28","水29","水30","水31","水32","水33","水34"]
        }
        return []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view)
        }
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        setupUI()
    }
    
    func setupUI() {
        pageView = UIView(frame:(CGRect(x:0,y:0,width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height)))
        scrollView.addSubview(pageView)
        
        imageView = UIImageView()
        imageView.image = UIImage(named:images[0])
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        pageView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        imageView.contentMode = .scaleAspectFill
        
        //设置按钮的样式
        let btn11 = UIButton()
        btn11.setTitle("下一张", for: UIControl.State.normal)
        btn11.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn11.setImage(UIImage(named: "OrderEntryNewReloadGiftNextW"), for: .normal)
        btn11.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        btn11.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        btn11.backgroundColor = UIColor.clear
        btn11.layer.cornerRadius = 10
        
        btn11.layer.borderColor = UIColor.white.cgColor
        btn11.layer.borderWidth = 2
        
        bgView = UIView()
        imageView.addSubview(bgView)
        bgView.addSubview(btn11)
        
        bgView.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.bounds.width*7/16/2 - 15)
            make.centerX.equalTo(self.view.snp.centerX)
            make.bottom.equalTo(-30)
            make.height.equalTo(50)
        }
        
        btn11.snp.makeConstraints { (make) in
            make.trailing.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.leading.equalTo(0)
        }
        
        btn11.addTarget(self, action: #selector(clickNext), for: .touchUpInside)
        
        //添加朗读按钮
        readView = ReadAnimalsNameView(frame: CGRect(x: 40, y: 50, width: 60, height: 60))
        imageView.addSubview(readView)
        
        //创建一个左右滑动的手势
        swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(clickNext))
        swipeLeft?.direction = UISwipeGestureRecognizer.Direction.left
        self.pageView.addGestureRecognizer(swipeLeft!)
        
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(clickGoBack))
        swipeRight?.direction = UISwipeGestureRecognizer.Direction.right
        self.pageView.addGestureRecognizer(swipeRight!)
        
        scrollView.isPagingEnabled = true
        
        childThreadCreatOtherSubViews()
    }
    
    @objc func clickExit(){
        Sound.play(type: .swipe)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func clickGoBack(){
        Sound.play(type: .recapShrink)
        let frame = scrollView.frame
        
        if j != 0{
            j -= 1
            scrollView.setContentOffset(CGPoint(x: frame.size.width * CGFloat(j), y: 0), animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }

    @objc func clickNext(){
        Sound.play(type: .recapShrink)
        let frame = scrollView.frame
        j += 1

        if self.images.count < j + 1 {
            j = self.images.count - 1
            scrollView.setContentOffset(CGPoint(x: frame.size.width * CGFloat(j), y: 0), animated: true)
        }else{
            scrollView.setContentOffset(CGPoint(x: frame.size.width * CGFloat(j), y: 0), animated: true)
        }
        
    }
    
    //除去UI初始化的第1张图片外，将剩余的25张图片放在子线程进行初始化，将一定程度上提高点击后的性能提升
    func childThreadCreatOtherSubViews(){
        self.scrollView.isPagingEnabled = true

        DispatchQueue.global().async {
            for v in 1..<self.images.count {
                DispatchQueue.main.async {
                    
                    self.index += 1
                    self.pageView = UIView(frame:(CGRect(x:UIScreen.main.bounds.width * CGFloat(v),y:0,width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height)))
                    self.imageView = UIImageView()
                    self.imageView.image = UIImage(named: "\(self.images[v])")
                    self.imageView.clipsToBounds = true
                    self.imageView.isUserInteractionEnabled = true
                    self.imageView.frame = CGRect(x:UIScreen.main.bounds.width * CGFloat(v),y:0,width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height)
                    self.pageView.addSubview(self.imageView)
                    self.imageView.snp.makeConstraints { (make) in
                        make.edges.equalTo(UIEdgeInsets.zero)
                    }
               
                    self.imageView.contentMode = .scaleAspectFill
                    
                    //添加手势
                    self.swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.clickNext))
                    self.swipeLeft?.direction = UISwipeGestureRecognizer.Direction.left
                    self.pageView.addGestureRecognizer(self.swipeLeft!)
                    
                    self.swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.clickGoBack))
                    self.swipeRight?.direction = UISwipeGestureRecognizer.Direction.right
                    self.pageView.addGestureRecognizer(self.swipeRight!)
                    //添加手势
                    
                    //设置按钮的样式
                    let btn1 = UIButton()
                    btn1.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
                    
                    if self.index == self.images.count - 1{
                        btn1.setImage(UIImage(named: "InventorySaveYes"), for: .normal)
                        btn1.setTitle("最后一张", for: UIControl.State.normal)
                    }else{
                        btn1.setImage(UIImage(named: "HintOverlaysExitHints"), for: .normal)
                        btn1.setTitle("退出", for: UIControl.State.normal)
                    }
                    
                    btn1.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
                    btn1.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
                    let btn11 = UIButton()
                    btn11.setTitle("下一张", for: UIControl.State.normal)
                    btn11.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
                    btn11.setImage(UIImage(named: "OrderEntryNewReloadGiftNextW"), for: .normal)
                    btn11.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
                    btn11.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
                    btn1.backgroundColor = UIColor.clear
                    btn11.backgroundColor = UIColor.clear
                    btn1.layer.cornerRadius = 10
                    btn11.layer.cornerRadius = 10
                    
                    btn1.layer.borderColor = UIColor.white.cgColor
                    btn1.layer.borderWidth = 2
                    btn11.layer.borderColor = UIColor.white.cgColor
                    btn11.layer.borderWidth = 2
                    
                    self.bgView = UIView()
                    self.imageView.addSubview(self.bgView)
                    self.bgView.addSubview(btn1)
                    self.bgView.addSubview(btn11)
                    
                    //添加朗读按钮
                    self.readView = ReadAnimalsNameView(frame: CGRect(x: 40, y: 50, width: 60, height: 60))
                    self.imageView.addSubview(self.readView)
                    
                    if self.index == self.images.count - 1 {//bgView是就一个Btn(Got it)为一组的
                        
                        self.bgView.snp.makeConstraints { (make) in
                            make.width.equalTo(self.view.bounds.width*7/16/2 - 15)
                            make.centerX.equalTo(self.view.bounds.width/2)
                            make.bottom.equalTo(-30)
                            make.height.equalTo(50)
                        }
                        
                        btn1.snp.makeConstraints { (make) in
                            make.edges.equalTo(UIEdgeInsets.zero)
                        }
                        
                        btn11.frame = .zero
                        
                    }else{//bgView是两个Btn平行一组的
                        
                        self.bgView.snp.makeConstraints { (make) in
                            make.bottom.equalTo(-30)
                            make.width.equalTo(self.view.bounds.width*7/16)
                            if isIpadPro12() {
                                make.height.equalTo(60)
                            }else{
                                make.height.equalTo(50)
                            }
                            make.centerX.equalTo(self.view.center.x)
                        }
                        
                        btn1.snp.makeConstraints { (make) in
                            make.leading.equalTo(0)
                            make.top.equalTo(0)
                            make.bottom.equalTo(0)
                            make.trailing.equalTo(self.bgView.snp.centerX).offset(-15)
                        }
                        
                        btn11.snp.makeConstraints { (make) in
                            make.trailing.equalTo(0)
                            make.top.equalTo(0)
                            make.bottom.equalTo(0)
                            make.leading.equalTo(self.bgView.snp.centerX).offset(15)
                        }
                    }
                    
                    if self.index == self.images.count - 1{
                        btn1.isUserInteractionEnabled = false
                        let tap = UITapGestureRecognizer()
                        self.pageView.addGestureRecognizer(tap)
                        tap.addTarget(self, action: #selector(self.clickExit))
                    }else{
                        btn1.addTarget(self, action: #selector(self.clickExit), for: .touchUpInside)
                        btn11.addTarget(self, action: #selector(self.clickNext), for: .touchUpInside)
                    }
                    
                    self.scrollView.addSubview(self.pageView)
                }
            }
        }
    }


}

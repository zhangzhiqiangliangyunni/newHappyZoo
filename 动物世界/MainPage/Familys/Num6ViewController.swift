//
//  Num6ViewController.swift
//  动物世界
//
//  Created by ni li on 2020/5/20.
//  Copyright © 2020 zhangzhiqiang. All rights reserved.
//

import UIKit
import CoreServices
import AVFoundation
import Palau
import LeanCloud

struct ImageSource {
    var img: UIImage
    var title: String
    
    init(img: UIImage, title: String) {
        self.img = img
        self.title = title
    }
}

class Num6ViewController: UIViewController {
    
    @IBOutlet weak var navigaView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var themeTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var isShaking: Bool = false
    
    var collectionOldY: CGFloat = 0
    
    var closeNum6VCBlock: (() -> Void)?
    func closeNum6(_ block: @escaping () -> Void) {
        closeNum6VCBlock = block
    }
    
    var familyImgsSource = mySingleton.shareInstance.dataSourceImgsSingleton {
        didSet{
            collectionView.reloadData()
        }
    }
    
    lazy var alertView : AlertSelectView =  {
        $0.frame = CGRect.zero
        $0.tag = 999
        return $0
    }(Bundle.main.loadNibNamed("AlertSelectView", owner: nil, options: nil)?.first as! AlertSelectView)
    
    lazy var imagePickerController : UIImagePickerController = {
        $0.sourceType = .camera
        $0.mediaTypes = [kUTTypeImage] as [String]
        $0.delegate = self
        $0.modalPresentationStyle = .fullScreen
        return $0
    }(UIImagePickerController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = FamilyFlowLayout()
        collectionView.collectionViewLayout = layout
        collectionView.isPagingEnabled = true
        collectionView.register(UINib(nibName: "FamilyCollectionViewCell" ,bundle: nil), forCellWithReuseIdentifier: "FamilyCollectionViewCell")
        collectionView.register(UINib(nibName: "addNewItemCell" ,bundle: nil), forCellWithReuseIdentifier: "addNewItemCell")
        collectionOldY = self.collectionView.frame.origin.y
        
        familyImgsSource = mySingleton.shareInstance.dataSourceImgsSingleton
        
        //查询数据库
        
//        DispatchQueue.global().async {
//            let allImagesStr = DBQueue.inDatabase { db in
//                try! Data.fetchAll(db, sql: "SELECT Images FROM axFamilyImages")
//            }
//            print(allImagesStr)
//        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        EditItemView.hideKeyboard()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.closeNum6VCBlock?()
        }, completion: { _ in
            self.view.removeFromSuperview()
        })
    }
    
    //拍照
    func takePictureAction() {
        LBXPermissions.authorizeCameraWith { [weak self] (success) in
            guard let `self` = self else { return }
            if !success {
               print("拍照不成功--------拍照不成功")
            }
            else {
                self.imagePickerController.sourceType = .camera
                self.imagePickerController.delegate = self
                self.imagePickerController.mediaTypes = [kUTTypeImage] as [String]
                self.imagePickerController.modalPresentationStyle = .fullScreen
                self.imagePickerController.sourceType = .camera
                
                if UIImagePickerController.isCameraDeviceAvailable(.front) {
                    self.imagePickerController.cameraDevice = .rear
                }
                
                UIApplication.shared.windows[0].addSubview(self.imagePickerController.view)
                self.imagePickerController.view.frame.origin = .init(x: 0, y: UIScreen.main.bounds.height)
                self.imagePickerController.viewWillAppear(true)
                self.imagePickerController.viewDidAppear(true)
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.imagePickerController.view.frame.origin = .zero
                })
            }
        }
    }
    
    
    //相册选取
    func selectPictureAction() {
        
        LBXPermissions.authorizePhotoWith { [weak self] (granted) in
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.mediaTypes = [kUTTypeImage] as [String]
            imagePickerController.modalPresentationStyle = .fullScreen
            imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
            
            UIApplication.shared.windows[0].addSubview(imagePickerController.view)
            imagePickerController.view.frame.origin = .init(x: 0, y: UIScreen.main.bounds.height)
            imagePickerController.viewWillAppear(true)
            imagePickerController.viewDidAppear(true)
            
            UIView.animate(withDuration: 0.3, animations: {
                imagePickerController.view.frame.origin = .zero
            })
        }
    }
    
}

extension Num6ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  familyImgsSource.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if familyImgsSource.count != indexPath.row { //+ (indexPath.row / 6) * 6 二者cell都存在
            
            let familyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FamilyCollectionViewCell", for: indexPath) as! FamilyCollectionViewCell
            familyCell.clearBtn.isHidden = true
            familyCell.cellIndex = indexPath.row
            familyCell.setupContent(displayImage: familyImgsSource[indexPath.item].img, familyText: familyImgsSource[indexPath.item].title)
            
            familyCell.getInputText { [weak self] (str, inx)  in
                guard let `self` = self else {return}
                
                if inx == indexPath.row{
                    self.familyImgsSource[indexPath.row].title = str ?? ""
                }
                collectionView.reloadData()
                mySingleton.shareInstance.dataSourceImgsSingleton = self.familyImgsSource
            }
            
            //familyCell中的EditItemView开始编辑的时候
            familyCell.editTextField {
                //collectionView上半段的cell
                if indexPath.item % (3*2) / 3 == 0 {
                    UIView.animate(withDuration: TimeInterval(0.3), delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                        self.collectionView.frame.origin.y = self.collectionView.frame.origin.y - 20
                    })
                } else { //collectionView下半段的cell
                    UIView.animate(withDuration: TimeInterval(0.3), delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                        self.collectionView.frame.origin.y = self.collectionView.frame.origin.y - 40 - familyCell.contentView.frame.height
                    })
                }
            }
            
            //familyCell中的EditItemView编辑完成的时候
            familyCell.endEditTextField {
                UIView.animate(withDuration: TimeInterval(0.3), delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                    self.collectionView.frame.origin.y = self.collectionOldY
                })
            }
            
            familyCell.longPress = { [weak self] (inx) in
                Sound.play(type: .wiggle)
                
                familyCell.clearBtn.isHidden = false
                self?.view.bringSubviewToFront(familyCell.clearBtn)
                
                if let anim = self?.getShakeAnimation() {
                    if (familyCell.layer.animation(forKey: "shake") == nil) {
                        familyCell.layer.add(anim, forKey: "shake")
                    }
                }
                self?.isShaking = true
            }
            
            familyCell.delete = {  [weak self] (inx) in
                if let inx = inx {
                    self?.familyImgsSource.remove(at:inx)
                    collectionView.deleteItems(at: [IndexPath(row: inx, section: 0)])
                    mySingleton.shareInstance.dataSourceImgsSingleton = self?.familyImgsSource ?? []
                }
            }
            
            //点击familyCell上的图片产生的action
            familyCell.clickDisplayImg { [weak self] inx in
                
                if self?.isShaking == true {
                    self?.stopShakeCell()
                }else{
                    
                    let syntesizer = AVSpeechSynthesizer()
                    var utterance = AVSpeechUtterance()
                    
                    let playString = "张志强"
                    utterance = AVSpeechUtterance(string: playString)
                    utterance.rate = 0.1
                    syntesizer.speak(utterance)
                }
                
            }
            
            return familyCell
            
        } else { //只存在添加cell
            
            let addNewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "addNewItemCell", for: IndexPath(row: indexPath.row + (indexPath.row / 6) * 6 , section: 0)) as! addNewItemCell
            
            addNewCell.clickBgView { [weak self] in
                
                guard let `self` = self else { return }
                
                let centerX1 = self.view.center.x - 125
                let centerY1 = self.view.center.y - 100
                //为营造动画效果，初始化y值为alertView的高度取负值
                self.alertView.frame = CGRect(x: self.view.bounds.width/2 - 125, y: -200, width: 250, height: 200)
                
                if self.view.viewWithTag(999) != nil
                {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.alertView.frame = CGRect(x: centerX1, y: centerY1, width: 0, height:0)
                    }, completion: { (_) in
                        self.alertView.removeFromSuperview()
                    })
                }
                else
                {
            
                    UIView.animate(withDuration: 0.5, animations: {
                        self.alertView.frame = CGRect(x: centerX1, y: centerY1, width: 250, height: 200)
                        self.view.addSubViewWithCover(self.alertView, blur: true)
                    })
                    
                    //拍照获取
                    self.alertView.takePicture { [weak self] in
                        self?.alertView.superview?.removeFromSuperview()
                        self?.takePictureAction()
                    }
                    
                    //相册获取
                    self.alertView.selectPicture { [weak self] in
                        self?.alertView.superview?.removeFromSuperview()
                        self?.selectPictureAction()
                    }
                }
            }
            
            return addNewCell
        }
        
    }
    
    @objc func stopShakeCell() {
        let cells = collectionView.visibleCells
        for cell in cells {
            cell.layer.removeAllAnimations()
            let cell = cell as? FamilyCollectionViewCell
            cell?.clearBtn.isHidden = true
        }
        isShaking = false
        collectionView.reloadData()
    }
    
    
    func getShakeAnimation() -> CAKeyframeAnimation {
        let shakeLevel :CGFloat = 3.0
        let anim: CAKeyframeAnimation = CAKeyframeAnimation()
        anim.keyPath = "transform.rotation"
        anim.values = [angelToRandian(-shakeLevel),angelToRandian(shakeLevel),angelToRandian(-shakeLevel)]
        anim.repeatCount = MAXFLOAT
        anim.duration = 0.3
        anim.isRemovedOnCompletion = false
        anim.fillMode = CAMediaTimingFillMode.forwards
        
        let rand: Double = Double(arc4random())
        let time: CFTimeInterval = rand*0.0000000001
        anim.beginTime = time
        return anim
    }
    
    func angelToRandian(_ x: CGFloat) -> CGFloat { return  ((x)/180.0*CGFloat.pi) }
    
}

extension Num6ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImage:UIImage? = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if (selectedImage == nil ) {
            selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }
        
        if selectedImage != nil {
            let sources = ImageSource.init(img: selectedImage!, title: "")
            familyImgsSource.append(sources)
            mySingleton.shareInstance.dataSourceImgsSingleton = familyImgsSource
            
//            //将选择的图片保存到Document目录下
//            let fileManager = FileManager.default
//            let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
//            let filePath = "\(rootPath)/pickedImage.jpg"
//            let imageData = NSUIImageJPEGRepresentation(sources.img, 1.0)
//            fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
//
//            //上传图片的路径到数据库中
//            if fileManager.fileExists(atPath: filePath) {
////                let imageUrl = NSURL(fileURLWithPath: filePath)
////                Utility.saveFamilyImagesUrl(imagePath: filePath)
//            }
//
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            picker.view.frame.origin.y = UIScreen.main.bounds.height
        } ,completion: { _ in
            picker.view.removeFromSuperview()
        })
    }
    
    //这时HelpVC是添加到window上的，通过动画模拟出来的present效果，currentVC并不是HelpVC,而是helpVC前面的控制器present出来的picker，这时候picker会在self的下面,索性将imagePickerController也加到window上面
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        UIView.animate(withDuration: 0.3, animations: {
            picker.view.frame.origin.y = UIScreen.main.bounds.height
        } ,completion: { _ in
            picker.view.removeFromSuperview()
        })
    }
}



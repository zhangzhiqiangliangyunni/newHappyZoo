//
//  LBXScanViewController.swift
//  swiftScan
//
//  Created by lbxia on 15/12/8.
//  Copyright © 2015年 xialibing. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

public protocol LBXScanViewControllerDelegate {
     func scanFinished(scanResult: LBXScanResult, error: String?)
}


class LBXScanViewController: UINavigationController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
 //返回扫码结果，也可以通过继承本控制器，改写该handleCodeResult方法即可
   open var scanResultDelegate: LBXScanViewControllerDelegate?
    
   open var scanObj: LBXScanWrapper?
    
   open var scanStyle: LBXScanViewStyle? = LBXScanViewStyle()
    
   open var qRScanView: LBXScanView?

    //是否有navigation bar
    open var hasNavBar = true
    
    //启动区域识别功能
   open var isOpenInterestRect = false
    
    //识别码的类型
   public var arrayCodeType:[AVMetadataObject.ObjectType]?
    
    //是否需要识别后的当前图像
   public  var isNeedCodeImage = false
    
    //相机启动提示文字
    public var readyString:String! = "loading"

    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
              // [self.view addSubview:_qRScanView];
//        titleBar.title.text = "Scan".toLocalize()
        self.view.backgroundColor = UIColor.black
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
    }
    
    open func setNeedCodeImage(needCodeImg:Bool)
    {
        isNeedCodeImage = needCodeImg;
    }
    //设置框内识别
    open func setOpenInterestRect(isOpen:Bool){
        isOpenInterestRect = isOpen
    }
 
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        drawScanView()
        //drawFalshView()
        perform(#selector(LBXScanViewController.startScan), with: nil, afterDelay: 0.3)
        
    }
    
    var position: AVCaptureDevice.Position = AVCaptureDevice.Position.front
    
    @objc open func startScan()
    {
   
        if (scanObj == nil)
        {
            var cropRect = CGRect.zero
            if isOpenInterestRect
            {
                cropRect = LBXScanView.getScanRectWithPreView(preView: self.view, style:scanStyle! )
            }
            
            //指定识别几种码
            if arrayCodeType == nil
            {
                arrayCodeType = LBXScanWrapper.defaultMetaDataObjectTypes()//[AVMetadataObject.ObjectType.qr,AVMetadataObject.ObjectType.ean13,AVMetadataObject.ObjectType.code128]
            }
            
            scanObj = LBXScanWrapper(videoPreView: self.view,objType:arrayCodeType!, isCaptureImg: isNeedCodeImage,cropRect:cropRect,devicePostion: position, success: { [weak self] (arrayResult) -> Void in
                
                if let strongSelf = self
                {
                    //停止扫描动画
                    strongSelf.qRScanView?.stopScanAnimation()
                    
                    strongSelf.handleCodeResult(arrayResult: arrayResult)
                }
             })
        }
        
        //结束相机等待提示
        qRScanView?.deviceStopReadying()
        
        //开始扫描动画
        qRScanView?.startScanAnimation()
        
        //相机运行
        scanObj?.start()
    }
    
    open func drawScanView()
    {
        if qRScanView == nil
        {
            qRScanView = LBXScanView(frame: self.view.frame,vstyle:scanStyle! )
            if hasNavBar {
                qRScanView?.frame.origin.y = 68
                qRScanView?.frame.size.height = self.view.frame.height - 68
            }
            self.view.addSubview(qRScanView!)
        }
        qRScanView?.deviceStartReadying(readyStr: readyString)
        
    }
    
    func drawFalshView() {
        let btnFlash = UIButton()
        btnFlash.frame = CGRect.init(x: (self.view.w - 65 - 100), y: (87 + 68 + 20), width: 65, height: 87)
        btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_nor"), for:UIControl.State.normal)
        btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_down"), for:UIControl.State.selected)
        btnFlash.addTarget(self, action: #selector(openOrCloseFlash), for: UIControl.Event.touchUpInside)
        self.view.addSubview(btnFlash)
    }
    
    @objc func openOrCloseFlash(_ btn:UIButton) {
            scanObj?.changeTorch();
            btn.isSelected = !btn.isSelected
    }
    
    /**
     扫描完成后的处理操作。
     */
    fileprivate var scanFinishedBlock :((LBXScanResult)->Void)?
    func scanFinished(_ block :((LBXScanResult)->Void)?) {
        scanFinishedBlock = block
    }
    
    /**
     处理扫码结果，如果是继承本控制器的，可以重写该方法,作出相应地处理，，或者设置finishedBlock作出相应处理,或者设置delegate作出相应处理
     */
    open func handleCodeResult(arrayResult:[LBXScanResult])
    {
        let result:LBXScanResult = arrayResult[0]
        
        if let finishedBlock = scanFinishedBlock {
            self.navigationController?.popViewController(animated: true)
            qRScanView?.stopScanAnimation()
            scanObj?.stop()
            finishedBlock(result)
    
        }else if let delegate = scanResultDelegate  {
            
            self.navigationController? .popViewController(animated: true)
            delegate.scanFinished(scanResult: result, error: nil)
            
        }else{
            
            for result:LBXScanResult in arrayResult
            {
                print("%@",result.strScanned ?? "")
            }
            
            showMsg(title: result.strBarCodeType, message: result.strScanned)
        }
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        qRScanView?.stopScanAnimation()
        
        scanObj?.stop()
    }
    
    open func openPhotoAlbum()
    {
        LBXPermissions.authorizePhotoWith { [weak self] (granted) in
            let picker = UIImagePickerController()
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            picker.delegate = self;
            picker.allowsEditing = true
            picker.modalPresentationStyle = .fullScreen
            self?.present(picker, animated: true, completion: nil)
        }
    }
    
    //MARK: -----相册选择图片识别二维码 （条形码没有找到系统方法）
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        picker.dismiss(animated: true, completion: nil)
        
        var image:UIImage? = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        
        if (image == nil )
        {
            image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }
        
        if(image != nil)
        {
            let arrayResult = LBXScanWrapper.recognizeQRImage(image: image!)
            if arrayResult.count > 0
            {
                handleCodeResult(arrayResult: arrayResult)
                return
            }
        }
      
        showMsg(title: nil, message: NSLocalizedString("Identify failed", comment: "Identify failed"))
    }
    
    func showMsg(title:String?,message:String?)
    {
        
        let alertController = UIAlertController(title: nil, message:message, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: UIAlertAction.Style.default) { (alertAction) in
                
//                if let strongSelf = self
//                {
//                    strongSelf.startScan()
//                }
            }
            
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
    }
}






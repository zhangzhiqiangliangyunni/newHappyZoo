//
//  AppDelegate.swift
//  动物世界
//
//  Created by zhangzhiqiang on 2020/5/16.
//  Copyright © 2020 zhangzhiqiang. All rights reserved.
//

import UIKit
import LeanCloud

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        LCApplication.logLevel = .all
//        LCApplication.logLevel = .off

        let appid = "EhExw9o5c738b9YbCJAuGnWV-gzGzoHsz"
        let appkey = "Wt1hQFioXjIklEKIExIif1pO"

        do {
            try LCApplication.default.set(
                id: appid,
                key: appkey,
                serverURL: "https://ehexw9o5.lc-cn-n1-shared.com")
        } catch {
            print(error)
        }
        
        DatabaseOption().setupLiveDatabase()
         
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


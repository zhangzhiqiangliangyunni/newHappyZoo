//
//  Sound.swift
//  动物世界
//
//  Created by zhangzhiqiang on 2020/5/16.
//  Copyright © 2020 zhangzhiqiang. All rights reserved.
//

import UIKit
import Chirp

enum SoundType: String {
    case click = "click"
    case void = "void"
    case dropDown = "dropDownList"
    case showBanner = "bannerFloatingIcons.mp3"
    case swipe = "swipe"
    case wiggle = "wiggle.mp3"
    case changeDeviceDirection = "portraitLandscapeModes.mp3"
    case recapShrink = "orderInfoRecapShrink.mp3"
    case popup = "popup"
    case error = "error.mp3"
    case settled = "paymentSettled.mp3"
    case pay = "IntegratedPayment_samsung_sms.mp3"
}

class Sound {
    static func preparedAllSounds() {
        _ = Chirp.sharedManager.prepareSound(fileName: SoundType.click.rawValue)
        _ = Chirp.sharedManager.prepareSound(fileName: SoundType.void.rawValue)
        _ = Chirp.sharedManager.prepareSound(fileName: SoundType.dropDown.rawValue)
        _ = Chirp.sharedManager.prepareSound(fileName: SoundType.showBanner.rawValue)
        _ = Chirp.sharedManager.prepareSound(fileName: SoundType.swipe.rawValue)
        _ = Chirp.sharedManager.prepareSound(fileName: SoundType.wiggle.rawValue)
        _ = Chirp.sharedManager.prepareSound(fileName: SoundType.changeDeviceDirection.rawValue)
        _ = Chirp.sharedManager.prepareSound(fileName: SoundType.recapShrink.rawValue)
        _ = Chirp.sharedManager.prepareSound(fileName: SoundType.popup.rawValue)
        _ = Chirp.sharedManager.prepareSound(fileName: SoundType.error.rawValue)
        _ = Chirp.sharedManager.prepareSound(fileName: SoundType.settled.rawValue)
        _ = Chirp.sharedManager.prepareSound(fileName: SoundType.pay.rawValue)
    }
    
    static func removeAllSounds() {
        Chirp.sharedManager.removeSound(fileName: SoundType.click.rawValue)
        Chirp.sharedManager.removeSound(fileName: SoundType.void.rawValue)
        Chirp.sharedManager.removeSound(fileName: SoundType.dropDown.rawValue)
        Chirp.sharedManager.removeSound(fileName: SoundType.showBanner.rawValue)
        Chirp.sharedManager.removeSound(fileName: SoundType.swipe.rawValue)
        Chirp.sharedManager.removeSound(fileName: SoundType.wiggle.rawValue)
        Chirp.sharedManager.removeSound(fileName: SoundType.changeDeviceDirection.rawValue)
        Chirp.sharedManager.removeSound(fileName: SoundType.recapShrink.rawValue)
        Chirp.sharedManager.removeSound(fileName: SoundType.popup.rawValue)
        Chirp.sharedManager.removeSound(fileName: SoundType.error.rawValue)
        Chirp.sharedManager.removeSound(fileName: SoundType.settled.rawValue)
        Chirp.sharedManager.removeSound(fileName: SoundType.pay.rawValue)
    }
    
    static func play(type: SoundType) {
        var disableSound = false
        let dSound = UserDefaults.standard.object(forKey: "enabled_preference_sound") as? Bool
        if let dSound = dSound {
            disableSound = dSound
        }

        if disableSound == false {
            Chirp.sharedManager.playSound(fileName: type.rawValue)
        }
    }
}

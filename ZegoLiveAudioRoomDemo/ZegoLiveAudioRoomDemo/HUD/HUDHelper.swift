//
//  HUDHelper.swift
//  ZegoLiveAudioRoomDemo
//
//  Created by zego on 2021/12/15.
//

import UIKit

class HUDHelper: NSObject {
    
    /// Display a message
    /// - Parameter message: message content
    static func showMessage(message:String) -> Void {
        HUDHelper.showMessage(message: message) {
        }
    }
    
    
    /// Display a message
    /// - Parameters:
    ///   - message: message content
    ///   - doneHandler: done callback
    static func showMessage(message:String,doneHandler:@escaping RoomUICallback) -> Void {
        DispatchQueue.main.async {
            let hud:MBProgressHUD = MBProgressHUD.showAdded(to: getKeyWindow(), animated: true)
            hud.mode = .text
            hud.detailsLabel.text = message
            hud.detailsLabel.font = UIFont.systemFont(ofSize: 15)
            hud.hide(animated: true, afterDelay: 2.5)
            hud.completionBlock = doneHandler
        }
    }
    
    /// Display network loading HUD
    static func showNetworkLoading() -> Void {
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: getKeyWindow(), animated: true)
        }
    }
    
    static func hideNetworkLoading() -> Void {
        DispatchQueue.main.async {
            for subview in getKeyWindow().subviews {
                if subview is MBProgressHUD {
                    let hud:MBProgressHUD = subview as! MBProgressHUD
                    if hud.mode == .indeterminate && hud.label.text == nil {
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(animated: true)
                    }
                }
            }
        }
    }

}

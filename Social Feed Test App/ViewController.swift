//
//  ViewController.swift
//  Social Feed Test App
//
//  Created by ZALORA_USER on 02/12/21.
//

import UIKit
import GetSocialUI
import GetSocialSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        setupGetSocialUI()
//        setupGetSocialWithoutUI()
//        isGetSocialInitialized()
        listenGetSocialInitialized()
    }
    
    private func setupGetSocialUI() {
        let isShown = GetSocialUIInvitesView().show()
        print("Get Social UI Invites View is \(isShown)")
    }
    
    // Won't work on Simulator
    private func setupGetSocialWithoutUI(onChannel channel: String = InviteChannelIds.email) {
        let content = InviteContent()
        content.subject = "Subject"
        content.text = "Text"
        
        Invites.send(content, onChannel: channel, success: {
            print("Invitation via \(channel) was sent")
        }, cancel: {
            print("Invitation via \(channel) was cancelled")
        }, failure: { error in
            print("Failed to send invitation via \(channel) failed, error: \(error)")
        })
    }
    
    private func isGetSocialInitialized() {
        if GetSocial.isInitialized() {
            print("Use get GetSocial")
        } else {
            print("Cannot use GetSocial")
        }
    }
    
    private func listenGetSocialInitialized() {
        GetSocial.addOnInitializedListener {
            print("GetSocial is ready to be used")
//            self.setupGetSocialUI()
//            self.setupGetSocialWithoutUI()
//            self.setupGetSocialWithoutUI(onChannel: InviteChannelIds.facebook)
            self.isGetSocialInitialized()
        }
    }
}


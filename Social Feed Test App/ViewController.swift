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
    
    lazy var inviteFriendsButton: UIButton = {
        let inviteFriendsButton = UIButton()
        inviteFriendsButton.setTitle("Invite Friends", for: .normal)
        inviteFriendsButton.setTitleColor(.systemBlue, for: .normal)
        inviteFriendsButton.addTarget(self, action: #selector(inviteFriendsButtonTapped), for: .touchUpInside)
        inviteFriendsButton.isEnabled = false
        return inviteFriendsButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        setupGetSocialUI()
//        setupGetSocialWithoutUI()
//        isGetSocialInitialized()
        setupView()
        listenGetSocialInitialized()
    }
    
    private func setupView() {
        view.addSubview(inviteFriendsButton)
        inviteFriendsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inviteFriendsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inviteFriendsButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func listenGetSocialInitialized() {
        GetSocial.addOnInitializedListener {
            print("GetSocial is ready to be used")
            self.retrieveReferralDataIfAny()
            self.inviteFriendsButton.isEnabled = GetSocial.isInitialized()
//            self.setupGetSocialUI()
//            self.setupGetSocialWithoutUI()
////            self.setupGetSocialWithoutUI(onChannel: InviteChannelIds.facebook)
//            self.isGetSocialInitialized()
        }
    }
    
    func retrieveReferralDataIfAny() {
        Invites.setOnReferralDataReceivedListener { referralData in
            let navigationPath = referralData.linkParams["$token"] // predefined key
            let customValue1 = referralData.linkParams["custom_key_1"] // custom key
            let isGuranteedMatch: Bool = referralData.isGuaranteedMatch // added metadata

            print("App started with referral data: \(referralData)")
        }
    }
    
    @objc private func inviteFriendsButtonTapped() {
        print("inviteFriendsButtonTapped")
        
        // Attach link params
        let linkParams = ["country": "ID"] as [String: NSObject]
//        LinkParams.customTitle = "Custom landing page title"
        
        // Customize invite message content
        let inviteContent = InviteContent()
        inviteContent.text = "I can't stop playing! Get it here \n\n [APP_INVITE_URL]"
        inviteContent.subject = "Checkout this app"
        inviteContent.mediaAttachment = MediaAttachment.imageUrl("https://docs.getsocial.im/images/logo.png")
        inviteContent.linkParams = linkParams
        
        //        GetSocial.addOnInitializedListener {
        //            // On simulator, only available native share and facebook
        //            Invites.availableChannels { (channels) in
        //                print(channels)
        //            } failure: { (error) in
        //                print(error)
        //            }
        //        }
                
        let channel = InviteChannelIds.nativeShare // or InviteChannelIds.facebook
        
        Invites.send(inviteContent, onChannel: channel, success: {
            print("Invitation via \(channel) was sent")
        }, cancel: {
            print("Invitation via \(channel) was cancelled")
        }, failure: { error in
            print("Failed to send invitation via \(channel) failed, error: \(error)")
        })
        
    }
}

extension ViewController {
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
}


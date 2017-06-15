//
//  ShareDeals.swift
//
//  Created by Ratti on 08/03/17.
//  Copyright © 2017 Ratti. All rights reserved.
//

import UIKit
import MessageUI
import FBSDKShareKit
import Social


class PRShare: NSObject{
    
   static var dealController : UIViewController = UIViewController()
    
   static func share(controller : UIViewController, Message : String, Title : String)
    {
        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let alertController : UIAlertController = UIAlertController.init(title: "Share", message: nil, preferredStyle: .actionSheet)
        
        let Facebook : UIAlertAction = UIAlertAction.init(title: "Facebook", style: .default) { (alertAction) in
            
            let fbContent : FBSDKShareLinkContent = FBSDKShareLinkContent.init()
            fbContent.contentURL = URL.init(string: Message)
            fbContent.contentTitle = Title
            fbContent.contentDescription = Message
            
            let shareDialog:FBSDKShareDialog = FBSDKShareDialog.init()
            shareDialog.shareContent = fbContent
            shareDialog.fromViewController = appDelegate.window?.rootViewController
            shareDialog.mode = .feedWeb
            shareDialog.show()
        }
        
        let Twitter : UIAlertAction = UIAlertAction.init(title: "Twitter", style: .default) { (alertAction) in

            let twitterController : SLComposeViewController = SLComposeViewController.init(forServiceType: SLServiceTypeTwitter)
            
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter)
            {
                twitterController.setInitialText(Message)
                twitterController.add(URL.init(string: Message))
                appDelegate.window?.rootViewController?.present(twitterController, animated: true, completion: nil)
            }
            else
            {
                PRAlertView.showAlert(title: "", message: "Please add twitter account in your settings", Controller: (appDelegate.window?.rootViewController)!)
            }
            
        }
        
        let ShareViaMail : UIAlertAction = UIAlertAction.init(title: "E-Mail", style: .default) { (alertAction) in
            
            ShareDeals.init().shareThroughMail(Message: Message, Title: Title, controller: controller)
        }
        
        let ShareViaMessage : UIAlertAction = UIAlertAction.init(title: "SMS", style: .default) { (alertAction) in
            
            ShareDeals.init().shareThroughMessage(Message: Message, Title: Title, controller: controller)
        }
        
        dealController = controller
        
        let cancel : UIAlertAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(Facebook)
        alertController.addAction(Twitter)
        alertController.addAction(ShareViaMail)
        alertController.addAction(ShareViaMessage)
        alertController.addAction(cancel)
        
        if UI_USER_INTERFACE_IDIOM() == .pad
        {
            alertController.modalPresentationStyle = .popover
            alertController.popoverPresentationController?.sourceView = controller.view
        }
        
        appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func shareThroughMail( Message : String, Title : String, controller : UIViewController)
    {
        if MFMailComposeViewController.canSendMail()
        {
            let mailController : MFMailComposeViewController = MFMailComposeViewController.init()
            mailController.mailComposeDelegate = controller as? MFMailComposeViewControllerDelegate
            mailController.setSubject(Title)
            mailController.setMessageBody(Message, isHTML: false)
            ShareDeals.dealController.present(mailController, animated: true, completion: nil) //appDelegate.window?.rootViewController?
        }
        else
        {
            PRAlertView.showAlert(title: "", message: "Cannot Send Mail", Controller: ShareDeals.dealController)
        }
    }
    
    func shareThroughMessage(Message : String, Title : String, controller : UIViewController)
    {
        
        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        if MFMessageComposeViewController.canSendText()
        {
            let messageController : MFMessageComposeViewController = MFMessageComposeViewController.init()
            messageController.messageComposeDelegate = controller as? MFMessageComposeViewControllerDelegate
            messageController.subject = Title
            messageController.body = Message
            appDelegate.window?.rootViewController?.present(messageController, animated: true, completion: nil)
        }
        else
        {
            PRAlertView.showAlert(title: "", message: "Cannot Send Message", Controller: (appDelegate.window?.rootViewController)!)
        }
    }
    
}

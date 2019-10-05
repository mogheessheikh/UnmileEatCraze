//
//  FeedBackVC.swift
//  UnMile
//
//  Created by iMac  on 21/06/2019.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit
import MessageUI

class FeedBackVC: BaseViewController,MFMailComposeViewControllerDelegate {

    @IBOutlet weak var textBoxMessage: UITextField!
    @IBOutlet weak var textBoxSubject: UITextField!
    var companyObject: CompanyDetails!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       companyObject = getCompanyObject("SavedCompany")
    }
    

    @IBAction func submitFeedBack(_ sender: Any) {
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
            
        } else {
            showMailError()
        }
    }
    
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients([" \(companyObject.companyEmailDetails.supportEmail)"])
        mailComposerVC.setSubject(textBoxSubject.text ?? "Subject")
        mailComposerVC.setMessageBody(textBoxMessage.text ?? "Message", isHTML: false)
        
        return mailComposerVC
    }
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your device could not send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

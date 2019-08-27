//
//  ForgotPasswordViewController.swift
//  Eduhkmit
//
//  Created by Adnan Asghar on 10/8/18.
//  Copyright © 2018 Adnan. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {

    @IBOutlet weak var emailField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func resetDidPress(_ sender: UIButton) {

//        if (emailField.text?.isEmpty)! {
//            showAlert(title: Strings.error, message: "Email is required")
//        } else if !(emailField.text?.isValidEmail())! {
//            showAlert(title: Strings.error, message: "Email is invalid")
//        } else {
//            NetworkManager.forgotPassword(email: emailField.text!, success: { (json, isError) in
//
//                if let success = json["forgetpassword"]["data"]["success"].bool,
//                    success == true,
//                    let message = json["forgetpassword"]["data"]["message"].string {
//                    let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
//                        self.navigationController?.popViewController(animated: true)
//                    }))
//
//                    self.present(alert, animated: true, completion: nil)
//                } else if let message = json["forgetpassword"]["data"]["message"].string {
//
//                    let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
//                        self.navigationController?.popViewController(animated: true)
//                    }))
//                    self.present(alert, animated: true, completion: nil)
//                    //                } else {
//                    //                    self.showError()
//                }
//
//            }, failure: { (error) in
//                //                self.showError()
//            })
//        }
    }
}

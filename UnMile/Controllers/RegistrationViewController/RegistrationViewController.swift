//
//  RegistrationViewController.swift
//  Eduhkmit
//
//  Created by Adnan Asghar on 8/25/18.
//  Copyright © 2018 Adnan. All rights reserved.
//

import UIKit

class RegistrationViewController: BaseViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!

    @IBOutlet weak var termsAndConditionsTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Register"

        termsAndConditionsTextView.delegate = self

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let attributedString = NSMutableAttributedString(string: "By registering you agree to our terms & conditions ", attributes: [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.paragraphStyle.rawValue): paragraphStyle,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.lightGray])

        let range = attributedString.mutableString.range(of: "terms & conditions")
        attributedString.addAttribute(NSAttributedString.Key.link, value: "signup://%20terms%20%26%20conditions", range: range)

        termsAndConditionsTextView.attributedText = attributedString

        let linkAttributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.orange]
        termsAndConditionsTextView.linkTextAttributes = linkAttributes
    }

    @IBAction func registerDidPress(_ sender: UIButton) {

        if (firstName.text?.isEmpty)! {
            showAlert(title: Strings.error, message: "First name is required")
        } else if (lastName.text?.isEmpty)! {
            showAlert(title: Strings.error, message: "Last name is required")
        } else if (emailField.text?.isEmpty)! {
            showAlert(title: Strings.error, message: "Email is required")
        } else if !(emailField.text?.isValidEmail())! {
            showAlert(title: Strings.error, message: "Email is invalid")
        } else if (passwordField.text?.isEmpty)! {
            showAlert(title: Strings.error, message: "Password is required")
        } else if (phoneNumber.text?.isEmpty)! {
            showAlert(title: Strings.error, message: "Phone number is required")
        } else {

            NetworkManager.registerAccount(firstName: firstName.text!, lastName: lastName.text!, email: emailField.text!, password: passwordField.text!, phoneNumber: phoneNumber.text!, success: { (json, isError) in

                if let success = json["register"]["data"]["success"].bool,
                    success == true {
                    self.showAlert(title: Strings.success, message: "You Are Sucessfully Rejistered")
                    let MainVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC")
                    
                    self.navigationController?.pushViewController(MainVC, animated: true)
//                    guard let verifyCodeVC = UIStoryboard.intro.instantiateViewController(withIdentifier: VerifyCodeViewController.storyboardIdentifier) as? VerifyCodeViewController  else {
//                        fatalError("Invalid Controller ")
//                    }
//
//                    self.navigationController?.replaceTopViewController(with: verifyCodeVC, animated: true)

                } else if let message = json["register"]["data"]["message"].string {
                    self.showAlert(title: "Error!", message: message)
                } else {
//                    self.showError()
                }

            }) { (error) in
                self.showAlert(title: Strings.error, message: error.localizedDescription)
            }
        }
    }

    @IBAction func loginDidPress(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension RegistrationViewController: UITextViewDelegate {

    @available(iOS 10.0, *)
  func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.scheme == "signup" {
            print("perform segue")

            return false
        }
        return true
    }

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if URL.scheme == "signup" {
            print("perform segue")
            return false
        }
        return true
    }
}

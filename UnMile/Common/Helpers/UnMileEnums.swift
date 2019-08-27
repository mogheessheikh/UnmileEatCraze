//
//  UnMileEnums.swift
//  UnMile
//
//  Created by Adnan Asghar on 1/5/19.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit

struct Strings {
    static let error                = "Error"
    static let success              = "Success"
    static let somethingWentWrong   = "Something went wrong"
}

struct Storyboard {
    static let main = UIStoryboard(name: StoryboardName.main, bundle: nil)
}

struct StoryboardName {
    static let main = "Main"
}

struct Color {
    static let purple = UIColor.initWithHex(hex: "6558A7")
}

extension UIColor {

    public static func initWithHex(hex: String?) -> UIColor {
        guard let hexString = hex else { return .white }
        var cString:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return .white
        }

        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
           
        )
    }
}

extension UIWindow {
    func replaceRootViewControllerWith(_ replacementController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        let snapshotImageView = UIImageView(image: self.snapshot())
        self.addSubview(snapshotImageView)

        let dismissCompletion = { () -> Void in // dismiss all modal view controllers
            self.rootViewController = replacementController
            self.bringSubviewToFront(snapshotImageView)
            if animated {
                UIView.animate(withDuration: 0.4, animations: { () -> Void in
                    snapshotImageView.alpha = 0
                }, completion: { (success) -> Void in
                    snapshotImageView.removeFromSuperview()
                    completion?()
                })
            }
            else {
                snapshotImageView.removeFromSuperview()
                completion?()
            }
        }
        if self.rootViewController!.presentedViewController != nil {
            self.rootViewController!.dismiss(animated: false, completion: dismissCompletion)
        }
        else {
            dismissCompletion()
        }
    }
}

extension UIView {
    func snapshot() -> UIImage {//Using for transitioning storyboards
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
}

extension UIViewController {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

enum WeekDay: Int {
    case monday = 1, tuesday, wednesday, thursday, friday, saturday, sunday

    func day() -> String {

        switch self {
        case .monday:
            return "Monday"

        case .tuesday:
            return "Tuesday"

        case .wednesday:
            return "Wednesday"

        case .thursday:
            return "Thursday"

        case .friday:
            return "Friday"

        case .saturday:
            return "Saturday"

        case .sunday:
            return "Sunday"

        }
    }
}

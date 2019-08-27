//
//  UnmileExtensions.swift
//  UnMile
//
//  Created by Adnan Asghar on 2/7/19.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import Foundation
import UIKit

extension String {

    func isValidEmail() -> Bool {
        //        let stricterFilter = true
        let stricterFilterString = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,10}"
        //        let laxString = ".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*"
        //        let emailRegex = stricterFilter ? stricterFilterString : laxString
        let emailTest = NSPredicate(format: "SELF MATCHES %@", stricterFilterString/*emailRegex*/)
        return emailTest.evaluate(with:self)
    }

    func isValid(upperLimit: Int) -> Bool {
        // check the name is between 4 and 16 characters
        if !(4...upperLimit ~= self.count) {
            return false
        }

        // check that name doesn't contain whitespace or newline characters
        let range = self.rangeOfCharacter(from: .whitespacesAndNewlines)
        if let range = range, range.lowerBound != range.upperBound {
            return false
        }

        return true
    }

    func isInvalid(lowerBound min: Int = 8, upperBound max: Int = 40) -> Bool {

        if self.isEmptyOrWhitespace() { return true }

        if (min...max).contains(count) {
            return false
        } else {
            return true
        }
    }

    //    func isInvalid(lowerLimit: Int = 8, upperLimit: Int = 40) -> Bool {
    //        if (count < lowerLimit || count > upperLimit) {
    //            return true
    //        }
    //
    //        // check that name doesn't contain whitespace or newline characters
    //        let range = self.rangeOfCharacter(from: .whitespacesAndNewlines)
    //        if let range = range, range.lowerBound != range.upperBound {
    //            return true
    //        }
    //
    //        return false
    //    }

    func isEmptyOrWhitespace() -> Bool {

        if(self.isEmpty) {
            return true
        }

        return (self.trimmingCharacters(in: .whitespacesAndNewlines) == "")
        //.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "")
    }

    func getHoursAndMinutesString(format: String) -> String {

        return "\(getHours(format: format)).\(getMinutes(format: format))"
    }

    func getHoursDotMinutes() -> String {

        let components = self.components(separatedBy: ":")
        if components.count == 0 {
            return ""
        } else if let hours = Float(components[0]), let minutes = Float(components[1]) {
            let mins = minutes/60
            let fullHours = hours + mins
            return String(format: "%.2f", fullHours).replacingOccurrences(of: ".00", with: "")
        }

        return ""
    }

    func getHours(format: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format

        let date = dateFormatter.date(from: self)
        return Calendar.current.component(.hour, from: date!)
    }

    func getMinutes(format: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format

        let date = dateFormatter.date(from: self)
        return Calendar.current.component(.minute, from: date!)
    }

//    func getDateString(fromFormat: String, toFormat: String) -> String {
//
//        let df = DateFormatter()
//        df.dateFormat = fromFormat
//        df.timeZone = NSTimeZone.local
//        df.calendar = NSCalendar.current
//
//        guard let dateFromString = df.date(from: self) else {
//            let stringsArray = self.components(separatedBy: "T")
//            let subDate = stringsArray[0]
//            if subDate.count > 0 {
//                return subDate.getDateString(fromFormat: DateFormats.YYYY_MM_dd, toFormat: toFormat)
//            } else {
//                return ""
//            }
//        }
//
//        df.dateFormat = toFormat
//        return df.string(from: dateFromString)
//    }

    func getDate(toFormat: String) -> Date? {

        let df = DateFormatter()
        df.dateFormat = toFormat
        df.timeZone = NSTimeZone.local
        df.calendar = NSCalendar.current

        guard let dateFromString = df.date(from: self) else {
            return nil
        }

        return dateFromString
    }

    func contains(find: String) -> Bool {
        return self.lowercased().range(of: find.lowercased()) != nil
    }

    func getPlural(count: String) -> String {
        if let integer = Int(count) {
            if integer == 1 {
                return self
            } else {
                return self + "s"
            }
        } else {
            return ""
        }
    }

    func getPlural(count: Int) -> String {
        if count == 1 {
            return self
        } else {
            return self + "s"
        }
    }

    mutating func removeSpaces() {
        var text = self
        text = text.replacingOccurrences(of: " ", with: "")
        text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        self = text
    }
}


extension Dictionary {
    var jsonStringRepresentaiton: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                                            options: [.prettyPrinted]) else {
                                                                return nil
        }

        return String(data: theJSONData, encoding: .ascii)
    }
}

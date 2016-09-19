/*
 * Copyright (c) 2016 Naresh Kumar
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import UIKit

extension String {
    
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .CaseInsensitive)
            return regex.firstMatchInString(self, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    var isPhoneNumber: Bool {
        
        let charcter  = NSCharacterSet(charactersInString: "+0123456789").invertedSet
        var filtered:NSString!
        let inputString:NSArray = self.componentsSeparatedByCharactersInSet(charcter)
        filtered = inputString.componentsJoinedByString("")
        return  self == filtered
        
    }
    
    func validatePhone(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluateWithObject(value)
        return result
    }
    
    func isNumber() -> Bool {
        let numberCharacters = NSCharacterSet.decimalDigitCharacterSet().invertedSet
        return !self.isEmpty && self.rangeOfCharacterFromSet(numberCharacters) == nil
    }
    
    func isBackSpaceDetected() -> Bool{
        let  char = self.cStringUsingEncoding(NSUTF8StringEncoding)!
        let isBackSpace = strcmp(char, "\\b")
        if (isBackSpace == -92) {
            return true
        }
        return false
    }
    
    func isValidIP(s: String) -> Bool {
        let parts = s.componentsSeparatedByString(".")
        let nums = parts.flatMap { Int($0) }
        return parts.count == 4 && nums.count == 4 && nums.filter { $0 >= 0 && $0 < 256}.count == 4
    }
    
    func isValidURLStringFormat() -> Bool {
        guard let url = NSURL(string: String(self)) else {return false}
        if !UIApplication.sharedApplication().canOpenURL(url) {return false}
        
        //
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluateWithObject(String(self))
    }
    
    func maskingPassword(count:Int) -> String {
        var ret:String = ""
        for _ in 0..<count {
            ret.append("*" as Character)
        }
        return ret
    }
    
    func maskingCardNumber() -> String {
        if self.characters.count < 4 {
            return "NA"
        }
        return "**** **** **** "+self.substringFromIndex(self.endIndex.advancedBy(-4))
    }

    func maskingCardNumberWithoutSpace() -> String {
        if self.characters.count < 4 {
            return "NA"
        }
        return "************"+self.substringFromIndex(self.endIndex.advancedBy(-4))
    }
    
    func removeSpecialCharsFromString() -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890".characters)
        return String(self.characters.filter {okayChars.contains($0) })
    }
    
    func replaceSpecialCharsWithString(string:String) -> String {
        let set = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890").invertedSet
        let formatedString = self.componentsSeparatedByCharactersInSet(set).joinWithSeparator(string)
        return formatedString
    }
    
    func removeNonDigitsFromString() -> String {
        let set = NSCharacterSet.decimalDigitCharacterSet().invertedSet
        let numbers = self.componentsSeparatedByCharactersInSet(set)
        return numbers.joinWithSeparator("")
    }
    
    func replaceNonDigitsWithString(string:String) -> String {
        let set = NSCharacterSet.decimalDigitCharacterSet().invertedSet
        let numbers = self.componentsSeparatedByCharactersInSet(set)
        return numbers.joinWithSeparator(string)
    }
    
    func chopPrefix(count: Int = 1) -> String {
        return self.substringFromIndex(self.startIndex.advancedBy(count))
    }
    
    func chopSuffix(count: Int = 1) -> String {
        return self.substringToIndex(self.endIndex.advancedBy(-count))
    }
    
    func containsSpecialChars() -> Bool {
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: NSRegularExpressionOptions())
        if regex.firstMatchInString(String(self), options: NSMatchingOptions(), range:NSMakeRange(0, String(self).characters.count)) != nil {
            return true
        }
        return false
    }
    
    func containsDigits() -> Bool {
        let regex = try! NSRegularExpression(pattern: ".*[^0-9].*", options: NSRegularExpressionOptions())
        if regex.firstMatchInString(String(self), options: NSMatchingOptions(), range:NSMakeRange(0, String(self).characters.count)) != nil {
            return true
        }
        return false
    }
    
    func containsSpecialCharsWithHyphenAndUnderscore() -> Bool {
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9._-].*", options: NSRegularExpressionOptions())
        if regex.firstMatchInString(String(self), options: NSMatchingOptions(), range:NSMakeRange(0, String(self).characters.count)) != nil {
            return true
        }
        return false
    }
    
    func containsStarPound() -> Bool {
        let regex = try! NSRegularExpression(pattern: ".*[*#]+.*", options: NSRegularExpressionOptions())
        if regex.firstMatchInString(String(self), options: NSMatchingOptions(), range:NSMakeRange(0, String(self).characters.count)) != nil {
            return true
        }
        return false
    }
    
    func containsExpression(expression: String) -> Bool {
        return self.lowercaseString.rangeOfString(expression.lowercaseString, options: .RegularExpressionSearch) != nil
    }
    
    func extractExpression(expression: String) -> String? {
        let regex = try! NSRegularExpression(pattern: expression, options: [])
        let matches = regex.matchesInString(self, options: [], range: NSMakeRange(0, self.characters.count))
        return matches.first.map { (self as NSString).substringWithRange($0.range) }
    }
    
    func gmtDateFormatter() -> NSDateFormatter {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        
        return formatter
    }
    
    func toDate() -> NSDate? {
        let dateTimeFormatExpression = "(\\d{4})-(\\d{2})-(\\d{2})T(\\d{2})\\:(\\d{2})\\:(\\d{2})(z|Z)?"
        let dateFormatExpression = "(\\d{4})-(\\d{2})-(\\d{2})"
        
        var (dateString, dateFormat): (String?, String?)
        if (self.characters.last == "z" || self.characters.last == "Z")
            && self.characters.count <= 20
            && self.containsExpression(dateTimeFormatExpression) {
            // String contains a date and time
            dateString = self.extractExpression(dateTimeFormatExpression)
            dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        } else if self.containsExpression(dateFormatExpression) {
            // String contains a date only
            dateString = self.extractExpression(dateFormatExpression)
            dateFormat = "yyyy-MM-dd"
        }
        
        let result: NSDate?
        if let dateString = dateString,
            dateFormat = dateFormat {
            let formatter = self.gmtDateFormatter()
            formatter.dateFormat = dateFormat
            result = formatter.dateFromString(dateString)
        } else {
            result = nil
        }
        
        return result
    }
    
}

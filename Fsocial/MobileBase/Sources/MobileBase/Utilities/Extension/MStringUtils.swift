//
//  StringUtils.swift
// Example
//
//  Created by ChungTV on 14/02/2022.
//

import Foundation
import UIKit
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

public extension String{
    var isHtml:Bool{
        if self.isEmpty{
            return false
        }
        if self.contains("{blankContent}"){
            return true
        }
        if self.isLaTeXString() {
            return true
        }
        return (self.range(of: "<(\"[^\"]*\"|'[^']*'|[^'\">])*>", options: .regularExpression) != nil)
    }
    func isLaTeXString() -> Bool {
        let regex = try! NSRegularExpression(pattern: "\\$.*?\\$")
        let range = NSRange(location: 0, length: self.utf16.count)
        let matches = regex.matches(in: self, range: range)
        return matches.count > 0
    }
}
public extension String {
    var MD5: String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digestData = Data(count: length)
        
        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            data.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(data.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
}
public extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    var isBlank: Bool {
        return self.trim().isEmpty
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func removeAllWhitespaces() -> String {
        return components(separatedBy: .whitespacesAndNewlines).joined(separator: "")
    }
    
    func lowercasedAndRemoveSpaces() -> String {
        return self.lowercased().replacingOccurrences(of: " ", with: "").trim()
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
        }
}

public extension Optional where Wrapped == String {
    var isNilOrBlank: Bool {
        guard let str = self else {
            return true
        }
        return str.isBlank
    }
    
    var isNilOrEmpty: Bool {
        guard let str = self else {
            return true
        }
        return str.isEmpty
    }
}

extension Substring {
    func trim() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension Int: StringableProtocol {}
extension Int16: StringableProtocol {}
extension Int32: StringableProtocol {}
extension Int64: StringableProtocol {}
extension Double: StringableProtocol {
    public func toString() -> String {
        if self.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", self)
        }
        return Formatter().string(from: self) ?? "\(self)"
    }
}

public protocol StringableProtocol {
    func toString() -> String
}

extension StringableProtocol {
    public func toString() -> String {
        return "\(self)"
    }
}
class Formatter: NSObject {
    static let shared = Formatter()
    
    // MARK: Formatters
    lazy var currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.roundingMode = .halfUp
        formatter.numberStyle = .currency
        formatter.positiveFormat = "#,###"
        formatter.currencySymbol = "VNĐ"
        formatter.currencyGroupingSeparator = "."//","
        formatter.currencyDecimalSeparator = ","
        formatter.groupingSeparator =  "."//","
        formatter.decimalSeparator = ","
        
        return formatter
    }()
    
    lazy var currencyFormatterWithSymbol: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.roundingMode = .halfUp
        formatter.numberStyle = .currency
        formatter.positiveFormat = "#,###¤"
        formatter.currencySymbol = "VNĐ"
        formatter.currencyGroupingSeparator = "."
        formatter.currencyDecimalSeparator = ","
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        
        return formatter
    }()
    
    lazy var currencyShortFormatterWithSymbol: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.roundingMode = .halfUp
        formatter.numberStyle = .currency
        formatter.positiveFormat = "#,###¤"
        formatter.currencySymbol = "đ"
        formatter.currencyGroupingSeparator = "."
        formatter.currencyDecimalSeparator = "."
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = "."
        
        return formatter
    }()
    
    lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.roundingMode = .halfUp
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        formatter.maximumFractionDigits = 3
        
        return formatter
    }()
    
    lazy var numberFormatterDot: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.roundingMode = .halfUp
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = 3
        
        return formatter
    }()
    lazy var statisticNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.roundingMode = .halfUp
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        formatter.maximumFractionDigits = 1
        
        return formatter
    }()
    
    lazy var dashboardNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.roundingMode = .halfUp
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        formatter.maximumFractionDigits = 2
        
        return formatter
    }()
    
    lazy var inputDecimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 3
        formatter.roundingMode = .halfUp
        formatter.usesGroupingSeparator = false
        return formatter
    }()
    
    var maximumFractionDigits: Int {
        return numberFormatter.maximumFractionDigits
    }
    
    var decimalSeparator: String {
        return numberFormatter.decimalSeparator
    }
    
    // MARK: Currency
    func currencyString(from number: Double) -> String? {
        return currencyFormatter.string(from: NSNumber(value: number))
    }
    
    func currencyString(from number: Decimal) -> String? {
        return currencyFormatter.string(from: number as NSDecimalNumber)
    }
    
    // MARK: Number
    func string(from number: Double, maxFractionDigits: Int? = nil) -> String? {
        guard let maxFractionDigits = maxFractionDigits else {
            return numberFormatter.string(from: NSNumber(value: number))
        }
        
        let origMaxFractionDigits = numberFormatter.maximumFractionDigits
        numberFormatter.maximumFractionDigits = maxFractionDigits
        let string = numberFormatter.string(from: NSNumber(value: number))
        numberFormatter.maximumFractionDigits = origMaxFractionDigits
        return string
    }
    
    func string(from number: Decimal, maxFractionDigits: Int? = nil) -> String? {
        guard let maxFractionDigits = maxFractionDigits else {
            return numberFormatter.string(from: number as NSDecimalNumber)
        }
        
        let origMaxFractionDigits = numberFormatter.maximumFractionDigits
        numberFormatter.maximumFractionDigits = maxFractionDigits
        let string = numberFormatter.string(from: number as NSDecimalNumber)
        numberFormatter.maximumFractionDigits = origMaxFractionDigits
        return string
    }
    
    func stringNoDecimal(from number: Double) -> String? {
        string(from: number, maxFractionDigits: 0)
    }
    
    func inputDecimalString(from number: Double) -> String? {
        return inputDecimalFormatter.string(from: NSNumber(value: number))
    }
    
    func number(from string: String?) -> Double {
        parseNumber(from: string, using: numberFormatter)
    }
    
    func number(from string: String?, maxFractionDigits: Int) -> Double {
        parseNumber(from: string, maxFractionDigits: maxFractionDigits, using: numberFormatter)
    }
    
    func inputDecimal(from string: String?) -> Double {
        parseNumber(from: string, using: inputDecimalFormatter)
    }
    
    func inputDecimal(from string: String?, maxFractionDigits: Int) -> Double {
        parseNumber(from: string, maxFractionDigits: maxFractionDigits, using: inputDecimalFormatter)
    }
    
    private func parseNumber(from string: String?, maxFractionDigits: Int? = nil, using formatter: NumberFormatter) -> Double {
        guard let string = string else {
            return 0
        }
        
        guard let maxFractionDigits = maxFractionDigits else {
            return formatter.number(from: string)?.doubleValue ?? 0
        }
        
        let oldDigits = formatter.maximumFractionDigits
        formatter.maximumFractionDigits = maxFractionDigits
        guard let number = formatter.number(from: string) else {
            formatter.maximumFractionDigits = oldDigits
            return 0
        }
        
        // Round number with max fraction digits and convert to string
        guard let numberString = formatter.string(from: number) else {
            formatter.maximumFractionDigits = oldDigits
            return 0
        }
        
        formatter.maximumFractionDigits = oldDigits
        
        // Return rounded number
        return formatter.number(from: numberString)?.doubleValue ?? 0
    }
}

extension Comparable {
    func isBetween(lower: Self?, upper: Self?) -> Bool {
        if let lower = lower, let upper = upper {
            return self >= lower && self <= upper
        }
        
        if let lower = lower {
            return self >= lower
        }
        
        if let upper = upper {
            return self <= upper
        }
        
        return false
    }
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}


extension StringProtocol {
    var stripingDiacritics: String {
        applyingTransform(.stripDiacritics, reverse: false)!
    }
    
    var stripAccents: String {
        stripingDiacritics.replacingOccurrences(of: "đ", with: "d")
    }
}

//
//  StyleKit.swift
//  iStudy
//
//  Created by Kien Trung on 2022/10/28.
//

import UIKit
import SwiftUI

extension UIFont {
    static func font(size: CGFloat, weight: AppFontStyle = .regular) -> UIFont {
        StyleKit.font(with: size, and: weight)
    }
}

struct StyleKit {
    @nonobjc static var MainColorNavigationBar: UIColor {
        return UIColor(named: "#FFFFFF") ?? .white
    }
    
    @nonobjc static var buttonMarginOffset: CGFloat { return -5 }
    @nonobjc static var fontNameInter: String { return "Ubuntu-Regular" }
    @nonobjc static var fontNameInterBold: String { return "Ubuntu-Bold" }
    @nonobjc static var fontNameInterMedium: String { return "Ubuntu-Medium" }
    
    static func appFont(with font: AppFont) -> UIFont {
        let size = font.size.rawValue
        
        if let font = AppFontStyle.font(for: font.fontName, with: font.size, and: font.style) {
            return font
        } else {
            return UIFont(descriptor: UIFontDescriptor(name: font.fontName,
                                                       size: size),
                          size: size)
        }
    }
    
    static func font(
        with fontSize: CGFloat,
        and weight: AppFontStyle = .regular
    ) -> UIFont {
        let font = AppFont(size: AppFontSize(rawValue: fontSize) ?? .xMedium, style: weight)
        return appFont(with: font)
    }
    
    static func appFont(with fontSize: AppFontSize,
                        and style: AppFontStyle = .regular) -> UIFont {
        let font = AppFont(size: fontSize, style: style)
        return appFont(with: font)
    }
    
    static func appFont(with size: CGFloat, and font: String) -> UIFont {
        let font = UIFont(name: font, size: size) ?? UIFont.systemFont(ofSize: size)
        return font
    }
    
    static func underlineAttributedString(with text: String, for fontSize: AppFontSize) -> NSAttributedString? {
        let attrs: [NSAttributedString.Key: Any] = [
            .font: appFont(with: fontSize, and: .bold),
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attrString = NSAttributedString(string: text,
                                            attributes: attrs)
        return attrString
    }
    
    static func highlightKeyWord(_ keyword: String, _ text: String,
                                 with fontSize: AppFontSize,
                                 and style: AppFontStyle = .regular,
                                 color: UIColor = .black) -> NSMutableAttributedString? {
        var attrText: NSMutableAttributedString?
        let textLowercase = text.lowercased()
        let range = (textLowercase as NSString).range(of: keyword.lowercased())
        if range.location != NSNotFound {
            let highlightAttr: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: StyleKit.appFont(with: fontSize, and: style),
                NSAttributedString.Key.foregroundColor: color
            ]
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttributes(highlightAttr, range: range)
            attrText = attributedText
        }
        
        return attrText
    }
    
    static func highlightKeyWords(_ keywords: [String], _ text: String,
                                 with fontSize: AppFontSize,
                                 and style: AppFontStyle = .regular,
                                 color: UIColor = .black) -> NSMutableAttributedString? {
        var attrText: NSMutableAttributedString?
        let textLowercase = text.lowercased()
        var ranges = [NSRange]()
        keywords.forEach { keyword in
            let range = (textLowercase as NSString).range(of: keyword.lowercased())
            if range.location != NSNotFound {
                ranges.append(range)
            }
        }
        
        if ranges.count > 0 {
            let highlightAttr: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: StyleKit.appFont(with: fontSize, and: style),
                NSAttributedString.Key.foregroundColor: color
            ]
            let attributedText = NSMutableAttributedString(string: text)
            ranges.forEach { range in
                attributedText.addAttributes(highlightAttr, range: range)
            }
            attrText = attributedText
        }
        
        return attrText
    }

    static func concatAttributesString(string1: String, font1: UIFont, string2: String, font2: UIFont, color: UIColor) -> NSAttributedString {
        let baseAttributes: [NSAttributedString.Key: Any] = [
            .font: font1,
            .foregroundColor: color
        ]
        let baseAttributes2: [NSAttributedString.Key: Any] = [
            .font: font2,
            .foregroundColor: color
        ]
        
        let attrString = NSMutableAttributedString(string: string1)
        attrString.addAttributes(baseAttributes, range: NSRange(location: 0, length: attrString.length))
        
        let attrString2 = NSMutableAttributedString(string: string2)
        attrString2.addAttributes(baseAttributes2, range: NSRange(location: 0, length: attrString2.length))
        
        attrString.append(attrString2)
        
        return attrString
    }
}

extension AppFont {
    static let inter: String = "Inter"
    static let popins: String = "Poppins"
}

struct AppFont {
    let fontName: String
    let size: AppFontSize
    let style: AppFontStyle
    
    init(size: AppFontSize, style: AppFontStyle) {
        self.fontName = AppFont.inter
        self.size = size
        self.style = style
    }
    
    init(font: String, size: AppFontSize, style: AppFontStyle) {
        self.fontName = font
        self.size = size
        self.style = style
    }
    
    func toUIFont() -> UIFont? {
        return AppFontStyle.font(for: fontName, with: size, and: style)
            ?? UIFont(name: fontName, size: size.rawValue)
    }
}

extension UIFont {
    static var appMediumSemibold: UIFont {
        StyleKit.appFont(with: .xMedium, and: .semiBold)
    }
    
    static var appMediumRegular: UIFont {
        StyleKit.appFont(with: .xMedium, and: .regular)
    }
    
    static var appMSmallRegular: UIFont {
        StyleKit.appFont(with: .mSmall, and: .regular)
    }
    
    static var mediumRegular: UIFont {
        StyleKit.appFont(with: .mSmall, and: .regular)
    }
    
    static var appMediumBold: UIFont {
        StyleKit.appFont(with: .medium, and: .bold)
    }
    
    static var appMSmallBold: UIFont {
        StyleKit.appFont(with: .mSmall, and: .bold)
    }
    
    static var appMSmallSemiBold: UIFont {
        StyleKit.appFont(with: .mSmall, and: .semiBold)
    }
    
    static var appSmallRegular: UIFont {
        StyleKit.appFont(with: .small, and: .regular)
    }
    
    static var appSmallMedium: UIFont {
        StyleKit.appFont(with: .small, and: .medium)
    }
    
    static var appxmLargeMedium: UIFont {
        StyleKit.appFont(with: .xmLarge, and: .semiBold)
    }
    
    static var poppinsMediumRegular: UIFont {
        StyleKit.appFont(with: AppFont(font: AppFont.popins, size: .medium, style: .regular))
    }
    
    static var appxxxLargeMedium: UIFont {
        StyleKit.appFont(with: .xxxLarge, and: .medium)
    }
    
    static var appXXXLargeMedium: UIFont {
        StyleKit.appFont(with: .XXXLarge, and: .medium)
    }
    
    static var appxxSmallRegular: UIFont {
        StyleKit.appFont(with: .xxSmall, and: .regular)
    }
}

extension CGFloat {
    @nonobjc static var appCorner: CGFloat { return 10 }
}

extension UIColor {
    @nonobjc class var appTint: UIColor { return UIColor.red }
    @nonobjc class var appBar: UIColor { return .white }
    @nonobjc class var appTitleBar: UIColor { return .black }
    @nonobjc class var popoverBackground: UIColor { return UIColor(red: 0.8863, green: 0.8863, blue: 0.8863, alpha: 1.0) }
    @nonobjc class var darkRed: UIColor { return UIColor(red: 137.0/255.0, green: 0, blue: 0, alpha: 1.0) }
}

extension UIImage {
    @nonobjc class var placeHolder: UIImage {
        return UIImage(named: "ic_avt_place") ?? UIImage()
    }
}

enum AppFontSize: CGFloat {
    case little = 7
    case xMicro = 8
    case micro = 9
    case xxSmall = 10
    case xSmall = 11
    case small = 12
    case mSmall = 13
    case medium = 14
    case xMedium = 16
    case large = 15
    case xLarge = 17
    case xmLarge = 20
    case xxLarge = 24
    case xxxLarge = 36
    case XXXLarge = 60
}

enum AppFontStyle: String {
    case medium           = "Medium"
    case mediumItalic     = "MediumItalic"
    case italic           = "Italic"
    case light            = "Light"
    case lightItalic      = "LightItalic"
    case semiBold         = "SemiBold"
    case bold             = "Bold"
    case regular          = "Regular"
    case boldItalic       = "BoldItalic"
    
    static func font(for name: String, with size: AppFontSize, and style: AppFontStyle) -> UIFont? {
        let familyFont = UIFont.fontNames(forFamilyName: name)
        let fonts = familyFont.filter({ $0.contains(style.rawValue) })
        guard fonts.count > 0 else { return nil }
        
        if fonts.count == 1,
            let fontName = fonts.first,
            let font = UIFont(name: fontName, size: size.rawValue) {
            return font
        } else {
            let fontName = "\(name.replacingOccurrences(of: " ", with: ""))-\(style.rawValue)"
            let font = UIFont(name: fontName, size: size.rawValue)
            return font
        }
    }
}

enum AppSpacing: CGFloat {
    case homeStudyListPadding = 24
    case homeStudyListSpacing = 16
    
    case sectionFilterPadding = 20
    case sectionFilterMinWidth   = 100
    case sectionFilterHeight     = 36
}

struct AppStyleConfig {
    static let screenWidth           = UIScreen.main.bounds.width
    static let screenHeight          = UIScreen.main.bounds.width
}

extension Font {
    static func bold(size: CGFloat) -> Self {
        .custom("Inter-Bold", size: size)
    }
    
    static func intalic(size: CGFloat) -> Self {
        .custom("Inter-Italic", size: size)
    }
    
    static func semibold(size: CGFloat) -> Self {
        .custom("Inter-SemiBold", size: size)
    }
    
    
    static func regualar(size: CGFloat) -> Self {
        .custom("Inter-Regular", size: size)
    }
    
    static func medium(size: CGFloat) -> Self {
        .custom("Inter-Medium", size: size)
    }
}

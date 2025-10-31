//
//  AttributedStringBuilder.swift
// Example
//
//  Created by ChungTV on 14/02/2022.
//

import UIKit

public class MAttributedStringBuilder {

    private var listAttString: [(string: String?, attrs: [NSAttributedString.Key : Any])] = []
    private var lastStartAttIndex: Int = 0
    
    public init() {}
    
    @discardableResult
    public func append(_ text: String?) -> MAttributedStringBuilder {
        lastStartAttIndex = listAttString.count
        listAttString.append((text, [:]))
        return self
    }
    
    @discardableResult
    public func with(_ color: UIColor) -> MAttributedStringBuilder {
        listAttString[lastStartAttIndex].attrs[
            NSAttributedString.Key.foregroundColor
        ] = color
        return self
    }
    
    @discardableResult
    public func with(_ font: UIFont) -> MAttributedStringBuilder {
        listAttString[lastStartAttIndex].attrs[
            NSAttributedString.Key.font
        ] = font
        return self
    }
    
    @discardableResult
    public func with(_ underLineStyle: NSUnderlineStyle) -> MAttributedStringBuilder {
        listAttString[lastStartAttIndex].attrs[
            NSAttributedString.Key.underlineStyle
        ] = underLineStyle.rawValue
        return self
    }
    
    @discardableResult
    public func with(_ paragraphStyle: NSParagraphStyle) -> MAttributedStringBuilder {
        listAttString[lastStartAttIndex].attrs[
            NSAttributedString.Key.paragraphStyle
        ] = paragraphStyle
        return self
    }
    
    @discardableResult
    public func with(_ link: URL) -> MAttributedStringBuilder {
        listAttString[lastStartAttIndex].attrs[
            NSAttributedString.Key.link
        ] = link
        return self
    }
    
    @discardableResult
    public func with(strikethrough color: UIColor, height: CGFloat = 1.0) -> MAttributedStringBuilder {
        listAttString[lastStartAttIndex].attrs[
            NSAttributedString.Key.strikethroughColor
        ] = color
        listAttString[lastStartAttIndex].attrs[
            NSAttributedString.Key.strikethroughStyle
        ] = height
        return self
    }
    
    @discardableResult
    public func with(bgColor color: UIColor) -> MAttributedStringBuilder {
        listAttString[lastStartAttIndex].attrs[
            NSAttributedString.Key.backgroundColor
        ] = color
        return self
    }
    
    public func with(_ baselineOffset: CGFloat) -> MAttributedStringBuilder {
        listAttString[lastStartAttIndex].attrs[
            NSAttributedString.Key.baselineOffset
        ] = baselineOffset
        return self
    }
    
    public func attributedString() -> NSMutableAttributedString {
        let result = NSMutableAttributedString()
        for attString in listAttString {
            if let string = attString.string, string.count > 0 {
                result.append(NSAttributedString(string: string, attributes: attString.attrs))
            }
        }
        return result
    }
}
extension NSAttributedString {
    
    func height(containerWidth: CGFloat) -> CGFloat {
        
        let rect = self.boundingRect(with: CGSize.init(width: containerWidth, height: CGFloat.greatestFiniteMagnitude),
                                     options: [.usesLineFragmentOrigin, .usesFontLeading],
                                     context: nil)
        return ceil(rect.size.height)
    }
    
    func width(containerHeight: CGFloat) -> CGFloat {
        
        let rect = self.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: containerHeight),
                                     options: [.usesLineFragmentOrigin, .usesFontLeading],
                                     context: nil)
        return ceil(rect.size.width)
    }
}

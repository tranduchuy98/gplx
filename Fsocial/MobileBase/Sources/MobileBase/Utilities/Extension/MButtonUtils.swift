//
//  ButtonUtils.swift
// Example
//
//  Created by ChungTV on 14/02/2022.
//

import UIKit

extension UIButton {
    func setHighlighted() {
        let selectedBg = UIImage.from(color: UIColor.gray)
        self.setBackgroundImage(selectedBg, for: .highlighted)
    }
}

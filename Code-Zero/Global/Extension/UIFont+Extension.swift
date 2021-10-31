//
//  UIFont+Extension.swift
//  Code-Zero
//
//  Created by 이주혁 on 2021/10/17.
//

import UIKit

extension UIFont {
    enum Family: String {
        case heavy = "Heavy"
        case bold = "Bold"
        case medium = "Medium"
        case regular = "Regular"
    }

    static func futuraStd(size: CGFloat = 10, family: Family = .regular) -> UIFont {
        return UIFont(name: "FuturaStd-\(family)", size: size)!
    }

    static func spoqaHanSansNeo(size: CGFloat = 10, family: Family = .regular) -> UIFont {
        return UIFont(name: "SpoqaHanSansNeo-\(family)", size: size)!
    }
}

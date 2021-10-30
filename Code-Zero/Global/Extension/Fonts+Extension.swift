//
//  Fonts+Extension.swift
//  Code-Zero
//
//  Created by 이주혁 on 2021/10/17.
//

import UIKit

extension UIFont {
    enum Family: String {
        // swiftlint:disable identifier_name
        case Heavy, Black, Bold, Light, Medium, Regular, Thin
        // swiftlint:enable identifier_name
    }

    static func futuraStd(size: CGFloat = 10, family: Family = .Regular) -> UIFont {
        return UIFont(name: "FuturaStd-\(family)", size: size)!
    }

    static func spoqaHanSansNeo(size: CGFloat = 10, family: Family = .Regular) -> UIFont {
        return UIFont(name: "SpoqaHanSansNeo-\(family)", size: size)!
    }
}

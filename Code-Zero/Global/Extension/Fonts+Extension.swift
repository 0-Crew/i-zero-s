//
//  Fonts+Extension.swift
//  Code-Zero
//
//  Created by 이주혁 on 2021/10/17.
//

import UIKit

extension UIFont {
    enum Family: String {
        case Heavy ,Black, Bold, Light, Medium, Regular, Thin
    }
    
    static func futuraStd(size: CGFloat = 10, family: Family = .Regular) -> UIFont {
        return UIFont(name: "FuturaStd-\(family)", size: size)!
    }
    
    static func spoqaHanSansNeo(size: CGFloat = 10, family: Family = .Regular) -> UIFont {
        return UIFont(name: "Spoqa Han Sans Neo Bold \(family)", size: size)!
    }
}

//
//  UIButton+Extension.swift
//  Code-Zero
//
//  Created by 이주혁 on 2021/11/02.
//

import UIKit


extension UIButton {
    func setButton(text: String, color: UIColor = .black, font: UIFont, backgroundColor: UIColor = .clear) {
        // setButton : 내용, 폰트, 컬러, background 컬러까지 한번에 설정
        
        self.setTitle(text, for: .normal)
        self.titleLabel?.font = font
        self.setTitleColor(color, for: .normal)
        self.backgroundColor = backgroundColor
    }
}

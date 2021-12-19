//
//  UILabel+Extension.swift
//  Code-Zero
//
//  Created by 이주혁 on 2021/11/02.
//

import UIKit

extension UILabel {

    func setLabel(text: String, color: UIColor, font: UIFont) {
        self.text = text
        self.font = font
        self.textColor = color
    }

    func setLineSpacing(lineSpacing: CGFloat) {
        // lineSetting: UILabel의 text가 lineSpacing 또는 letterSpacing 이 있을 때 사용

        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = .center
        let attributedString = NSMutableAttributedString(string: labelText)
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: .init(location: 0, length: attributedString.length)
        )

        self.attributedText = attributedString
    }

    func setFontWith(font: UIFont, in ranges: [String]) {
            guard let text = self.text else { return }
            let attributedString = NSMutableAttributedString(string: text)
            ranges.forEach {
                let range = attributedString.mutableString.range(of: $0)
                attributedString.addAttribute(.font, value: font, range: range)
            }
            self.attributedText = attributedString
        }
}

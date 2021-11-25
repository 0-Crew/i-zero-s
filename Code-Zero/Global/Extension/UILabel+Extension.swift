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
//    func setLineSpacing(lineSpacing: CGFloat = 0.0) {
//        guard let labelText = self.text else { return }
//
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = lineSpacing
//
//        let attributedString = NSMutableAttributedString(string: labelText)
//        attributedString.addAttribute(
//            .paragraphStyle,
//            value: lineSpacing,
//            range: .init(location: 0, length: attributedString.length - 1)
//        )
//        let attributes = [
//        let attributedText = NSAttributedString(string: labelText, attributes: [])
//
//        self.attributedText =
//    }
}

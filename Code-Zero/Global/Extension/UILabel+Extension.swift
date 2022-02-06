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

    func setTextWithLineHeight(lineHeight: CGFloat) {

        guard let attributeText = self.text else { return }

        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = lineHeight
        style.minimumLineHeight = lineHeight

        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: style,
            .baselineOffset: (lineHeight - font.lineHeight) / 4
        ]

        let attrString = NSAttributedString(string: attributeText,
                                            attributes: attributes)
        self.attributedText = attrString
    }

    func setTextLetterSpacing(letterSpacing: CGFloat) {

        guard let text = self.text else { return }
        let attributes: [NSAttributedString.Key: Any] = [
            .kern: letterSpacing
        ]

        if let attributedText = self.attributedText {
            let attributedString = NSMutableAttributedString(attributedString: attributedText)
            attributedString.addAttributes(
                attributes,
                range: .init(location: 0, length: attributedString.length)
            )
            self.attributedText = attributedString
        } else {
            let attrString = NSAttributedString(string: text,
                                                attributes: attributes)
            self.attributedText = attrString
        }
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

    func setUnderLineBoldFontWithLink(in ranges: [String]) {
        guard let text = self.text else { return }
        let attributedString = NSMutableAttributedString(string: text)

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.spoqaHanSansNeo(size: 12, family: .bold),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        ranges.forEach {
            let range = attributedString.mutableString.range(of: $0)
            attributedString.addAttributes(attributes, range: range)
        }
        self.attributedText = attributedString
    }

    /// 라벨 내 특정 문자열의 CGRect 반환
    /// - Parameter subText: CGRect값을 알고 싶은 특정 문자열
    func boundingRectForCharacterRange(subText: String) -> CGRect? {
        guard let attributedText = attributedText else { return nil }
        guard let text = self.text else { return nil }

        // 전체 텍스트(text)에서 subText만큼의 range를 구합니다.
        guard let subRange = text.range(of: subText) else { return nil }
        let range = NSRange(subRange, in: text)

        // attributedText를 기반으로 한 NSTextStorage를 선언하고 NSLayoutManager를 추가합니다.
        let layoutManager = NSLayoutManager()
        let textStorage = NSTextStorage(attributedString: attributedText)
        textStorage.addLayoutManager(layoutManager)

        // instrinsicContentSize를 기반으로 NSTextContainer를 선언하고
        let textContainer = NSTextContainer(size: intrinsicContentSize)
        // 정확한 CGRect를 구해야하므로 padding 값은 0을 줍니다.
        textContainer.lineFragmentPadding = 0.0
        // layoutManager에 추가합니다.
        layoutManager.addTextContainer(textContainer)

        var glyphRange = NSRange()
        // 주어진 범위(rage)에 대한 실질적인 glyphRange를 구합니다.
        layoutManager.characterRange(
            forGlyphRange: range,
            actualGlyphRange: &glyphRange
        )

        // textContainer 내의 지정된 glyphRange에 대한 CGRect 값을 반환합니다.
        return layoutManager.boundingRect(
            forGlyphRange: glyphRange,
            in: textContainer
        )
    }
}

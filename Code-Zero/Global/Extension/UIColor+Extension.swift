//
//  UIColor+Extension.swift
//  Code-Zero
//
//  Created by 이주혁 on 2021/10/30.
//

import UIKit.UIColor

// MARK: - Method
extension UIColor {

    // swiftlint:disable identifier_name
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: alpha
        )
    }
    // swiftlint:enable identifier_name
}

// MARK: - Color Constants
extension UIColor {
    @nonobjc class var lightGray1: UIColor {
        return UIColor(red: 245.0 / 255.0, green: 244.0 / 255.0, blue: 241.0 / 255.0, alpha: 1.0)
      }

      @nonobjc class var gray2: UIColor {
        return UIColor(red: 175.0 / 255.0, green: 170.0 / 255.0, blue: 163.0 / 255.0, alpha: 1.0)
      }

      @nonobjc class var lightGray3: UIColor {
        return UIColor(red: 224.0 / 255.0, green: 219.0 / 255.0, blue: 211.0 / 255.0, alpha: 1.0)
      }

      @nonobjc class var white: UIColor {
        return UIColor(white: 1.0, alpha: 1.0)
      }

      @nonobjc class var lightGray2: UIColor {
        return UIColor(red: 237.0 / 255.0, green: 234.0 / 255.0, blue: 228.0 / 255.0, alpha: 1.0)
      }

      @nonobjc class var gray1: UIColor {
        return UIColor(red: 193.0 / 255.0, green: 187.0 / 255.0, blue: 177.0 / 255.0, alpha: 1.0)
      }

      @nonobjc class var gray3: UIColor {
        return UIColor(red: 136.0 / 255.0, green: 131.0 / 255.0, blue: 124.0 / 255.0, alpha: 1.0)
      }

      @nonobjc class var gray4: UIColor {
        return UIColor(red: 104.0 / 255.0, green: 97.0 / 255.0, blue: 86.0 / 255.0, alpha: 1.0)
      }

      @nonobjc class var darkGray2: UIColor {
        return UIColor(red: 57.0 / 255.0, green: 55.0 / 255.0, blue: 49.0 / 255.0, alpha: 1.0)
      }

      @nonobjc class var darkGray1: UIColor {
        return UIColor(red: 78.0 / 255.0, green: 71.0 / 255.0, blue: 61.0 / 255.0, alpha: 1.0)
      }

      @nonobjc class var black: UIColor {
        return UIColor(red: 21.0 / 255.0, green: 20.0 / 255.0, blue: 18.0 / 255.0, alpha: 1.0)
      }

      @nonobjc class var orangeMain: UIColor {
        return UIColor(red: 1.0, green: 130.0 / 255.0, blue: 14.0 / 255.0, alpha: 1.0)
      }

      @nonobjc class var redAlert: UIColor {
        return UIColor(red: 1.0, green: 84.0 / 255.0, blue: 30.0 / 255.0, alpha: 1.0)
      }

      @nonobjc class var greenCalendar: UIColor {
        return UIColor(red: 140.0 / 255.0, green: 159.0 / 255.0, blue: 95.0 / 255.0, alpha: 1.0)
      }

      @nonobjc class var blueCalendar: UIColor {
        return UIColor(red: 167.0 / 255.0, green: 211.0 / 255.0, blue: 224.0 / 255.0, alpha: 1.0)
      }

      @nonobjc class var purpleCalendar: UIColor {
        return UIColor(red: 170.0 / 255.0, green: 123.0 / 255.0, blue: 217.0 / 255.0, alpha: 1.0)
      }

      @nonobjc class var redCalendar: UIColor {
        return UIColor(red: 228.0 / 255.0, green: 107.0 / 255.0, blue: 80.0 / 255.0, alpha: 1.0)
      }

      @nonobjc class var pinkCalender: UIColor {
        return UIColor(red: 228.0 / 255.0, green: 125.0 / 255.0, blue: 181.0 / 255.0, alpha: 1.0)
      }

      @nonobjc class var surface: UIColor {
        return UIColor(red: 1.0, green: 253.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
      }

      @nonobjc class var yellowCalendar: UIColor {
        return UIColor(red: 229.0 / 255.0, green: 187.0 / 255.0, blue: 36.0 / 255.0, alpha: 1.0)
      }
}

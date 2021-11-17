//
//  TodayCalendarCell.swift
//  Code-Zero
//
//  Created by 미니 on 2021/11/13.
//

import UIKit
import FSCalendar

class TodayCalendarCell: FSCalendarCell {

    weak var underLine: UIView!

    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {

        super.init(frame: frame)
        let underLine: UIView = UIView()
        self.contentView.insertSubview(underLine, at: 0)
        self.underLine = underLine
        self.underLine.backgroundColor = .white
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.underLine.frame = self.contentView.bounds
        self.underLine.frame = CGRect(x: self.contentView.frame.width/2-5,
                                      y: self.contentView.frame.height/2 + 5,
                                      width: 10,
                                      height: 2)

    }
}

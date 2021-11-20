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

    var selectionType: SelectedType = .none {
        didSet {
            setNeedsLayout()
        }
    }

    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {

        super.init(frame: frame)
        let underLine: UIView = UIView()
        self.contentView.insertSubview(underLine, at: 1) // 지정한 인덱스의 view 삽입
        self.underLine = underLine
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.underLine.frame = self.contentView.bounds
        self.underLine.frame = CGRect(x: self.contentView.frame.width/2-5,
                                      y: self.contentView.frame.height/2 + 5,
                                      width: 10,
                                      height: 2)

        if selectionType == .none {
            self.titleLabel.textColor = .gray1
            self.underLine.backgroundColor = .white
        }

        if selectionType == .selected {
            self.titleLabel.textColor = .darkGray2
            self.underLine.backgroundColor = .darkGray2
        }

    }
}

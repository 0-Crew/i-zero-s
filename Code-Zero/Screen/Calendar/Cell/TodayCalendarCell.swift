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

    internal var selectionType: SelectedType = .none {
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
        contentView.insertSubview(underLine, at: 1) // 지정한 인덱스의 view 삽입
        self.underLine = underLine
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        underLine.frame = contentView.bounds
        underLine.frame = CGRect(x: contentView.frame.width/2-5,
                                 y: contentView.frame.height/2 + 5,
                                 width: 10,
                                 height: 2)

        switch selectionType {
        case .none:
            titleLabel.textColor = .gray1
            underLine.backgroundColor = .white
        case .selected:
            titleLabel.textColor = .darkGray2
            underLine.backgroundColor = .darkGray2
        case .challenge(_):
            break
        }
    }
}

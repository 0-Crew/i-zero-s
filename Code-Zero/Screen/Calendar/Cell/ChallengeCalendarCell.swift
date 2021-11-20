//
//  ChallengeCalendarCell.swift
//  Code-Zero
//
//  Created by 미니 on 2021/11/13.
//

import Foundation
import FSCalendar

class ChallengeCalendarCell: FSCalendarCell {

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

        let view = UIView(frame: self.bounds)
        self.backgroundView = view

    }

    override func configureAppearance() {
        super.configureAppearance()

        if self.isPlaceholder { // 현재 달력에 보이는 이전 달, 다음 달 날짜들
            self.titleLabel.textColor = .gray4
        } else { // 이번달 날짜들
            self.titleLabel.textColor = .gray3
        }
    }
}

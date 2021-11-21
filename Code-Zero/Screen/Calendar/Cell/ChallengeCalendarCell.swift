//
//  ChallengeCalendarCell.swift
//  Code-Zero
//
//  Created by 미니 on 2021/11/13.
//

import Foundation
import FSCalendar

enum SelectionBoarderType: Int {
    case none
    case leftBorder
    case middle
    case rightBorder
}

class ChallengeCalendarCell: FSCalendarCell {

    weak var selectionLayer: CAShapeLayer!

    var selectionBoarderType: SelectionBoarderType = .none {
        didSet {
            setNeedsLayout()
        }
    }

    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {

        super.init(frame: frame)

        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = UIColor.orange.cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
        self.selectionLayer = selectionLayer

        self.shapeLayer.isHidden = true

        let view = UIView(frame: self.bounds)
        self.backgroundView = view

    }

    override func layoutSubviews() {

        super.layoutSubviews()
        self.selectionLayer.frame = self.contentView.bounds

        switch selectionBoarderType {

        case .middle:
            self.selectionLayer.path = UIBezierPath(rect: self.selectionLayer.bounds).cgPath

        case .leftBorder:
            let cornerRadii: CGSize = CGSize(width: self.selectionLayer.frame.width / 2,
                                             height: self.selectionLayer.frame.width / 2)
            self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds,
                                                    byRoundingCorners: [.topLeft, .bottomLeft],
                                                    cornerRadii: cornerRadii).cgPath

        case .rightBorder:
            let cornerRadii: CGSize = CGSize(width: self.selectionLayer.frame.width / 2,
                                             height: self.selectionLayer.frame.width / 2)
            self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds,
                                                    byRoundingCorners: [.topRight, .bottomRight],
                                                    cornerRadii: cornerRadii).cgPath

        default: break

        }

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

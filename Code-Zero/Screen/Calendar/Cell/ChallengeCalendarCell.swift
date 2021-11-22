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
    case bothBorder
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
        selectionLayer.fillColor = UIColor.redCalendar.cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
        self.selectionLayer = selectionLayer

        self.shapeLayer.isHidden = true

        let view = UIView(frame: self.bounds)
        self.backgroundView = view

    }

    override func layoutSubviews() {

        super.layoutSubviews()


        switch selectionBoarderType {

        case .middle:
            self.selectionLayer.frame = CGRect(x: contentView.bounds.minX,
                                               y: contentView.bounds.minY,
                                               width: contentView.bounds.width,
                                               height: contentView.bounds.height-3)
            self.selectionLayer.path = UIBezierPath(rect: self.selectionLayer.bounds).cgPath
            self.selectionLayer.isHidden = false
            self.titleLabel.textColor = .white

        case .leftBorder:
            self.selectionLayer.frame = CGRect(x: contentView.bounds.minX+5,
                                               y: contentView.bounds.minY,
                                               width: contentView.bounds.width,
                                               height: contentView.bounds.height-3)
            let cornerRadii: CGSize = CGSize(width: self.selectionLayer.frame.width / 2,
                                             height: self.selectionLayer.frame.width / 2)
            self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds,
                                                    byRoundingCorners: [.topLeft, .bottomLeft],
                                                    cornerRadii: cornerRadii).cgPath
            self.selectionLayer.isHidden = false
            self.titleLabel.textColor = .white

        case .rightBorder:
            self.selectionLayer.frame = CGRect(x: contentView.bounds.minX-5,
                                               y: contentView.bounds.minY,
                                               width: contentView.bounds.width,
                                               height: contentView.bounds.height-3)
            let cornerRadii: CGSize = CGSize(width: self.selectionLayer.frame.width / 2,
                                             height: self.selectionLayer.frame.width / 2)
            self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds,
                                                    byRoundingCorners: [.topRight, .bottomRight],
                                                    cornerRadii: cornerRadii).cgPath
            self.selectionLayer.isHidden = false
            self.titleLabel.textColor = .white

        case .bothBorder:
            self.selectionLayer.frame = CGRect(x: contentView.bounds.minX+4,
                                               y: contentView.bounds.minY,
                                               width: contentView.bounds.width-8,
                                               height: contentView.bounds.height-3)
            let cornerRadii: CGSize = CGSize(width: self.selectionLayer.frame.width / 2,
                                             height: self.selectionLayer.frame.width / 2)
            self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds,
                                                    byRoundingCorners: [.topRight, .bottomRight,
                                                                        .topLeft, .bottomLeft],
                                                    cornerRadii: cornerRadii).cgPath
            self.selectionLayer.isHidden = false
            self.titleLabel.textColor = .white

        default:
            self.selectionLayer.isHidden = true

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

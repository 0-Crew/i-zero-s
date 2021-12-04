//
//  ChallengeCalendarCell.swift
//  Code-Zero
//
//  Created by 미니 on 2021/11/13.
//

import Foundation
import FSCalendar
import UIKit

enum CalendarBoarderType: Equatable {
    case none
    case leftBorder(color: Int)
    case middle(color: Int)
    case rightBorder(color: Int)
    case bothBorder(color: Int)

    var cellTextColor: UIColor {
        switch self {
        case .none: return .gray3
        default: return .gray1
        }
    }
}
enum SelectedType: Equatable {
    case days(_ borderType: CalendarBoarderType)
    case today(_ borderType: CalendarBoarderType)
}

class ChallengeCalendarCell: FSCalendarCell {

    // MARK: - Property
    var cellDayType: SelectedType = .days(.none) {
        didSet {
            setNeedsLayout()
            if case .days = cellDayType {
                underLine.isHidden = true
            } else {
                underLine.isHidden = false
            }
        }
    }
    var isClick: Bool = false {
        didSet {
            selectionFillLayer.isHidden = !isClick
            underLine.backgroundColor = isClick ? .darkGray2 : .white
        }
    }
    var fillColor: UIColor = .clear {
        didSet {
            selectionFillLayer.fillColor = fillColor.cgColor
        }
    }
    private lazy var selectionFillLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.redCalendar.cgColor
        layer.actions = ["hidden": NSNull()]
        layer.isHidden = true
        contentView.layer.insertSublayer(layer, below: self.titleLabel!.layer)
        return layer
    }()
    private lazy var topBorderLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.actions = ["hidden": NSNull()]
        layer.lineWidth = 1
        layer.strokeColor = UIColor.yellowCalendar.cgColor
        contentView.layer.insertSublayer(layer, below: self.titleLabel!.layer)
        layer.isHidden = true
        return layer
    }()
    private lazy var bottomBorderLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.actions = ["hidden": NSNull()]
        layer.lineWidth = 1
        layer.strokeColor = UIColor.yellowCalendar.cgColor
        contentView.layer.insertSublayer(layer, below: self.titleLabel!.layer)
        layer.isHidden = true
        return layer
    }()
    weak var underLine: UIView!
    private let colorChip: [UIColor] = [.yellowCalendar, .greenCalendar, .redCalendar,
                                        .blueCalendar, .purpleCalendar, .pinkCalender]

    // MARK: - Override Function
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)

        let view = UIView(frame: self.bounds)
        backgroundView = view

        let underLine: UIView = UIView()
        contentView.insertSubview(underLine, at: 2) // 지정한 인덱스의 view 삽입
        self.underLine = underLine
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        underLine.frame = CGRect(x: contentView.frame.width/2-5,
                                 y: contentView.frame.height/2 + 5,
                                 width: 10,
                                 height: 2)
        switch cellDayType {
        case .days(let border):
            setBorderType(border: border)
            setLayerHidden(border: border)
        case .today(let border):
            setBorderType(border: border)
            setLayerHidden(border: border)
        }
        setDayTextColor()
        if self.isPlaceholder { // 현재 달력에 보이는 이전 달, 다음 달 날짜들
            self.titleLabel.textColor = .gray4
        }
    }

    // MARK: - Style Setting Function
    private func setLayerHidden(border: CalendarBoarderType) {
        switch border {
        case .none:
            topBorderLayer.isHidden = true
            selectionFillLayer.isHidden = true
            bottomBorderLayer.isHidden = true
        case .middle:
            topBorderLayer.isHidden = false
            bottomBorderLayer.isHidden = false
        default:
            topBorderLayer.isHidden = false
            bottomBorderLayer.isHidden = true
        }
    }
    private func setDayTextColor() {
        switch cellDayType {
        case .today:
            titleLabel.textColor = isClick ? .darkGray2 : .gray1
        case .days(let border):
            switch border {
            case .none:
                titleLabel.textColor = .gray3
            default:
                titleLabel.textColor = isClick ? .white : .gray1
            }
        }
    }
    private func setChallengeColor(colorNumber: Int) -> UIColor {
        return colorNumber == -1 ? .orangeMain : colorChip[colorNumber%7]
    }
    private func getLayerFrame(xPoint: CGFloat, yPoint: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
        return  CGRect(x: contentView.bounds.minX + xPoint,
                       y: contentView.bounds.minY + yPoint,
                       width: contentView.bounds.width + width,
                       height: contentView.bounds.height + height)
    }
    private func setStrokeStyle(layer: CAShapeLayer,
                                startPoint: CGFloat,
                                endPoint: CGFloat,
                                strokeColor: UIColor) {
        layer.strokeColor = strokeColor.cgColor
        layer.strokeStart = startPoint
        layer.strokeEnd = endPoint
    }
    private func setBorderType(border: CalendarBoarderType) {
        switch border {
        case .none:
            break
        case .leftBorder(let color):
            let layerFrame = getLayerFrame(xPoint: 3, yPoint: 0, width: 13, height: -3)
            let cornerRadii: CGSize = CGSize(width: layerFrame.width / 2,
                                             height: layerFrame.width / 2)
            fillColor = setChallengeColor(colorNumber: color)
            [topBorderLayer, selectionFillLayer].forEach {
                $0.frame = layerFrame
                $0.path = UIBezierPath(roundedRect: $0.bounds,
                                       byRoundingCorners: [.topLeft, .bottomLeft],
                                       cornerRadii: cornerRadii).cgPath
            }
            setStrokeStyle(layer: topBorderLayer, startPoint: 0.3, endPoint: 1, strokeColor: fillColor)
        case .middle(let color):
            fillColor = color == -1 ? UIColor.orangeMain : colorChip[color]
            [topBorderLayer, bottomBorderLayer, selectionFillLayer].forEach {
                $0.frame = getLayerFrame(xPoint: 0, yPoint: 0, width: 2, height: -3)
                $0.path = UIBezierPath(rect: $0.bounds).cgPath
            }
            setStrokeStyle(layer: topBorderLayer, startPoint: 0, endPoint: 0.29, strokeColor: fillColor)
            setStrokeStyle(layer: bottomBorderLayer, startPoint: 0.5, endPoint: 0.79, strokeColor: fillColor)
            selectionFillLayer.fillColor = fillColor.cgColor
        case .rightBorder(let color):
            let layerFrame = getLayerFrame(xPoint: -5, yPoint: 0, width: 0, height: -3)
            let cornerRadii: CGSize = CGSize(width: layerFrame.width / 2,
                                             height: layerFrame.width / 2)
            fillColor = setChallengeColor(colorNumber: color)
            [topBorderLayer, selectionFillLayer].forEach {
                $0.frame = layerFrame
                $0.path = UIBezierPath(roundedRect: $0.bounds,
                                       byRoundingCorners: [.topRight, .bottomRight],
                                       cornerRadii: cornerRadii).cgPath
            }
            setStrokeStyle(layer: topBorderLayer, startPoint: 0, endPoint: 0.77, strokeColor: fillColor)
        case .bothBorder(let color):
            let layerFrame = getLayerFrame(xPoint: 4, yPoint: 0, width: -8, height: -3)
            let cornerRadii: CGSize = CGSize(width: layerFrame.width / 2,
                                             height: layerFrame.width / 2)
            fillColor = setChallengeColor(colorNumber: color)
            [topBorderLayer, selectionFillLayer].forEach {
                $0.frame = layerFrame
                $0.path = UIBezierPath(roundedRect: $0.bounds,
                                       byRoundingCorners: [.topRight, .bottomRight,
                                                           .topLeft, .bottomLeft],
                                       cornerRadii: cornerRadii).cgPath
            }
            setStrokeStyle(layer: topBorderLayer, startPoint: 0, endPoint: 1, strokeColor: fillColor)
        }
    }
}

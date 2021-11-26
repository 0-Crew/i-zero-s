//
//  ChallengeCalendarCell.swift
//  Code-Zero
//
//  Created by 미니 on 2021/11/13.
//

import Foundation
import FSCalendar
import UIKit

enum CalendarBoarderType {
    case none
    case leftBorder(color: Int)
    case middle(color: Int)
    case rightBorder(color: Int)
    case bothBorder(color: Int)
}

enum SelectedType {
    case days
    case today
}

class ChallengeCalendarCell: FSCalendarCell {

    // MARK: - Property
    var cellBoarderType: CalendarBoarderType = .none {
        didSet {
            setNeedsLayout()
        }
    }
    var cellDayType: SelectedType = .days {
        didSet {
            setNeedsLayout()
            underLine.isHidden = cellDayType == .days ? true : false
        }
    }
    var isClick: Bool = false {
        didSet {
            selectionFillLayer.isHidden = !isClick
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
    private lazy var underLine: UIView = {
        let view = UIView()
//        contentView.insertSubview(view, at: 1)
        view.backgroundColor = .red
        underLine.isHidden = true
        return view
    }()
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
    }

    // Lint issue: Function Body Length Violation: Function body should span 40 lines or less excluding comments and whitespace: currently spans 76 lines (function_body_length)
    override func layoutSubviews() {
        super.layoutSubviews()

        topBorderLayer.isHidden = false
        bottomBorderLayer.isHidden = true
        contentView.insertSubview(underLine, at: 2)

        underLine.frame = contentView.bounds
        underLine.frame = CGRect(x: contentView.frame.width/2-5,
                                 y: contentView.frame.height/2 + 5,
                                 width: 10,
                                 height: 2)

        switch cellBoarderType {
        case .middle(let colorNumber):
            let layerFrame = CGRect(x: contentView.bounds.minX + 0,
                                    y: contentView.bounds.minY + 0,
                                    width: contentView.bounds.width + 0,
                                    height: contentView.bounds.height - 3)
            [topBorderLayer, bottomBorderLayer, selectionFillLayer].forEach {
                $0.frame = layerFrame
                $0.path = UIBezierPath(rect: $0.bounds).cgPath
            }

            setStrokeStyle(layer: topBorderLayer,
                           startPoint: 0,
                           endPoint: 0.29,
                           strokeColor: colorChip[colorNumber])
            setStrokeStyle(layer: bottomBorderLayer,
                           startPoint: 0.5,
                           endPoint: 0.79,
                           strokeColor: colorChip[colorNumber])
            setFillLayerStyle(fillColor: colorChip[colorNumber], textColor: .white)

            bottomBorderLayer.isHidden = false
        case .leftBorder(let colorNumber):
            let layerFrame = CGRect(x: contentView.bounds.minX+3,
                                      y: contentView.bounds.minY,
                                      width: contentView.bounds.width+13,
                                      height: contentView.bounds.height-3)
            let cornerRadii: CGSize = CGSize(width: layerFrame.width / 2,
                                             height: layerFrame.width / 2)
            [topBorderLayer, selectionFillLayer].forEach {
                $0.frame = layerFrame
                $0.path = UIBezierPath(roundedRect: $0.bounds,
                                       byRoundingCorners: [.topLeft, .bottomLeft],
                                       cornerRadii: cornerRadii).cgPath
            }
            setStrokeStyle(layer: topBorderLayer,
                           startPoint: 0.3,
                           endPoint: 1,
                           strokeColor: colorChip[colorNumber])
            setFillLayerStyle(fillColor: colorChip[colorNumber], textColor: .white)
        case .rightBorder(let colorNumber):
            let layerFrame = CGRect(x: contentView.bounds.minX-5,
                                    y: contentView.bounds.minY,
                                    width: contentView.bounds.width,
                                    height: contentView.bounds.height-3)
            let cornerRadii: CGSize = CGSize(width: layerFrame.width / 2,
                                             height: layerFrame.width / 2)

            [topBorderLayer, selectionFillLayer].forEach {
                $0.frame = layerFrame
                $0.path = UIBezierPath(roundedRect: $0.bounds,
                                       byRoundingCorners: [.topRight, .bottomRight],
                                       cornerRadii: cornerRadii).cgPath
            }

            setStrokeStyle(layer: topBorderLayer,
                           startPoint: 0,
                           endPoint: 0.77,
                           strokeColor: colorChip[colorNumber])
            setFillLayerStyle(fillColor: colorChip[colorNumber], textColor: .white)
        case .bothBorder(let colorNumber):
            let layerFrame = CGRect(x: contentView.bounds.minX+4,
                                    y: contentView.bounds.minY,
                                    width: contentView.bounds.width-8,
                                    height: contentView.bounds.height-3)
            let cornerRadii: CGSize = CGSize(width: layerFrame.width / 2,
                                             height: layerFrame.width / 2)

            [topBorderLayer, selectionFillLayer].forEach {
                $0.frame = layerFrame
                $0.path = UIBezierPath(roundedRect: $0.bounds,
                                       byRoundingCorners: [.topRight, .bottomRight,
                                                           .topLeft, .bottomLeft],
                                       cornerRadii: cornerRadii).cgPath
            }
            setStrokeStyle(layer: topBorderLayer,
                           startPoint: 0,
                           endPoint: 1,
                           strokeColor: colorChip[colorNumber])
            setFillLayerStyle(fillColor: colorChip[colorNumber], textColor: .white)
        case .none:
            topBorderLayer.isHidden = true
            selectionFillLayer.isHidden = true
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

    // MARK: - Style Setting Function
    private func setStrokeLayerFrame(xPoint: CGFloat, yPoint: CGFloat, width: CGFloat, height: CGFloat,
                                     path: CGPath) {

        topBorderLayer.frame = CGRect(x: contentView.bounds.minX + xPoint,
                                                    y: contentView.bounds.minY + yPoint,
                                                    width: contentView.bounds.width + width,
                                                    height: contentView.bounds.height + height)
        topBorderLayer.path = path
    }

    private func setStrokeStyle(layer: CAShapeLayer,
                                startPoint: CGFloat,
                                endPoint: CGFloat,
                                strokeColor: UIColor) {
        layer.strokeColor = strokeColor.cgColor
        layer.strokeStart = startPoint
        layer.strokeEnd = endPoint
    }

    private func setFillLayerStyle(fillColor: UIColor, textColor: UIColor) {
        selectionFillLayer.fillColor = fillColor.cgColor
        titleLabel.textColor = textColor
    }
}

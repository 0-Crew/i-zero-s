//
//  AlarmCell.swift
//  Code-Zero
//
//  Created by 주혁 on 2022/04/26.
//

import UIKit

enum AlarmType: String {
    case normal
    case cheer
    case congrats
    case beCheered
    case beCongratulated
    case totalCheered
    case totalCongratulated
}

extension AlarmType {
    var alarmImage: UIImage? {
        switch self {
        case .cheer, .beCheered:
            return UIImage(named: "icAlarmCheer")
        case .congrats, .beCongratulated:
            return UIImage(named: "icAlarmCeleb")
        default:
            return nil
        }
    }
    var subActionButtonIsHidden: Bool {
        switch self {
        case .cheer, .congrats:
            return false
        default:
            return true
        }
    }

    var subActionButtonTitle: String {
        switch self {
        case .cheer:
            return "응원하기"
        case .congrats:
            return "축하하기"
        default:
            return ""
        }
    }
}

protocol AlarmCellDelegate: AnyObject {
    func subActionButtonDidTap(cellType: AlarmType, offset: Int)
}

class AlarmCell: UITableViewCell {

    private var cellType: AlarmType!

    internal var offset: Int! = 0
    internal weak var delegate: AlarmCellDelegate?

    @IBOutlet weak var alarmImageView: UIImageView!
    @IBOutlet weak var defaultProfileLabel: UILabel!
    @IBOutlet weak var alarmTextLabel: UILabel!
    @IBOutlet weak var timelineLabel: UILabel!
    @IBOutlet weak var subActionButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) { }

    private func configureCell() {
        alarmImageView.makeRounded(cornerRadius: 36 / 2)
    }

    internal func bindData(notification: NotificationData) {
        let type = notification.alarmType
        let text = notification.notiText
        let nickName = notification.sentUser.name
        let nickNameFirstLetter = nickName.map {"\($0)"}.first ?? ""

        cellType = type
        alarmImageView.image = type.alarmImage
        defaultProfileLabel.text = type == .normal ? nickNameFirstLetter : ""
        subActionButton.isHidden = type.subActionButtonIsHidden
        subActionButton.setTitle(type.subActionButtonTitle, for: .normal)
        alarmTextLabel.text = text
        alarmTextLabel.setFontWith(font: .spoqaHanSansNeo(size: 14, family: .bold), in: [nickName])
        if let timelineText = notification.updatedAt.toDate()?.getTimeLineDate() {
            timelineLabel.text = "\(timelineText) 전"
        } else {
            timelineLabel.text = ""
        }

    }

    @IBAction func subActionButtonDidTap() {
        delegate?.subActionButtonDidTap(cellType: cellType, offset: offset)
    }
}

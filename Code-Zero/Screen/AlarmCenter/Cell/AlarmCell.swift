//
//  AlarmCell.swift
//  Code-Zero
//
//  Created by 주혁 on 2022/04/26.
//

import UIKit

enum AlarmType {
    case normal
    case cheerUp
    case celebrate
    case beCheered
    case beCelebrated
    case totalCheeredUp
    case totalCelebrated
}

extension AlarmType {
    var alarmImage: UIImage? {
        switch self {
        case .cheerUp, .beCheered:
            return UIImage(named: "icAlarmCheer")
        case .celebrate, .beCelebrated:
            return UIImage(named: "icAlarmCeleb")
        default:
            return nil
        }
    }
    var subActionButtonIsHidden: Bool {
        switch self {
        case .cheerUp, .celebrate:
            return false
        default:
            return true
        }
    }

    var subActionButtonTitle: String {
        switch self {
        case .cheerUp:
            return "응원하기"
        case .celebrate:
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

    internal func bindData(type: AlarmType = .normal, text: String) {
        cellType = type
        alarmImageView.image = type.alarmImage
        defaultProfileLabel.text = type == .normal ? "박" : ""
        subActionButton.isHidden = type.subActionButtonIsHidden
        subActionButton.setTitle(type.subActionButtonTitle, for: .normal)
        alarmTextLabel.text = text
    }

    @IBAction func subActionButtonDidTap() {
        delegate?.subActionButtonDidTap(cellType: cellType, offset: offset)
    }
}

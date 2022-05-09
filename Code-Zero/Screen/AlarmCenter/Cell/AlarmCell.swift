//
//  AlarmCell.swift
//  Code-Zero
//
//  Created by 주혁 on 2022/04/26.
//

import UIKit

enum AlarmCellType {
    case normal
    case cheerUp
    case celebrate
}

extension AlarmCellType {
    var subActionButtonIsHidden: Bool {
        switch self {
        case .normal:
            return true
        case .cheerUp, .celebrate:
            return false
        }
    }

    var subActionButtonTitle: String {
        switch self {
        case .normal:
            return ""
        case .cheerUp:
            return "응원하기"
        case .celebrate:
            return "축하하기"
        }
    }
}

protocol AlarmCellDelegate {
    func subActionButtonDidTap(cellType: AlarmCellType)
}

class AlarmCell: UITableViewCell {

    private var cellType: AlarmCellType!

    internal var delegate: AlarmCellDelegate?

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var defaultProfileLabel: UILabel!
    @IBOutlet weak var alarmTextLabel: UILabel!
    @IBOutlet weak var timelineLabel: UILabel!
    @IBOutlet weak var subActionButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
        // Initialization code
    }

    private func configureCell() {
        profileImageView.makeRounded(cornerRadius: 36 / 2)
    }

    internal func bindData(type: AlarmCellType = .normal, text: String) {
        cellType = type
        subActionButton.isHidden = type.subActionButtonIsHidden
        subActionButton.setTitle(type.subActionButtonTitle, for: .normal)
        alarmTextLabel.text = text
    }

    @IBAction func subActionButtonDidTap() {
        delegate?.subActionButtonDidTap(cellType: cellType)
    }

}

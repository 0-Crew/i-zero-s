//
//  OptionCell.swift
//  Code-Zero
//
//  Created by 주혁 on 2021/11/26.
//

import UIKit

class OptionCell: UITableViewCell {
    enum CellType {
        case challenge
        case challengeOpen
    }
    let optionTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray1
        label.font = .spoqaHanSansNeo(size: 12, family: .medium)
        return label
    }()
    internal var cellType: CellType!

    // MARK: - Lifecycle Method
    override func awakeFromNib() {
        super.awakeFromNib()
        initLayout()
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initLayout()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initLayout()
    }
    private func initLayout() {
        contentView.addSubview(optionTextLabel)
        optionTextLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(-5)
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().offset(-17)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if cellType == .challenge { return }
        if selected {
            optionTextLabel.font = .spoqaHanSansNeo(size: 14, family: .bold)
        } else {
            optionTextLabel.font = .spoqaHanSansNeo(size: 14, family: .medium)
        }
    }
    internal func setCellType(type: CellType) {
        cellType = type
        if type == .challenge {
            selectionStyle = .none
            selectedBackgroundView = nil
        } else {
            selectionStyle = .default
            let highlightingView: UIView = .init()
            highlightingView.backgroundColor = .lightGray1
            selectedBackgroundView = highlightingView
        }
    }
}

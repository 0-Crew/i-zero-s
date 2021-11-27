//
//  OptionCell.swift
//  Code-Zero
//
//  Created by 주혁 on 2021/11/26.
//

import UIKit

class OptionCell: UITableViewCell {
    let optionTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray1
        label.font = .spoqaHanSansNeo(size: 12, family: .medium)
        return label
    }()
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
        selectionStyle = .none
        contentView.addSubview(optionTextLabel)
        optionTextLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(-5)
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().offset(-17)
        }
    }
}

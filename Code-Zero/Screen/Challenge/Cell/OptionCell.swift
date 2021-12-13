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
    let selectedColorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray1
        return view
    }()
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
        selectionStyle = .none
        contentView.addSubview(selectedColorView)
        selectedColorView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().offset(-13)
        }
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
        selectedColorView.isHidden = !selected
        let fontFamily: UIFont.Family = selected ? .bold : .medium
        optionTextLabel.font = .spoqaHanSansNeo(size: 14, family: fontFamily)
    }
    internal func setCellType(type: CellType) {
        cellType = type
    }
}

//
//  TopTabBarCell.swift
//  Code-Zero
//
//  Created by 미니 on 2021/12/05.
//

import UIKit

class TopTabBarCell: UICollectionViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override var isSelected: Bool {
        didSet{
            self.titleLabel.textColor = isSelected ? .orangeMain : .gray2
            self.titleLabel.font = isSelected
            ? .spoqaHanSansNeo(size: 14, family: .bold) : .spoqaHanSansNeo(size: 14, family: .medium)
        }
    }
}

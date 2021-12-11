//
//  BottleWorldListCell.swift
//  Code-Zero
//
//  Created by Hailey on 2021/12/03.
//

import UIKit
import SnapKit
class BottleWorldListCell: UICollectionViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchResultView: UIView!

    var emptyView = FollowEmptyView(frame: .zero)

    // MARK: - Override Fucntion
    override func awakeFromNib() {
        super.awakeFromNib()
        setView()
        setResultView()
    }

    // MARK: - Style Set Function
    private func setView() {
        self.backgroundColor = .white
        searchView.makeRounded(cornerRadius: 10)
        searchButton.titleLabel?.text = ""
    }
    private func setResultView() {
        searchResultView.addSubview(emptyView)
        emptyView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(searchResultView.snp.height)
            $0.width.equalTo(searchResultView.snp.width)
        }
    }

}

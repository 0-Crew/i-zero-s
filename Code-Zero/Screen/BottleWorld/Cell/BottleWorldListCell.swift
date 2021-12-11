//
//  BottleWorldListCell.swift
//  Code-Zero
//
//  Created by Hailey on 2021/12/03.
//

import UIKit

class BottleWorldListCell: UICollectionViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchResultView: UIView!

    // MARK: - Override Fucntion
    override func awakeFromNib() {
        super.awakeFromNib()
        setView()
    }

    // MARK: - Style Set Function
    private func setView() {
        self.backgroundColor = .white
        searchView.makeRounded(cornerRadius: 10)
        searchButton.titleLabel?.text = ""
    }

}

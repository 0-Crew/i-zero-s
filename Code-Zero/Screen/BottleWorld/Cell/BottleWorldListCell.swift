//
//  BottleWorldListCell.swift
//  Code-Zero
//
//  Created by Hailey on 2021/12/03.
//

import UIKit
import SnapKit

protocol BottleWorldUsersDelegate: AnyObject {
    func presentEmptyUserView()
    func presentUserListView()
}

class BottleWorldListCell: UICollectionViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchResultView: UIView!

    var emptyView = FollowEmptyView(frame: .zero)
    var userListView = UserListView(frame: .zero)

    @IBAction func searchButtonDidTap(_ sender: Any) {
        if let text = searchTextField.text {
            userListView.filteringText = text
        }
    }
    // MARK: - Override Fucntion
    override func awakeFromNib() {
        super.awakeFromNib()
        setView()
        setUserListView()
        searchTextField.delegate = self
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
    }

    // MARK: - Style Set Function
    private func setView() {
        self.backgroundColor = .white
        searchView.makeRounded(cornerRadius: 10)
        searchButton.setTitle("", for: .normal)
    }
    func setEmptyView() {
        searchResultView.addSubview(emptyView)
        emptyView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(searchResultView.snp.height)
            $0.width.equalTo(searchResultView.snp.width)
        }
    }
    func setUserListView() {
        searchResultView.addSubview(userListView)
        userListView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(searchResultView.snp.height)
            $0.width.equalTo(searchResultView.snp.width)
        }
        userListView.delegate = self
    }
}

extension BottleWorldListCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            userListView.filteringText = text
        }
        endEditing(true)
        return true
    }
}

// MARK: - BottleWorldUsersDelegate
extension BottleWorldListCell: BottleWorldUsersDelegate {
    func presentEmptyUserView() {
        userListView.removeFromSuperview()
        emptyView.removeFromSuperview()
        setEmptyView()
    }
    func presentUserListView() {
        emptyView.removeFromSuperview()
        userListView.removeFromSuperview()
        setUserListView()
    }
}

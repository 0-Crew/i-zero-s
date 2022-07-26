//
//  BottleWorldListCell.swift
//  Code-Zero
//
//  Created by Hailey on 2021/12/03.
//

import UIKit
import SnapKit

protocol BottleWorldSwipeBarDelegate: AnyObject {
    func fetchBarCount(type: UserListTapType, count: Int)
}

class BottleWorldListCell: UICollectionViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchResultView: UIView!

    // MARK: - Property
    var emptyView = FollowEmptyView(frame: .zero)
    var userListView = UserListView(frame: .zero)
    var tapType: UserListTapType = .lookAround {
        didSet {
            switch tapType {
            case .lookAround:
                fetchBrowserData(keyword: searchTextField.text)
            case .follower:
                fetchFollowerData(keyword: searchTextField.text)
            case .following:
                fetchFollowingData(keyword: searchTextField.text)
            }
        }
    }
    weak var delegate: BottleWorldSwipeBarDelegate?

    @IBAction func searchButtonDidTap(_ sender: Any) {
        if let text = searchTextField.text {
            switch tapType {
            case .lookAround:
                fetchBrowserData(keyword: text)
            case .follower:
                fetchFollowerData(keyword: text)
            case .following:
                fetchFollowingData(keyword: text)
            }
        }
    }
    // MARK: - Override Fucntion
    override func awakeFromNib() {
        super.awakeFromNib()
        setView()
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
        searchResultView.backgroundColor = .white
    }
    func setEmptyView(type: UserListTapType) {
        searchResultView.addSubview(emptyView)
        switch type {
        case .lookAround:
            emptyView.viewType = .noneSearch
        case .follower:
            emptyView.viewType = .noneFollower
        case .following:
            emptyView.viewType = .noneFollowing
        }
        emptyView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(searchResultView.snp.height)
            $0.width.equalTo(searchResultView.snp.width)
        }
    }
    func setUserListView(data: [BottleWorldUser]) {
        searchResultView.addSubview(userListView)
        userListView.userInfoData = data
        userListView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(searchResultView.snp.height)
            $0.width.equalTo(searchResultView.snp.width)
        }
    }
    func presentEmptyUserView(type: UserListTapType) {
        userListView.removeFromSuperview()
        emptyView.removeFromSuperview()
        setEmptyView(type: type)
    }
    func presentUserListView(data: [BottleWorldUser]) {
        emptyView.removeFromSuperview()
        userListView.removeFromSuperview()
        setUserListView(data: data)
    }
}

// MARK: - Network Function
extension BottleWorldListCell {
    private func fetchBrowserData(keyword: String?) {
        guard let token = UserDefaultManager.shared.accessToken else { return }
        BottleWorldService
            .shared
            .requestBottleWoldBrowser(token: token, keyword: keyword) { [weak self] result in
                switch result {
                case .success(let userData):
                    self?.resetTableViewData(type: .lookAround,
                                             keyword: keyword,
                                             data: userData)
                case .requestErr(let error):
                    print(error)
                case .serverErr:
                    break
                case .networkFail:
                    break
                }
            }
    }

    private func fetchFollowerData(keyword: String?) {
        guard let token = UserDefaultManager.shared.accessToken else { return }
        BottleWorldService
            .shared
            .requestBottleWoldFollower(token: token, keyword: keyword) { [weak self] result in
                switch result {
                case .success(let userData):
                    self?.resetTableViewData(type: .follower,
                                             keyword: keyword,
                                             data: userData)
                case .requestErr(let error):
                    print(error)
                case .serverErr:
                    break
                case .networkFail:
                    break
                }
            }
    }
    private func fetchFollowingData(keyword: String?) {
        guard let token = UserDefaultManager.shared.accessToken else { return }
        BottleWorldService
            .shared
            .requestBottleWoldFollowing(token: token, keyword: keyword) { [weak self] result in
                switch result {
                case .success(let userData):
                    self?.resetTableViewData(type: .following,
                                             keyword: keyword,
                                             data: userData)
                case .requestErr(let error):
                    print(error)
                case .serverErr:
                    break
                case .networkFail:
                    break
                }
            }
    }
    func resetTableViewData(type: UserListTapType, keyword: String?, data: [BottleWorldUser]) {
        if keyword == nil || keyword == "" {
            delegate?.fetchBarCount(type: type, count: data.count)
        }
        if keyword != "" && data.count == 0 {
            // No Search View 설정해줘야함
            presentEmptyUserView(type: .lookAround)
        } else {
            data.count == 0 ? presentEmptyUserView(type: type): presentUserListView(data: data)
        }

    }
}

extension BottleWorldListCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            switch tapType {
            case .lookAround:
                fetchBrowserData(keyword: text)
            case .follower:
                fetchFollowerData(keyword: text)
            case .following:
                fetchFollowingData(keyword: text)
            }
        }
        endEditing(true)
        return true
    }
}

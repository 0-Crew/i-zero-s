//
//  BottleWorldListCell.swift
//  Code-Zero
//
//  Created by Hailey on 2021/12/03.
//

import UIKit
import SnapKit

protocol BottleWorldSwipeBarDelegate: AnyObject {
    func fetchBarCount(followerCount: Int, followingCount: Int)
}

protocol BottleWorldUserClickDelegate: AnyObject {
    func showUserChallenge(id: Int)
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
    weak var swipeDelegate: BottleWorldSwipeBarDelegate?
    weak var userDelegate: BottleWorldUserClickDelegate?

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
        userListView.type = tapType
        userListView.delegate = self
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
    private func fetchBrowserData(keyword: String?, id: Int? = nil) {
        guard let token = UserDefaultManager.shared.accessToken else { return }
        BottleWorldService
            .shared
            .requestBottleWoldBrowser(token: token, keyword: keyword, id: id) { [weak self] result in
                switch result {
                case .success(let bottleWorldData):
                    self?.resetTableViewData(type: .lookAround,
                                             keyword: keyword,
                                             data: bottleWorldData.users,
                                             count: bottleWorldData.count)
                case .requestErr(let error):
                    print(error)
                case .serverErr:
                    break
                case .networkFail:
                    break
                }
            }
    }

    private func fetchFollowerData(keyword: String?, id: Int? = nil) {
        guard let token = UserDefaultManager.shared.accessToken else { return }
        BottleWorldService
            .shared
            .requestBottleWoldFollower(token: token, keyword: keyword, id: id) { [weak self] result in
                switch result {
                case .success(let bottleWorldData):
                    self?.resetTableViewData(type: .follower,
                                             keyword: keyword,
                                             data: bottleWorldData.followers,
                                             count: bottleWorldData.count)
                case .requestErr(let error):
                    print(error)
                case .serverErr:
                    break
                case .networkFail:
                    break
                }
            }
    }
    private func fetchFollowingData(keyword: String?, id: Int? = nil) {
        guard let token = UserDefaultManager.shared.accessToken else { return }
        BottleWorldService
            .shared
            .requestBottleWoldFollowing(token: token, keyword: keyword, id: id) { [weak self] result in
                switch result {
                case .success(let bottleWorldData):
                    self?.resetTableViewData(type: .following,
                                             keyword: keyword,
                                             data: bottleWorldData.follwings,
                                             count: bottleWorldData.count)
                case .requestErr(let error):
                    print(error)
                case .serverErr:
                    break
                case .networkFail:
                    break
                }
            }
    }
    func resetTableViewData(type: UserListTapType, keyword: String?, data: [BottleWorldUser], count: Count) {
        if keyword == nil || keyword == "" {
            swipeDelegate?.fetchBarCount(followerCount: count.follower, followingCount: count.following)
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

extension BottleWorldListCell: UserListViewDelegate {
    func didTapUser(userId: Int) {
        userDelegate?.showUserChallenge(id: userId)
    }

    func paging(type: UserListTapType, id: Int) {
        switch type {
        case .lookAround:
            fetchBrowserData(keyword: searchTextField.text, id: id)
        case .follower:
            fetchFollowerData(keyword: searchTextField.text, id: id)
        case .following:
            fetchFollowingData(keyword: searchTextField.text, id: id)
        }
    }

    func didRefresh(type: UserListTapType) {
        searchTextField.text = nil
        switch type {
        case .lookAround:
            fetchBrowserData(keyword: nil)
        case .follower:
            fetchFollowerData(keyword: nil)
        case .following:
            fetchFollowingData(keyword: nil)
        }
    }
}

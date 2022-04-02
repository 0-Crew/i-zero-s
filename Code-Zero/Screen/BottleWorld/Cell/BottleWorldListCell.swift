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
    func setEmptyView() {
        searchResultView.addSubview(emptyView)
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
    func presentEmptyUserView() {
        userListView.removeFromSuperview()
        emptyView.removeFromSuperview()
        setEmptyView()
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
        // swiftlint:disable line_length
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjAsImVtYWlsIjoieTR1cnRpam5makBwcml2YXRlcmVsYXkuYXBwbGVpZC5jb20iLCJuYW1lIjoi67SJ6rWs7Iqk67Cl66mNIiwiaWRGaXJlYmFzZSI6IkpoaW16VDdaUUxWcDhmakx3c1U5eWw1ZTNaeDIiLCJpYXQiOjE2NDg4ODUxNTEsImV4cCI6MTY1MTQ3NzE1MSwiaXNzIjoiV1lCIn0.0jdFo280vOl0zxU0BMqYRH8ztY1vWI75dOVyiKhGNsI"
        // swiftlint:enable line_length
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
        // swiftlint:disable line_length
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjAsImVtYWlsIjoieTR1cnRpam5makBwcml2YXRlcmVsYXkuYXBwbGVpZC5jb20iLCJuYW1lIjoi67SJ6rWs7Iqk67Cl66mNIiwiaWRGaXJlYmFzZSI6IkpoaW16VDdaUUxWcDhmakx3c1U5eWw1ZTNaeDIiLCJpYXQiOjE2NDg4ODUxNTEsImV4cCI6MTY1MTQ3NzE1MSwiaXNzIjoiV1lCIn0.0jdFo280vOl0zxU0BMqYRH8ztY1vWI75dOVyiKhGNsI"
        // swiftlint:enable line_length
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
        // swiftlint:disable line_length
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjAsImVtYWlsIjoieTR1cnRpam5makBwcml2YXRlcmVsYXkuYXBwbGVpZC5jb20iLCJuYW1lIjoi67SJ6rWs7Iqk67Cl66mNIiwiaWRGaXJlYmFzZSI6IkpoaW16VDdaUUxWcDhmakx3c1U5eWw1ZTNaeDIiLCJpYXQiOjE2NDg4ODUxNTEsImV4cCI6MTY1MTQ3NzE1MSwiaXNzIjoiV1lCIn0.0jdFo280vOl0zxU0BMqYRH8ztY1vWI75dOVyiKhGNsI"
        // swiftlint:enable line_length
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
        }
        data.count == 0 ? presentEmptyUserView(): presentUserListView(data: data)
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

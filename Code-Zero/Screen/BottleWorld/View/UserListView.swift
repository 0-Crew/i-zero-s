//
//  UserListView.swift
//  Code-Zero
//
//  Created by 미니 on 2021/12/13.
//

import UIKit
import Lottie
import SnapKit

class UserListView: UIView {

    // MARK: - Property
    var lookAroundUser: [BottleWorldUser] = []
    var follower: [BottleWorldUser] = []
    var following: [BottleWorldUser] = []
    var tapType: UserListTapType = .lookAround {
        didSet {
            switch tapType {
            case .lookAround:
                fetchBrowserData(keyword: nil)
            case .follower:
                fetchFollowerData(keyword: nil)
            case .following:
                fetchFollowingData(keyword: nil)
            }
        }
    }
    var filteringText: String? { // 필터링 할 단어
        didSet {
            guard let filter = filteringText else {
                fetchBrowserData(keyword: nil)
                return
            }
            fetchBrowserData(keyword: filter)
        }
    }
    weak var delegate: BottleWorldUsersDelegate?

    // MARK: - @IBOutlet
    @IBOutlet weak var userListTableView: UITableView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Layout Style
    private func loadView() {
        guard let view = Bundle.main.loadNibNamed("UserListView",
                                                  owner: self,
                                                  options: nil)?.first as? UIView else { return }
        view.frame = bounds
        addSubview(view)
        setTableView()
    }
    private func setTableView() {
        userListTableView.registerCell(nibName: "UserListCell")
        userListTableView.delegate = self
        userListTableView.dataSource = self
        setRefresh()
    }
    private func setRefresh() {
        let refresh = UIRefreshControl()
        let loadingView = AnimationView(name: "loading")
        loadingView.play()
        loadingView.frame = CGRect(x: UIScreen.main.bounds.size.width/2 - 25,
                                   y: 5,
                                   width: 50,
                                   height: 50)
        loadingView.contentMode = .scaleToFill
        loadingView.loopMode = .loop
        refresh.tintColor = .clear
        refresh.addSubview(loadingView)
        refresh.addTarget(self, action: #selector(updateTableViewData(refressh:)), for: .valueChanged)
        userListTableView.addSubview(refresh)
    }
    @objc private func updateTableViewData(refressh: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.fetchBrowserData(keyword: self.filteringText)
            refressh.endRefreshing()
        }
    }
}

// MARK: - UITableViewDelegate
extension UserListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return frame.width * 132/375
    }
}

// MARK: - UITableViewDataSource
extension UserListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tapType {
        case .lookAround:
            return lookAroundUser.count
        case .follower:
            return follower.count
        case .following:
            return following.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserListCell = tableView.dequeueCell(indexPath: indexPath)
        cell.delegate = self
        cell.cellIndex = indexPath // 나중에는 여기에 인덱스 대신에 나중에는 유저 고유 이메일 같은거가 들어가야 할 듯
        switch tapType {
        case .lookAround:
            cell.fetchUserData(data: lookAroundUser[indexPath.row])
        case .follower:
            cell.fetchUserData(data: follower[indexPath.row])
        case .following:
            cell.fetchUserData(data: following[indexPath.row])
        }
        return cell
    }
}

// MARK: - Network Function
extension UserListView {
    private func fetchBrowserData(keyword: String?) {
        // swiftlint:disable line_length
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjAsImVtYWlsIjoieTR1cnRpam5makBwcml2YXRlcmVsYXkuYXBwbGVpZC5jb20iLCJuYW1lIjoi7JWg7ZSM6rmA66-87Z2sIiwiaWRGaXJlYmFzZSI6IkpoaW16VDdaUUxWcDhmakx3c1U5eWw1ZTNaeDIiLCJpYXQiOjE2NDU5NDcwNzksImV4cCI6MTY0ODUzOTA3OSwiaXNzIjoiV1lCIn0.4c_MKEolk5Mv5GOjJbQxcAkwpJLyyOTX_fVptT_0sO4"
        // swiftlint:enable line_length
        BottleWorldService
            .shared
            .requestBottleWoldBrowser(token: token, keyword: keyword) { [weak self] result in
                switch result {
                case .success(let userData):
                    self?.lookAroundUser = userData
                    self?.resetTableViewData(type: .lookAround,
                                             keyword: keyword,
                                             count: userData.count)
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
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjAsImVtYWlsIjoieTR1cnRpam5makBwcml2YXRlcmVsYXkuYXBwbGVpZC5jb20iLCJuYW1lIjoi7JWg7ZSM6rmA66-87Z2sIiwiaWRGaXJlYmFzZSI6IkpoaW16VDdaUUxWcDhmakx3c1U5eWw1ZTNaeDIiLCJpYXQiOjE2NDU5NDcwNzksImV4cCI6MTY0ODUzOTA3OSwiaXNzIjoiV1lCIn0.4c_MKEolk5Mv5GOjJbQxcAkwpJLyyOTX_fVptT_0sO4"
        // swiftlint:enable line_length
        BottleWorldService
            .shared
            .requestBottleWoldFollower(token: token, keyword: keyword) { [weak self] result in
                switch result {
                case .success(let userData):
                    self?.follower = userData
                    self?.resetTableViewData(type: .follower,
                                             keyword: keyword,
                                             count: userData.count)
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
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjAsImVtYWlsIjoieTR1cnRpam5makBwcml2YXRlcmVsYXkuYXBwbGVpZC5jb20iLCJuYW1lIjoi7JWg7ZSM6rmA66-87Z2sIiwiaWRGaXJlYmFzZSI6IkpoaW16VDdaUUxWcDhmakx3c1U5eWw1ZTNaeDIiLCJpYXQiOjE2NDU5NDcwNzksImV4cCI6MTY0ODUzOTA3OSwiaXNzIjoiV1lCIn0.4c_MKEolk5Mv5GOjJbQxcAkwpJLyyOTX_fVptT_0sO4"
        // swiftlint:enable line_length
        BottleWorldService
            .shared
            .requestBottleWoldFollowing(token: token, keyword: keyword) { [weak self] result in
                switch result {
                case .success(let userData):
                    self?.following = userData
                    self?.resetTableViewData(type: .following,
                                             keyword: keyword,
                                             count: userData.count)
                case .requestErr(let error):
                    print(error)
                case .serverErr:
                    break
                case .networkFail:
                    break
                }
            }
    }
    func resetTableViewData(type: UserListTapType, keyword: String?, count: Int) {
        if keyword == nil || keyword == "" {
            delegate?.fetchDataCount(type: type, count: count)
        }
        count == 0 ? delegate?.presentEmptyUserView(): delegate?.presentUserListView()
        userListTableView.reloadData()
    }
}

// MARK: - UserListCellDelegate
extension UserListView: UserListCellDelegate {
    func didFollowButtonTap(index: Int) {
        // 팔로우, 팔로잉 서버 연결 코드 작성 예정
        switch tapType {
        case .lookAround:
            break
        case .follower:
            break
        case .following:
            break
        }
        userListTableView.reloadData()
    }
}

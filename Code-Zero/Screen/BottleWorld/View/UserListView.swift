//
//  UserListView.swift
//  Code-Zero
//
//  Created by 미니 on 2021/12/13.
//

import UIKit
import Lottie
import SnapKit

struct UserData {
    let name: String
    let bottleLevel: Int
    let subject: String?
    let term: String?
    var follow: Bool
}

class UserListView: UIView {

    // MARK: - Property
    enum UserListTapType {
        case lookAround
        case follower
        case following
    }
    var lookAroundUser: [BottleWorldUser] = []
    var follower: [UserData] = []
    var following: [UserData] = []
    var tapType: UserListTapType = .lookAround
    var filteringText: String? // 필터링 할 단어

    // MARK: - @IBOutlet
    @IBOutlet weak var userListTableView: UITableView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
        makeDumyData()
        fetchBrowserData()
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
        loadingView.frame = CGRect(x: userListTableView.frame.width/2 - 25, y: 5, width: 50, height: 50)
        loadingView.contentMode = .scaleToFill
        loadingView.loopMode = .loop
        refresh.tintColor = .clear
        refresh.addSubview(loadingView)
        refresh.addTarget(self, action: #selector(updateTableViewData(refressh:)), for: .valueChanged)
        userListTableView.addSubview(refresh)
    }
    @objc private func updateTableViewData(refressh: UIRefreshControl) {
        refressh.endRefreshing()
        userListTableView.reloadData()
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
            cell.setUserInfo(user: follower[indexPath.row])
        case .following:
            cell.setUserInfo(user: following[indexPath.row])
        }
        return cell
    }
}

// MARK: - Network Function
extension UserListView {
    private func makeDumyData() {
        let data1 = UserData(name: "미니미니", bottleLevel: 1, subject: "플라스틱 빨대사용하기플라스틱 빨대사용",
                             term: "12/8-13", follow: true)
        let data2 = UserData(name: "주혁이", bottleLevel: 0, subject: "일회용컵으로 커피 마시기",
                             term: "12/1-8", follow: false)
        let data3 = UserData(name: "민희", bottleLevel: 3, subject: "텀블러 가지고 다니기",
                             term: "12/12-19", follow: false)
        let data4 = UserData(name: "환경지키자", bottleLevel: 4, subject: "물티슈 쓰기",
                             term: "12/11-18", follow: true)
        let data5 = UserData(name: "삐뽀", bottleLevel: 2, subject: "로션 구매하기",
                             term: "12/5-12", follow: true)
        let data6 = UserData(name: "보틀월드", bottleLevel: 1, subject: "종이 컵홀더 안 쓰기종이 컵",
                             term: "12/3-10", follow: false)
        let data7 = UserData(name: "워유보갓", bottleLevel: 3, subject: "종이 컵홀더 안 쓰기종이 컵",
                             term: "12/13-20", follow: true)
        let data8 = UserData(name: "미니테스트중", bottleLevel: 7, subject: nil,
                             term: nil, follow: true)
        follower = [data1, data4, data5, data7, data8]
        following = [data2, data3, data6]
    }
    private func fetchBrowserData() {
        // swiftlint:disable line_length
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjAsImVtYWlsIjoieTR1cnRpam5makBwcml2YXRlcmVsYXkuYXBwbGVpZC5jb20iLCJuYW1lIjoi7JWg7ZSM6rmA66-87Z2sIiwiaWRGaXJlYmFzZSI6IkpoaW16VDdaUUxWcDhmakx3c1U5eWw1ZTNaeDIiLCJpYXQiOjE2NDU5NDcwNzksImV4cCI6MTY0ODUzOTA3OSwiaXNzIjoiV1lCIn0.4c_MKEolk5Mv5GOjJbQxcAkwpJLyyOTX_fVptT_0sO4"
        // swiftlint:enable line_length
        BottleWorldService
            .shared
            .requestBottleWoldBrowser(token: token, keyword: nil) { [weak self] result in
                switch result {
                case .success(let userData):
                    self?.lookAroundUser = userData
                    self?.userListTableView.reloadData()
                case .requestErr(let error):
                    print(error)
                case .serverErr:
                    break
                case .networkFail:
                    break
                }
            }
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
            follower[index].follow = !follower[index].follow
        case .following:
            following[index].follow = !following[index].follow
        }
        userListTableView.reloadData()
    }
}

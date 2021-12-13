//
//  UserListView.swift
//  Code-Zero
//
//  Created by 미니 on 2021/12/13.
//

import UIKit

struct UserData {
    let name: String
    let bottleLevel: Int
    let subject: String
    let term: String
    let follow: Bool
}

class UserListView: UIView {

    // MARK: - Property
    enum UserListTapType {
        case lookAround
        case follower
        case following
    }
    var lookAroundUser: [UserData] = []
    var follower: [UserData] = []
    var following: [UserData] = []
    var tapType: UserListTapType = .lookAround

    // MARK: - @IBOutlet
    @IBOutlet weak var userListTableView: UITableView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
        makeDumyData()
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
        let nibName = UINib(nibName: "UserListCell", bundle: nil)
        userListTableView.register(nibName, forCellReuseIdentifier: "UserListCell")
        userListTableView.delegate = self
        userListTableView.dataSource = self
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
        switch tapType {
        case .lookAround:
            cell.setUserInfo(user: lookAroundUser[indexPath.row])
        case .follower:
            cell.setUserInfo(user: follower[indexPath.row])
        case .following:
            cell.setUserInfo(user: following[indexPath.row])
        }
        return cell
    }
}

extension UserListView {
    private func makeDumyData() {
        let data1 = UserData(name: "미니미니", bottleLevel: 1, subject: "종이 컵홀더 받기",
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
        lookAroundUser = [data1, data2, data3, data4, data5, data6, data7]
        follower = [data1, data4, data5, data7]
        following = [data2, data3, data6]
    }
}

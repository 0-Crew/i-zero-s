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
    var userInfoData: [BottleWorldUser] = [] {
        didSet {
            userListTableView.reloadData()
        }
    }
    var follower: [BottleWorldUser] = []
    var following: [BottleWorldUser] = []

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
//            self.fetchBrowserData(keyword: self.filteringText)
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
        return userInfoData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserListCell = tableView.dequeueCell(indexPath: indexPath)
        cell.delegate = self
        cell.fetchUserData(data: userInfoData[indexPath.row])
        cell.userId = userInfoData[indexPath.row].user.id
        return cell
    }
}

// MARK: - UserListCellDelegate
extension UserListView: UserListCellDelegate {
    func didFollowButtonTap(id index: Int) {
        // 팔로우, 팔로잉 서버 연결 코드 작성 예정
        userListTableView.reloadData()
    }
}

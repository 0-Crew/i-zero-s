//
//  UserListView.swift
//  Code-Zero
//
//  Created by 미니 on 2021/12/13.
//

import UIKit
import Lottie
import SnapKit

protocol UserListViewDelegate: AnyObject {
    func didRefresh(type: UserListTapType)
    func didTapUser(userId: Int)
    func paging(type: UserListTapType, id: Int)
}

class UserListView: UIView {

    // MARK: - Property
    var userInfoData: [BottleWorldUser] = [] {
        didSet {
            pagingOnState = false
            userListTableView.reloadData()
        }
    }
    internal weak var delegate: UserListViewDelegate?
    var type: UserListTapType?
    var pagingOnState: Bool = false
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
        guard let type = type else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.delegate?.didRefresh(type: type)
            refressh.endRefreshing()
        }
    }
    private func requestFollow(id: Int) {
        guard let token = UserDefaultManager.shared.accessToken else { return }
        BottleWorldService.shared.makeBottleworldFollow(token: token, id: id) { [weak self] result in
            switch result {
            case .success:
                self?.userInfoData.indices.filter { self?.userInfoData[$0].user.id == id }
                .forEach { self?.userInfoData[$0].follow.toggle() }
                self?.userListTableView.reloadData()
            case .requestErr:
                break
            case .serverErr:
                break
            case .networkFail:
                break
            }
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didTapUser(userId: userInfoData[indexPath.row].user.id)
    }
}

extension UserListView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard userInfoData.count > 20 else { return }
        let tableViewoffsetY = userListTableView.contentOffset.y
        let tableViewHeight = userListTableView.frame.size.height
        let tableViewContentHeight = userListTableView.contentSize.height
        if (tableViewoffsetY + tableViewHeight) >= tableViewContentHeight && !pagingOnState {
            let index = userInfoData.count
            guard let type = type,
                  index != 0 else { return }
            pagingOnState = true
            self.delegate?.paging(type: type, id: userInfoData[index-1].user.id)
        }
    }
}

// MARK: - UserListCellDelegate
extension UserListView: UserListCellDelegate {
    func didFollowButtonTap(id: Int) {
        requestFollow(id: id)
    }
}

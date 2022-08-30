//
//  BottleWorldVC.swift
//  Code-Zero
//
//  Created by Hailey on 2021/12/03.
//

import UIKit
import SnapKit

enum UserListTapType {
    case lookAround
    case follower
    case following
}

class BottleWorldVC: UIViewController {

    // MARK: - Property
    lazy var pageCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    var customMenuBar: SwipeBarView!

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomTabBar()
        setPageCollectionViewLayout()
        title = "보틀월드"
        navigationController?.isNavigationBarHidden = false
    }
}

// MARK: - View Layout Style
extension BottleWorldVC {
    func setPageCollectionViewLayout() {
        view.addSubview(pageCollectionView)
        pageCollectionView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(customMenuBar.snp.bottom)
        }
        pageCollectionView.registerCell(nibName: "BottleWorldListCell")
    }
    func setupCustomTabBar() {
        customMenuBar = SwipeBarView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0))
        view.addSubview(customMenuBar)
        customMenuBar.delegate = self
        customMenuBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(47)
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension BottleWorldVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BottleWorldListCell = collectionView.dequeueCell(indexPath: indexPath)
        cell.swipeDelegate = self
        cell.userDelegate = self
        cell.tapType = [.lookAround, .follower, .following][indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        customMenuBar.indicatorView.snp.updateConstraints {
            $0.leading.equalTo(scrollView.contentOffset.x / 3)
        }
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemAt = Int(targetContentOffset.pointee.x / self.view.frame.width)
        let indexPath = IndexPath(item: itemAt, section: 0)
        customMenuBar.customTabBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension BottleWorldVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - SwipeBarDelgate
extension BottleWorldVC: SwipeBarDelgate {
    func customMenuBar(scrollTo index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        pageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        view.endEditing(true)
    }
}

extension BottleWorldVC: BottleWorldSwipeBarDelegate {
    func fetchBarCount(followerCount: Int, followingCount: Int) {
        customMenuBar.follower = followerCount
        customMenuBar.following = followingCount
    }
}

extension BottleWorldVC: BottleWorldUserClickDelegate {
    func showUserChallenge(id: Int) {
        let storyboard = UIStoryboard(name: "Challenge", bundle: nil)
        guard let userChallengeVC = storyboard.instantiateViewController(withIdentifier: "ChallengeVC")
                as? ChallengeVC else { return }
        userChallengeVC.isMine = false
        userChallengeVC.fetchedUserId = id
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .gray4
        navigationController?.pushViewController(userChallengeVC, animated: true)
    }
}

//
//  SwipeBarView.swift
//  Code-Zero
//
//  Created by 미니 on 2021/12/05.
//

import UIKit
import SnapKit

protocol SwipeBarDelgate: AnyObject {
    func customMenuBar(scrollTo index: Int)
}

class SwipeBarView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupCustomTabBar(width: frame.width/3)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Property
    internal var customTabBarCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0),
                                              collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    internal var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .orangeMain
        return view
    }()
    internal weak var delegate: SwipeBarDelgate?
    internal var follower: Int = 0 {
        didSet {
            customTabBarCollectionView.reloadData()
            customTabBarCollectionView.selectItem(at: selectRow, animated: false, scrollPosition: [])
        }
    }
    internal var following: Int = 0 {
        didSet {
            customTabBarCollectionView.reloadData()
            customTabBarCollectionView.selectItem(at: selectRow, animated: false, scrollPosition: [])
        }
    }
    internal var selectRow: IndexPath = IndexPath(item: 0, section: 0)

    // MARK: Setup Views
    func setupCollectioView() {
        customTabBarCollectionView.delegate = self
        customTabBarCollectionView.dataSource = self
        customTabBarCollectionView.showsHorizontalScrollIndicator = false
        customTabBarCollectionView.registerCell(nibName: "TopTabBarCell")
        customTabBarCollectionView.isScrollEnabled = false
        let indexPath = IndexPath(item: 0, section: 0)
        customTabBarCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
    }

    func setupCustomTabBar(width: CGFloat) {
        backgroundColor = .lightGray2
        setupCollectioView()
        self.addSubview(customTabBarCollectionView)
        customTabBarCollectionView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(45)
        }
        self.addSubview(indicatorView)
        indicatorView.snp.makeConstraints {
            $0.height.equalTo(2)
            $0.bottom.leading.equalToSuperview()
            $0.width.equalTo(width)
        }
    }
}

// MARK: - UICollectionViewDelegate, DataSource
extension SwipeBarView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TopTabBarCell = collectionView.dequeueCell(indexPath: indexPath)
        cell.titleLabel.text = ["둘러보기", "\(follower) 팔로워", "\(following) 팔로잉"][indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / 3, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.customMenuBar(scrollTo: indexPath.row)
        selectRow = indexPath
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SwipeBarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

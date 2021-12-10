//
//  BottleWorldVC.swift
//  Code-Zero
//
//  Created by Hailey on 2021/12/03.
//

import UIKit
import SnapKit

class BottleWorldVC: UIViewController {

    // MARK: - Property
    lazy var pageCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100),
                                              collectionViewLayout: collectionViewLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    var customMenuBar = SwipeBarView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomTabBar()
    }
}

// MARK: - View Layout Style
extension BottleWorldVC {
    func setPageCollectionViewLayout() {
        view.addSubview(pageCollectionView)
        pageCollectionView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        pageCollectionView.registerCell(nibName: "BottleWorldListCell")
//        pageCollectionView.topAnchor.constraint(equalTo: self.customMenuBar.bottomAnchor).isActive = true
    }
    func setupCustomTabBar() {
        self.view.addSubview(customMenuBar)
        customMenuBar.delegate = self
        customMenuBar.snp.remakeConstraints {
            $0.width.equalTo(view.frame.width/4)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(60)
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension BottleWorldVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BottleWorldListCell = collectionView.dequeueCell(indexPath: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
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

extension BottleWorldVC: SwipeBarDelgate {
    func customMenuBar(scrollTo index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        self.pageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

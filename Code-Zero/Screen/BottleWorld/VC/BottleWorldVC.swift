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
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: collectionViewLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - View Layout Style
extension BottleWorldVC {
    func setPageCollectionViewLayout() {
//        pageCollectionView.register(UINib(nibName: 셀이름.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: PageCell.reusableIdentifier)
        view.addSubview(pageCollectionView)
        pageCollectionView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
//        pageCollectionView.topAnchor.constraint(equalTo: self.customMenuBar.bottomAnchor).isActive = true
    }
}

//
//  BottleWorldVC.swift
//  Code-Zero
//
//  Created by Hailey on 2021/12/03.
//

import UIKit
<<<<<<< HEAD
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
    
=======

class BottleWorldVC: UIViewController {

>>>>>>> 778d48e ([:wrench: configure] BottleWorld View 만들 VC 생성)
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
<<<<<<< HEAD

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
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension BottleWorldVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BottleWorldListCell = collectionView.dequeueCell(indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension BottleWorldVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
=======
>>>>>>> 778d48e ([:wrench: configure] BottleWorld View 만들 VC 생성)

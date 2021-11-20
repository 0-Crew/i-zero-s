//
//  UICollectionView+Extension.swift
//  Code-Zero
//
//  Created by 주혁 on 2021/11/20.
//

import UIKit

extension UICollectionView {

    func registerCell(cellType: UICollectionViewCell.Type, resuseIdentifier: String? = nil) {
        let reuseIdentifier = resuseIdentifier ?? String(describing: cellType.self)
        self.register(cellType, forCellWithReuseIdentifier: reuseIdentifier)
    }

    func registerCell(nibName: String, resuseIdentifier: String? = nil) {
        let identifier = resuseIdentifier ?? nibName
        let nib = UINib(nibName: nibName, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: identifier)
    }
}

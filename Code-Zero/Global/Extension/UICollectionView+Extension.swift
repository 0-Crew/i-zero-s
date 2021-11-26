//
//  UICollectionView+Extension.swift
//  Code-Zero
//
//  Created by 주혁 on 2021/11/20.
//

import UIKit

extension UICollectionView {

    // Custom Cell 등록 하는 extension
    func registerCell(cellType: UICollectionViewCell.Type, resuseIdentifier: String? = nil) {
        let reuseIdentifier = resuseIdentifier ?? String(describing: cellType.self)
        self.register(cellType, forCellWithReuseIdentifier: reuseIdentifier)
    }

    // Custom Cell 등록 하는 extension - xib 등록시 사용
    func registerCell(nibName: String, resuseIdentifier: String? = nil) {
        let identifier = resuseIdentifier ?? nibName
        let nibInstance = UINib(nibName: nibName, bundle: nil)
        self.register(nibInstance, forCellWithReuseIdentifier: identifier)
    }

    func dequeueCell<T: UICollectionViewCell>(reuseIdentifier: String? = nil, indexPath: IndexPath) -> T {
        let reuseIdentifier = reuseIdentifier ?? String(describing: T.self)
        guard
            let cell = self.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? T
        else {
            fatalError()
        }
        return cell
    }
    func dequeueOptionalCell<T: UICollectionViewCell>(
        reuseIdentifier: String? = nil,
        indexPath: IndexPath
    ) -> T? {
        let reuseIdentifier = reuseIdentifier ?? String(describing: T.self)
        guard
            let cell = self.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? T
        else {
            return nil
        }
        return cell
    }
}

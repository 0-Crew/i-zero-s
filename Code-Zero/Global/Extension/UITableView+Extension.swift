//
//  UITableView+Extension.swift
//  Code-Zero
//
//  Created by 이주혁 on 2021/10/31.
//

import UIKit

extension UITableView {
    func registerCell(cellType: UITableViewCell.Type, reuseIdentifier: String? = nil) {
        let reuseIdentifier = reuseIdentifier ?? String(describing: cellType.self)
        self.register(cellType, forCellReuseIdentifier: reuseIdentifier)
    }
    // xib 등록용
    func registerCell(nibName: String, resuseIdentifier: String? = nil) {
        let identifier = resuseIdentifier ?? nibName
        let nibInstance = UINib(nibName: nibName, bundle: nil)
        self.register(nibInstance, forCellReuseIdentifier: identifier)
    }
    func dequeueCell<T: UITableViewCell>(reuseIdentifier: String? = nil, indexPath: IndexPath) -> T {
        let reuseIdentifier = reuseIdentifier ?? String(describing: T.self)
        guard
            let cell = self.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? T
        else {
            fatalError()
        }
        return cell
    }
}

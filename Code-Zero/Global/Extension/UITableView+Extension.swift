//
//  UITableView+Extension.swift
//  Code-Zero
//
//  Created by 이주혁 on 2021/10/31.
//

import UIKit

extension UITableView {
    func registerCell(cellType: UITableViewCell.Type, reuseIdentifier: String? = nil){
        let reuseIdentifier = reuseIdentifier ?? String(describing: cellType.self)
        self.register(cellType, forCellReuseIdentifier: reuseIdentifier)
    }
    func dequeueCell<T: UITableViewCell>(reuseIdentifier: String? = nil, indexPath: IndexPath) -> T {
        let reuseIdentifier = reuseIdentifier ?? String(describing: T.self)
        guard let cell = self.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? T else {
            fatalError()
        }
        return cell
    }
}

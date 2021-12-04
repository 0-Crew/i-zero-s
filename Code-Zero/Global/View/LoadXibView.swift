//
//  LoadXibView.swift
//  Code-Zero
//
//  Created by 주혁 on 2021/12/04.
//

import UIKit

class LoadXibView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
    }

    private func loadView() {
        let name = String(describing: Self.self)
        let nibs = Bundle.main.loadNibNamed(name, owner: self, options: nil)

        guard let xibView = nibs?.first as? UIView else { return }
        xibView.frame = self.bounds
        addSubview(xibView)
        xibView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

//
//  NotUserView.swift
//  Code-Zero
//
//  Created by 미니 on 2022/01/25.
//

import UIKit

class NotUserView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func loadView() {

        guard let view = Bundle.main.loadNibNamed("NotUserView",
                                                  owner: self,
                                                  options: nil)?.first as? UIView else { return }

        view.frame = bounds
        view.backgroundColor = .none
        addSubview(view)
    }
}

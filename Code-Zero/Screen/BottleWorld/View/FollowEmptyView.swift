//
//  FollowEmptyView.swift
//  Code-Zero
//
//  Created by 미니 on 2021/12/12.
//

import UIKit

class FollowEmptyView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func loadView() {
        guard let view = Bundle.main.loadNibNamed("FollowEmptyView",
                                                  owner: self,
                                                  options: nil)?.first as? UIView else { return }
        view.frame = bounds
        addSubview(view)
    }
}

//
//  SettingLineView.swift
//  Code-Zero
//
//  Created by 미니 on 2022/01/25.
//

import UIKit

class SettingLineView: UIView {

    @IBOutlet weak var settingLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func loadView() {

        guard let view = Bundle.main.loadNibNamed("SettingLineView",
                                                  owner: self,
                                                  options: nil)?.first as? UIView else { return }

        view.frame = bounds
        view.backgroundColor = .none
        addSubview(view)
    }

}

//
//  UserView.swift
//  Code-Zero
//
//  Created by 미니 on 2022/01/25.
//

import UIKit

class UserView: UIView {

    @IBOutlet weak var nickBackView: UIView!
    @IBOutlet weak var nickFirstLabel: UILabel!
    @IBOutlet weak var nickButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func loadView() {
        guard let view = Bundle.main.loadNibNamed("UserView",
                                                  owner: self,
                                                  options: nil)?.first as? UIView else { return }

        view.frame = bounds
        view.backgroundColor = .none
        addSubview(view)
        nickBackView.setBorder(borderColor: .darkGray2, borderWidth: 1)
        nickBackView.makeRounded(cornerRadius: nil)
    }

    func setUserInfo(nick: String, email: String) {
        nickButton.setTitle(nick, for: .normal)
        emailLabel.text = email
        nickFirstLabel.text = String(nick[nick.startIndex])
    }
}

//
//  UserView.swift
//  Code-Zero
//
//  Created by 미니 on 2022/01/25.
//

import UIKit

class UserView: UIView {

    // MARK: - Property
    var moveViewController: ((UIViewController) -> Void)?

    // MARK: - IBOutlet
    @IBOutlet weak var nickBackView: UIView!
    @IBOutlet weak var nickFirstLabel: UILabel!
    @IBOutlet weak var nickButton: UIButton!

    // MARK: - IBAction
    @IBAction func nickButtonDidTap(_ sender: UIButton) {
        guard let moveViewController = moveViewController else { return }
        let storybard = UIStoryboard(name: "Account", bundle: nil)
        let accountVC = storybard.instantiateViewController(withIdentifier: "AccountSettingVC")
        moveViewController(accountVC)
    }

    // MARK: - Override Function
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
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(moveAccountViewController))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func moveAccountViewController() {
        guard let moveViewController = moveViewController else { return }
        let storybard = UIStoryboard(name: "Account", bundle: nil)
        let accountVC = storybard.instantiateViewController(withIdentifier: "AccountSettingVC")
        moveViewController(accountVC)
    }

    func setUserInfo(nick: String) {
        nickButton.setTitle(nick, for: .normal)
        nickFirstLabel.text = String(nick[nick.startIndex])
    }
}

//
//  AccountPrivacyVC.swift
//  Code-Zero
//
//  Created by 미니 on 2022/02/06.
//

import UIKit

class AccountPrivacyVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var privacySwitch: UISwitch!

    // MARK: - @IBAction
    @IBAction func privacySwitchDidTap(_ sender: UISwitch) {
        originIsPrivate = sender.isOn
        deliveryChangeNickname(state: sender.isOn)
    }
    @IBAction func backButtonDidTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Property
    var originIsPrivate: Bool?
    var changePrivateClosure: ((Bool) -> Void)?

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setoriginData()
    }

    // MARK: - Set Propety Data
    private func setoriginData() {
        guard let originIsPrivate = originIsPrivate else { return }
        privacySwitch.isOn = originIsPrivate
    }
    private func deliveryChangeNickname(state: Bool) {
        guard let changePrivateClosure = changePrivateClosure else { return }
        changePrivateClosure(state)
    }
}

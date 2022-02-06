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
        isPrivateSwitchOn = sender.isOn
    }
    @IBAction func backButtonDidTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Property
    var isPrivateSwitchOn: Bool = true {
        didSet {
            // TODO: 서버 연결 해서 계정 범위 수정
        }
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        privacySwitch.isOn = isPrivateSwitchOn
    }
}

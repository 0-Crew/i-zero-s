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
            requestToggleAccountPrivate()
        }
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        privacySwitch.isOn = isPrivateSwitchOn
    }
}

// MARK: - Network Function
extension AccountPrivacyVC {
    func requestToggleAccountPrivate() {
        // swiftlint:disable line_length
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjAsImVtYWlsIjoieTR1cnRpam5makBwcml2YXRlcmVsYXkuYXBwbGVpZC5jb20iLCJuYW1lIjoi67SJ6rWs7Iqk67Cl66mNIiwiaWRGaXJlYmFzZSI6IkpoaW16VDdaUUxWcDhmakx3c1U5eWw1ZTNaeDIiLCJpYXQiOjE2NTM0ODk4MTAsImV4cCI6MTY1NjA4MTgxMCwiaXNzIjoiV1lCIn0.5oevdqhJA_NhURaD3-OOCwbUE92GvcXDndAFPW3vOHE"
        // swiftlint:enable line_length
        UserPrivateService.shared.toggleAccountPrivate(token: token) { [weak self] result in
            switch result {
            case .success(let data):
                if self?.isPrivateSwitchOn == data.isPrivate {
                    // 토글이 반대로 설정
                    self?.privacySwitch.isOn.toggle()
                }
            case .requestErr(let error):
                print(error)
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }

        }
    }
}

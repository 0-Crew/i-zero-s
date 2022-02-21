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
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTQsImVtYWlsIjoiZGRkZGRAbGRhc2tmai5jb20iLCJuYW1lIjoi7JWI64WV7ZWY7IqIIiwiaWRGaXJlYmFzZSI6IkRqZUZyS2tXWG5nS3lVc0JNVDdNa2E3TFlORTMiLCJpYXQiOjE2NDU0NDQzMDAsImV4cCI6MTY0ODAzNjMwMCwiaXNzIjoiV1lCIn0.7uraZqel7I0DVPX1El2I1gS2Hq13MdYJrrLSYPOsOvY"
        UserDefaults.standard.set(token, forKey: "userToken")
        // swiftlint:enable line_length

        guard let token = UserDefaults.standard.string(forKey: "userToken") else { return }
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

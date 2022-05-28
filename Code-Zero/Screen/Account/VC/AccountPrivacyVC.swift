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
        requestToggleAccountPrivate()
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

// MARK: - Network Function
extension AccountPrivacyVC {
    func requestToggleAccountPrivate() {
        // swiftlint:disable line_length
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjAsImVtYWlsIjoieTR1cnRpam5makBwcml2YXRlcmVsYXkuYXBwbGVpZC5jb20iLCJuYW1lIjoi67SJ6rWs7Iqk67Cl66mNIiwiaWRGaXJlYmFzZSI6IkpoaW16VDdaUUxWcDhmakx3c1U5eWw1ZTNaeDIiLCJpYXQiOjE2NTM0ODk4MTAsImV4cCI6MTY1NjA4MTgxMCwiaXNzIjoiV1lCIn0.5oevdqhJA_NhURaD3-OOCwbUE92GvcXDndAFPW3vOHE"
        // swiftlint:enable line_length
        UserPrivateService.shared.toggleAccountPrivate(token: token) { [weak self] result in
            switch result {
            case .success(let data):
                self?.privacySwitch.isOn = data.isPrivate
                originIsPrivate = data.isPrivate
                deliveryChangeNickname(state: data.isPrivate)
            case .serverErr:
                // 토큰 만료(자동 로그아웃 느낌..)
                print("serverErr")
            case .networkFail:
                // TODO: 서버 자체 에러
                print("networkFail")
            case .requestErr(let error):
                print(error)
            }
        }
    }
}

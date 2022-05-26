//
//  AccountSettingVC.swift
//  Code-Zero
//
//  Created by 미니 on 2022/02/06.
//

import UIKit

class AccountSettingVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet var settingListView: [UIView]!

    @IBAction func backButtonDidTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    // MARK: - Property
    let settingListText = ["계정 공개 범위", "계정 관리"]
    var userInfo: UserInfo?

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setSettingList()
    }

    // MARK: - Set Propety Data
    private func setSettingList() {
        settingListView.enumerated().forEach {
            let settingLineView = SettingLineView(frame: CGRect(x: 0,
                                                                y: 0,
                                                                width: self.view.frame.width - 60,
                                                                height: $1.frame.height))

            $1.addSubview(settingLineView)
            settingLineView.settingLabel.text = settingListText[$0]

            if $0 == 0 {
                let tapGesture = UITapGestureRecognizer(target: self,
                                                        action: #selector(firstListDidTap(sender:)))
                $1.addGestureRecognizer(tapGesture)
            } else {
                let tapGesture = UITapGestureRecognizer(target: self,
                                                        action: #selector(secondListDidTap(sender:)))
                $1.addGestureRecognizer(tapGesture)
            }

        }
    }
    @objc private func firstListDidTap(sender: UITapGestureRecognizer) {
        guard let privacyVC = storyboard?.instantiateViewController(
            withIdentifier: "AccountPrivacyVC"
        ) as? AccountPrivacyVC,
              let userInfo = userInfo else { return }
        privacyVC.originIsPrivate = userInfo.isPrivate
        self.navigationController?.pushViewController(privacyVC, animated: true)
    }
    @objc private func secondListDidTap(sender: UITapGestureRecognizer) {
        guard let accountVC = storyboard?.instantiateViewController(
            withIdentifier: "AccountNickVC"
        ) as? AccountNickVC,
              let userInfo = userInfo else { return }
        accountVC.originNickname = userInfo.name
        self.navigationController?.pushViewController(accountVC, animated: true)
    }
}

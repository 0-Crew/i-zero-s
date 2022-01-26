//
//  SettingVC.swift
//  Code-Zero
//
//  Created by 미니 on 2022/01/25.
//

import UIKit
import SnapKit

class SettingVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet var settingListView: [UIView]!
    @IBOutlet weak var versionLabel: UILabel!

    // MARK: - Property
    let isUser: Bool = true
    let settingListText = ["알림설정", "문의하기", "이용약관", "개인정보정책", "오픈소스"]

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserInfoView()
        setSettingList()
        setAppVersion()
    }
}

// MARK: - Set View Info
extension SettingVC {

    func setUserInfoView() {
        if isUser {
            let isUserView = UserView(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: userInfoView.frame.width,
                                                    height: userInfoView.frame.height))
            userInfoView.addSubview(isUserView)
            isUserView.setUserInfo(nick: "김미니미니", email: "xwoud@naver.com")
        } else {
            let isNotUserView = NotUserView(frame: CGRect(x: 0,
                                                          y: 0,
                                                          width: userInfoView.frame.width,
                                                          height: userInfoView.frame.height))
            userInfoView.addSubview(isNotUserView)
        }

        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        versionLabel.text = "버전 \(version ?? "1.0.0")"
    }

    func setSettingList() {
        settingListView.enumerated().forEach {
            let settingLineView = SettingLineView(frame: CGRect(x: 0,
                                                                y: 0,
                                                                width: self.view.frame.width - 60,
                                                                height: $1.frame.height))

            $1.addSubview(settingLineView)
            settingLineView.settingLabel.text = settingListText[$0]
        }
    }

    func setAppVersion() {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        versionLabel.text = "버전 \(version ?? "1.0.0")"
    }
}

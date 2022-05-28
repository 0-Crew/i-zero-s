//
//  SettingVC.swift
//  Code-Zero
//
//  Created by 미니 on 2022/01/25.
//

import UIKit
import SnapKit
import SafariServices

class SettingVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet var settingListView: [UIView]!
    @IBOutlet weak var versionLabel: UILabel!

    // MARK: - IBAction
    @IBAction func closeButtonDidTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Property
    var isUser: Bool = true
    let settingListText = ["문의하기", "이용약관", "개인정보정책", "오픈소스"]
    var userInfo: UserInfo?

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setUserInfoView()
        setSettingList()
        setAppVersion()
    }
}

// MARK: - Set View Info
extension SettingVC {
    func setUserInfoView() {
        let navigationClosure: (UIViewController) -> Void = { view in
            self.navigationController?.pushViewController(view, animated: true)
        }
        switch isUser {
        case true:
            guard let userInfo = userInfo else { return }
            let isUserView = UserView(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: userInfoView.frame.width,
                                                    height: userInfoView.frame.height))
            userInfoView.addSubview(isUserView)
            isUserView.setUserInfo(info: userInfo)
            isUserView.moveViewController = navigationClosure
        case false:
            let isNotUserView = NotUserView(frame: CGRect(x: 0,
                                                          y: 0,
                                                          width: userInfoView.frame.width,
                                                          height: userInfoView.frame.height))
            userInfoView.addSubview(isNotUserView)
            isNotUserView.moveViewController = navigationClosure
        }

        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        versionLabel.text = "버전 \(version ?? "1.0.0")"
    }

    private func setSettingList() {
        settingListView.enumerated().forEach {
            let settingLineView = SettingLineView(frame: CGRect(x: 0,
                                                                y: 0,
                                                                width: self.view.frame.width - 60,
                                                                height: $1.frame.height))
            $1.addSubview(settingLineView)
            settingLineView.settingLabel.text = settingListText[$0]
        }
        setListTouchGesture()
    }

    private func setAppVersion() {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        versionLabel.text = "버전 \(version ?? "1.0.0")"
    }

    @objc func touchUpToInsta() {
        presentSafariWebVC(url: "https://instagram.com/washyourbottle?igshid=YmMyMTA2M2Y=")
    }

    @objc func touchUpToTOS() {
        presentSafariWebVC(url: "https://chatter-gallium-16e.notion.site/239ddeb527df483a89cdd2d8fe40fff3")
    }

    @objc func touchUpToPrivacyPolicy() {
        presentSafariWebVC(url: "https://chatter-gallium-16e.notion.site/da60b412544b405aaeb8d4fefa46c5cb")
    }

    @objc func touchUpToOpenSource() {
        presentSafariWebVC(url: "https://instagram.com/washyourbottle?igshid=YmMyMTA2M2Y=")
    }

    func setListTouchGesture() {
        let insta = UITapGestureRecognizer(target: self,
                                           action: #selector(touchUpToInsta))
        settingListView[0].addGestureRecognizer(insta)

        let tosList = UITapGestureRecognizer(target: self,
                                         action: #selector(touchUpToTOS))
        settingListView[1].addGestureRecognizer(tosList)

        let privatePolicy = UITapGestureRecognizer(target: self,
                                                   action: #selector(touchUpToPrivacyPolicy))
        settingListView[2].addGestureRecognizer(privatePolicy)

        let openSource = UITapGestureRecognizer(target: self,
                                                   action: #selector(touchUpToPrivacyPolicy))
        settingListView[3].addGestureRecognizer(openSource)
    }
}

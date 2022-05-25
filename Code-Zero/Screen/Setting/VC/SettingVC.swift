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
        switch isUser {
        case true:
            guard let userInfo = userInfo else { return }
            let isUserView = UserView(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: userInfoView.frame.width,
                                                    height: userInfoView.frame.height))
            let navigationClosure: (UIViewController) -> Void = { view in
                self.navigationController?.pushViewController(view, animated: true)
            }

            userInfoView.addSubview(isUserView)
            isUserView.setUserInfo(nick: userInfo.name)
            isUserView.moveViewController = navigationClosure
        case false:
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
        setListTouchGesture()
    }

    func setAppVersion() {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        versionLabel.text = "버전 \(version ?? "1.0.0")"
    }

    @objc func touchUpToInsta() {
        let instagramUrl: URL? =
        NSURL(string: "https://instagram.com/washyourbottle?igshid=YmMyMTA2M2Y=") as URL?
        guard let instagramUrl = instagramUrl else { return }
        let safariView: SFSafariViewController = SFSafariViewController(url: instagramUrl)
        present(safariView, animated: true, completion: nil)
    }

    @objc func touchUpToTOS() {
        let tosUrl: URL? =
        NSURL(string: "https://instagram.com/washyourbottle?igshid=YmMyMTA2M2Y=") as URL?
        guard let tosUrl = tosUrl else { return }
        let safariView: SFSafariViewController = SFSafariViewController(url: tosUrl)
        self.present(safariView, animated: true, completion: nil)
    }

    @objc func touchUpToPrivacyPolicy() {
        let privacyPolicyUrl: URL? =
        NSURL(string: "https://instagram.com/washyourbottle?igshid=YmMyMTA2M2Y=") as URL?
        guard let privacyPolicyUrl = privacyPolicyUrl else { return }
        let safariView: SFSafariViewController = SFSafariViewController(url: privacyPolicyUrl)
        self.present(safariView, animated: true, completion: nil)
    }

    @objc func touchUpToOpenSource() {
        let openSourceUrl: URL? =
        NSURL(string: "https://instagram.com/washyourbottle?igshid=YmMyMTA2M2Y=") as URL?
        guard let openSourceUrl = openSourceUrl else { return }
        let safariView: SFSafariViewController = SFSafariViewController(url: openSourceUrl)
        self.present(safariView, animated: true, completion: nil)
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

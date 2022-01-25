//
//  SettingVC.swift
//  Code-Zero
//
//  Created by 미니 on 2022/01/25.
//

import UIKit

class SettingVC: UIViewController {

    @IBOutlet weak var userInfoView: UIView!

    let isUser: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setUserInfoView()
        // Do any additional setup after loading the view.
    }
}

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
    }
}

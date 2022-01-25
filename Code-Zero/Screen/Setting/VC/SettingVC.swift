//
//  SettingVC.swift
//  Code-Zero
//
//  Created by 미니 on 2022/01/25.
//

import UIKit

class SettingVC: UIViewController {

    @IBOutlet weak var userView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        // Do any additional setup after loading the view.
    }
}

extension SettingVC {
    func setView() {

        let todayJoinChallengeView = NotUserView(frame: CGRect(x: 0,
                                                                     y: 0,
                                                                     width: userView.frame.width,
                                                               height: userView.frame.height))
        userView.addSubview(todayJoinChallengeView)
    }
}

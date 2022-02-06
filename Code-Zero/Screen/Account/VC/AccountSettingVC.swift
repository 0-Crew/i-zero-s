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

    // MARK: - Property
    let settingListText = ["계정 공개 범위", "계정 관리"]

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setSettingList()
    }

    func setSettingList() {
        settingListView.enumerated().forEach {
            let settingLineView = SettingLineView(frame: CGRect(x: 0,
                                                                y: 0,
                                                                width: self.view.frame.width - 60,
                                                                height: $1.frame.height))

            $1.addSubview(settingLineView)
            settingLineView.settingLabel.text = settingListText[$0]

            let tapGesture = UITapGestureRecognizer(target: self,
                                                    action: #selector(settingListDidTap(sender:)))
            $1.addGestureRecognizer(tapGesture)
        }
    }

    @objc func settingListDidTap(sender: UITapGestureRecognizer) {
        print("tap")
    }
}

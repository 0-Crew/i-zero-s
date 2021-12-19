//
//  ViewController.swift
//  Code-Zero
//
//  Created by 이주혁 on 2021/10/11.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var appTitleLabel: UILabel!
    @IBOutlet weak var appDescriptionLabel: UILabel!
    @IBOutlet weak var onboardingButton: UIButton!
    @IBOutlet weak var kakaoSignInButton: UIButton!
    @IBOutlet weak var appleSignInButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        // Do any additional setup after loading the view.
    }

}

extension HomeVC {
    func initView() {
        appTitleLabel.setTextWithLineHeight(letterSpacing: 1.35 ,lineHeight: 54)
        appDescriptionLabel.setTextWithLineHeight(lineHeight: 21)

        onboardingButton.setBorder(borderColor: .white, borderWidth: 1.0)
    }
}

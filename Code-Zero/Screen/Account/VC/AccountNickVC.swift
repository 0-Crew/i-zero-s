//
//  AccountNickVC.swift
//  Code-Zero
//
//  Created by 미니 on 2022/02/06.
//

import UIKit

class AccountNickVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var nickView: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nickTextField: UITextField!

    // MARK: - Property
    var email: String = "xwoud@naver.com"
    var nick: String = "희영룰루루"

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        nickView.setBorder(borderColor: .gray2, borderWidth: 1)
        emailLabel.text = email
        nickTextField.text = nick
        nickTextField.delegate = self
    }
}

extension AccountNickVC: UITextFieldDelegate {

}

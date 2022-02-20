//
//  AccountDeleteVC.swift
//  Code-Zero
//
//  Created by 미니 on 2022/02/20.
//

import UIKit

class AccountDeleteVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var alertView: UIView!

    // MARK: - @IBAction
    @IBAction func okButtonDidTap(_ sender: UIButton) {

    }
    @IBAction func cancleButtonDidTap(_ sender: UIButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        alertView.dropShadow(color: .black, offSet: CGSize(width: 0, height: 0), opacity: 0.15, radius: 10)
    }

}

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
        // swiftlint:disable line_length
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjYsImVtYWlsIjoieTR1cnRpam5makBwcml2YXRlcmVsYXkuYXBwbGVpZC5jb20iLCJuYW1lIjpudWxsLCJpYXQiOjE2NTYxNzUyMzQsImV4cCI6MTY1NjE5NjgzNCwiaXNzIjoiV1lCIn0.w8ZoXG2nltbVHONMRAG_pIIiO5PkZsjZW-rupWQfWI0"
        // swiftlint:enable line_length
        deleteUser(token: token)

    }
    @IBAction func cancleButtonDidTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        alertView.dropShadow(color: .black,
                             offSet: CGSize(width: 0, height: 0),
                             opacity: 0.15,
                             radius: 10)
    }

    // MARK: - Function
    private func changeRootViewToHome() {
        let storybard = UIStoryboard(name: "Home", bundle: nil)
        let homeNavigationVC = storybard.instantiateViewController(withIdentifier: "Home")
        UIApplication.shared.windows.first?.replaceRootViewController(
            homeNavigationVC,
            animated: true,
            completion: nil
        )
    }
    private func deleteUser(token: String) {
        UserLoginService.shared.deleteUser(token: token) { [weak self] result in
            switch result {
            case .success:
                self?.dismiss(animated: true) {
                    self?.changeRootViewToHome()
                }
            case .requestErr:
                print("requestErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
}

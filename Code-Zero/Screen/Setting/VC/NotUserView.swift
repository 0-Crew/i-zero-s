//
//  NotUserView.swift
//  Code-Zero
//
//  Created by 미니 on 2022/01/25.
//

import UIKit

class NotUserView: UIView {

    // MARK: - Property
    var moveViewController: ((UIViewController) -> Void)?

    // MARK: - override
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - @IBAction
    @IBAction func signUpButtonDidTap(_ sender: UIButton) {
        guard let moveViewController = moveViewController else { return }
        let storybard = UIStoryboard(name: "SignUp", bundle: nil)
        let signInVC = storybard.instantiateViewController(withIdentifier: "SignInVC")
        moveViewController(signInVC)
    }

    // MARK: - View Layout Style
    private func loadView() {

        guard let view = Bundle.main.loadNibNamed("NotUserView",
                                                  owner: self,
                                                  options: nil)?.first as? UIView else { return }

        view.frame = bounds
        view.backgroundColor = .none
        addSubview(view)
    }
}

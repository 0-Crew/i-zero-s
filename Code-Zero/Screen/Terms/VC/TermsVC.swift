//
//  TermsVC.swift
//  Code-Zero
//
//  Created by Hailey on 2022/07/13.
//

import UIKit

class TermsVC: UIViewController {

    // MARK: - Property
    var type: TermsType = .PrivacyPolicy
    
    // MARK: - @IBOutlet
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var contentTitle: UILabel!
    @IBOutlet weak var contentMessage: UILabel!
    
    // MARK: - @IBAction
    @IBAction func backButtonDidTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setContent()
    }
    
    // MARK: - View Contents
    private func setContent() {
        backButton.setTitle("", for: .normal)
        navigationTitle.text = type.title
        contentTitle.text = type.contentTitle
        contentMessage.setTextLetterSpacing(letterSpacing: -0.5)
        contentMessage.setTextWithLineHeight(lineHeight: 24)
        contentMessage.text = type.message
    }
}

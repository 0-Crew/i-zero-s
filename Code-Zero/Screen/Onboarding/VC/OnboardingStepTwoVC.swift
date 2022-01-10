//
//  OnboardingStepTwoVC.swift
//  Code-Zero
//
//  Created by 주혁 on 2021/12/21.
//

import UIKit
import SnapKit

class OnboardingStepTwoVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var descriptionView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startAnimation()
    }

    private func initView() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40 * deviceHeightRatio)
        }
        logoImageView.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.283)
            $0.top.equalTo(titleLabel.snp.bottom).offset(77 * deviceHeightRatio)
            $0.bottom.equalTo(descriptionView.snp.top).offset(-76 * deviceHeightRatio)
        }
        descriptionView.subviews[2].subviews.forEach {
            $0.setBorder(borderColor: .gray2, borderWidth: 1)
        }
        descriptionView.alpha = 0
        descriptionView.subviews.forEach {
            guard let label = $0 as? UILabel else { return }
            label.setTextLetterSpacing(letterSpacing: -0.5)
            label.setFontWith(font: .spoqaHanSansNeo(size: 16, family: .bold), in: ["편리함", "불편함"])
        }
    }

    private func startAnimation() {
        UIView.animate(
            withDuration: 0.8,
            delay: 0.8,
            options: .curveEaseIn) {
                self.descriptionView.alpha = 1
            }

    }
}

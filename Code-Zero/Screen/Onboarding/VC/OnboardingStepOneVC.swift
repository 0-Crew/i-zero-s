//
//  OnboardingStepOneVC.swift
//  Code-Zero
//
//  Created by 주혁 on 2021/12/19.
//

import UIKit

class OnboardingStepOneVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var descriptionLabels: [UILabel]!
    @IBOutlet weak var nextButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startAnimation()
    }

    private func initView() {
        descriptionLabels[0].setTextLetterSpacing(letterSpacing: -0.5)
        descriptionLabels[1].alpha = 0
        descriptionLabels[2].alpha = 0
    }

    private func startAnimation() {
        descriptionLabels[1...2].enumerated().forEach {
            animateAlphaOrdered(by: $0.offset, view: $0.element)
        }
    }

    private func animateAlphaOrdered(by index: Int, view: UIView, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(
            withDuration: 0.8,
            delay: Double(index) * 0.8,
            options: .curveEaseIn,
            animations: {
                view.alpha = 1
            },
            completion: completion)
    }
}

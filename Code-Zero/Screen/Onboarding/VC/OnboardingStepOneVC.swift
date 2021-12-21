//
//  OnboardingStepOneVC.swift
//  Code-Zero
//
//  Created by 주혁 on 2021/12/19.
//

import UIKit

class OnboardingStepOneVC: UIViewController {

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
        descriptionLabels[1...2].forEach {
            $0.alpha = 0
        }
        nextButton.alpha = 0
    }

    private func startAnimation() {
        animateAlpha(view: descriptionLabels[1]) { _ in
            self.animateAlpha(view: self.descriptionLabels[2]) { _ in
                self.animateAlpha(view: self.nextButton)
            }
        }
    }

    private func animateAlpha(view: UIView, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.8, animations: {
            view.alpha = 1
        }, completion: completion)
    }
}

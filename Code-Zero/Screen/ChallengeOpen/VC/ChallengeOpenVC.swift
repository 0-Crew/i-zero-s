//
//  ChallengeOpenVC.swift
//  Code-Zero
//
//  Created by 주혁 on 2021/12/03.
//

import UIKit

enum ChallengeOpenStep {
    case first
    case second
    case third
}

class ChallengeOpenVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var previousStepButton: UIButton!
    @IBOutlet weak var openStepTitleLabel: UILabel!
    @IBOutlet weak var openStepImageView: UIImageView!

    @IBOutlet weak var scrollView: UIScrollView!
    // MARK: - IBOutlet

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

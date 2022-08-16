//
//  ChallengeFinalVC.swift
//  Code-Zero
//
//  Created by 주혁 on 2022/02/07.
//

import UIKit

class UncompletedChallengeFinalVC: UIViewController {
    // MARK: - Property
    internal var challengeTextList: [String] = [
        "음식 남기지 않기1",
        "음식 남기지 않기2",
        "음식 남기지 않기3",
        "음식 남기지 않기4",
        "음식 남기지 않기5",
        "음식 남기지 않기6",
        "음식 남기지 않기7"
    ]
    internal var challengeStateList: [FinalChallengeViewState] = [
        .challengeComplete,
        .challengeComplete,
        .challengeNotComplete,
        .challengeComplete,
        .challengeNotComplete,
        .challengeNotComplete,
        .challengeNotComplete
    ]

    // MARK: - IBOutlet
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var challengeListStackView: UIStackView!
    @IBOutlet weak var backgroundView: UIView!
    // MARK: - UI Property
    var challengeViewList: [FinalChallengeView] {
        return challengeListStackView.subviews.compactMap {
            $0 as? FinalChallengeView
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    private func initView() {
        challengeViewList.enumerated().forEach {
            let finalChallengeView = $0.element
            finalChallengeView.delegate = self
            finalChallengeView.offset = $0.offset
            finalChallengeView.setState(state: challengeStateList[$0.offset])
            finalChallengeView.challengeTextField.text = challengeTextList[$0.offset]
            finalChallengeView.cachedText = challengeTextList[$0.offset]
        }
        backgroundView.dropShadow(
            color: .init(red: 0, green: 0, blue: 0, alpha: 1),
            offSet: .init(width: 0, height: 2),
            opacity: 0.15,
            radius: 20
        )
    }
}
// MARK: - FinalChallengeViewDelegate
extension UncompletedChallengeFinalVC: FinalChallengeViewDelegate {
    func challengeTextFieldWillEdit(offset: Int) {
        let finalChallengeView = challengeViewList[offset]
        finalChallengeView.challengeTextField.becomeFirstResponder()
        scrollView.setContentOffset(finalChallengeView.frame.origin, animated: true)
        challengeViewList.enumerated().forEach {
            if $0.offset != offset {
                $0.element.challengeTextField.endEditing(false)
                $0.element.setState(state: challengeStateList[$0.offset])
            }
        }
    }

    func challengeTextFieldDidEdit(offset: Int, inputText: String?) {
        let finalChallengeView = challengeViewList[offset]
        finalChallengeView.challengeTextField.endEditing(true)
        challengeTextList[offset] = inputText ?? ""
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }

    func toggleChallengeStateDidTap(offset: Int, state: FinalChallengeViewState) {
        challengeStateList[offset] = state
    }
}

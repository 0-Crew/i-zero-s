//
//  OnboardingStepThreeVC.swift
//  Code-Zero
//
//  Created by 주혁 on 2022/01/16.
//

import UIKit
import SnapKit

class OnboardingStepThreeVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var bottleImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var challengesStackView: UIStackView!
    @IBOutlet weak var initialLineView: UIView!
    @IBOutlet weak var gradientLineView: UIView!
    private let guideView: UIView = {
        let view = UIView()
        let imageView = UIImageView(image: UIImage(named: "imgOnboardingMessage"))

        let label = UILabel()
        label.setLabel(
            text: "체크해 보세요",
            color: .white,
            font: .spoqaHanSansNeo(size: 16, family: .bold)
        )
        view.addSubview(imageView)
        view.addSubview(label)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(22.4)
        }
        return view
    }()

    private var notCompleteCount: Int = 7 {
        didSet {
            updateBottleImageView()
        }
    }
    private var bottleImageLists: [UIImage?] = (0...7)
        .map { UIImage(named: "icBottleMain\($0)") }

    private var challengeListView: [ChallengeView?] {
        return challengesStackView.arrangedSubviews.map { $0 as? ChallengeView}
    }

    internal var challengeTextList: [String] = [
        "음식 남기지 않기1",
        "음식 남기지 않기2",
        "음식 남기지 않기3",
        "음식 남기지 않기4",
        "음식 남기지 않기5",
        "음식 남기지 않기6",
        "음식 남기지 않기7"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
}
// MARK: - UI Setting
extension OnboardingStepThreeVC {
    private func initView() {
        challengeListView.enumerated().forEach {
            let challengeView = $0.element
            challengeView?.challengeOffset = $0.offset
            challengeView?.setChallengeState(state: .onboardingNotCompleted, isMine: true)
            challengeView?.setChallengeText(text: challengeTextList[$0.offset])
            challengeView?.delegate = self
            if $0.offset == challengeListView.count - 1 {
                challengeView?.dateLabel.textColor = .orangeMain
                challengeView?.highlightingView.setBorder(borderColor: .gray1, borderWidth: 1)
                challengeView?.highlightingView.isHidden = false
            }
        }
        gradientLineView.setGradient(
            startColor: .orangeMain,
            endColor: UIColor(red: 70, green: 65, blue: 57)
        )
        updateBottleImageView()
        guideView.frame = CGRect(
            x: 21,
            y: challengeListView[1]?.frame.maxY ?? 0,
            width: 140,
            height: 54.4
        )
        scrollView.addSubview(guideView)
    }
    private func updateBottleImageView() {
        bottleImageView.image = bottleImageLists[7 - notCompleteCount]
    }
}
// MARK: - ChallengeViewDelegate
extension OnboardingStepThreeVC: ChallengeViewDelegate {
    func didToggleChallengeStateAction(challengeOffset: Int, currentState: ChallengeState) {
        guideView.isHidden = true
        if currentState == .onboardingNotCompleted {
            notCompleteCount += 1
        } else {
            notCompleteCount -= 1
        }
    }
}

// MARK: - UIScrollViewDelegate
extension OnboardingStepThreeVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        initialLineView.isHidden = scrollView.contentOffset.y > 4.0
    }
}

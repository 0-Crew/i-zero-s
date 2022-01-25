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
    @IBOutlet weak var challengeTermLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var challengesStackView: UIStackView!
    @IBOutlet weak var initialLineView: UIView!
    @IBOutlet weak var gradientLineView: UIView!
    // MARK: - UI Property
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
    private var bottleImageList: [UIImage?] = (0...7)
        .map { UIImage(named: "icBottleMain\($0)") }
    private var challengeViewList: [ChallengeView?] {
        return challengesStackView.arrangedSubviews.map { $0 as? ChallengeView}
    }
    // MARK: - Property
    private var notCompleteCount: Int = 7 {
        didSet {
            updateBottleImageView()
        }
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
    private var todayTotalDateString: String {
        return Date().datePickerToString(format: "MM.dd")
    }
    private var todayDayString: String {
        return todayTotalDateString
            .components(separatedBy: ".")
            .last ?? ""
    }
    private var todayMonthString: String {
        return todayTotalDateString
            .components(separatedBy: ".")
            .first ?? ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
}
// MARK: - UI Setting
extension OnboardingStepThreeVC {
    private func initView() {
        let startDate = Date().getDateIntervalBy(intervalDay: -6)?.datePickerToString(format: "MM.dd") ?? ""
        let endDate = Date().datePickerToString(format: "dd")
        challengeTermLabel.text = "\(startDate) - \(endDate)"
        challengeViewList.enumerated().forEach {
            initChallengeView(offset: $0.offset, challengeView: $0.element)
        }
        gradientLineView.setGradient(
            startColor: .orangeMain,
            endColor: UIColor(red: 70, green: 65, blue: 57)
        )
        updateBottleImageView()
        guideView.frame = CGRect(
            x: 21,
            y: challengeViewList[1]?.frame.maxY ?? 0,
            width: 140,
            height: 54.4
        )
        scrollView.addSubview(guideView)
    }
    private func initChallengeView(offset: Int, challengeView: ChallengeView?) {
        challengeView?.challengeOffset = offset
        challengeView?.setChallengeState(state: .onboardingNotCompleted, isMine: true)
        challengeView?.setChallengeDate(date: Date().getDateIntervalBy(intervalDay: offset - 6))
        challengeView?.setChallengeText(text: challengeTextList[offset])
        challengeView?.delegate = self
        if offset == challengeViewList.count - 1 {
            challengeView?.setChallengeState(state: .onboardingTodayNotCompleted, isMine: true)
        }
    }
    private func updateBottleImageView() {
        bottleImageView.image = bottleImageList[7 - notCompleteCount]
    }
}
// MARK: - ChallengeViewDelegate
extension OnboardingStepThreeVC: ChallengeViewDelegate {
    func didToggleChallengeStateAction(challengeOffset: Int, currentState: ChallengeState) {
        guideView.isHidden = true
        if currentState == .onboardingNotCompleted || currentState == .onboardingTodayNotCompleted {
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

//
//  UncompletedChallengeFinalFixableVC.swift
//  Code-Zero
//
//  Created by 주혁 on 2022/02/07.
//

import UIKit

class UncompletedChallengeFinalFixableVC: UIViewController {
    // MARK: - Property
    internal var challengeData: MainChallengeData?
    internal var userInfo: UserInfo?
    internal var inconveniences: [Convenience] = []
    internal var challengeStateList: [FinalChallengeViewState] {
        return inconveniences.compactMap {
            return $0.mapFinalChallengeViewState()
        }
    }
    internal var challengeTextList: [String] {
        return inconveniences.map { $0.name }
    }

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
        backgroundView.dropShadow(
            color: .init(red: 0, green: 0, blue: 0, alpha: 1),
            offSet: .init(width: 0, height: 2),
            opacity: 0.15,
            radius: 20
        )
        bindChallengeList()
    }

    private func bindChallengeList() {
        guard let startDate = challengeData?.myChallenge?.startedAt.toDate() else { return }
        challengeViewList.enumerated().forEach {
            let finalChallengeView = $0.element
            let inconvenience = inconveniences[$0.offset]
            finalChallengeView.delegate = self
            finalChallengeView.offset = $0.offset
            finalChallengeView.setChallengeDate(date: inconvenience.getDueDate(challengeStartDate: startDate))
            finalChallengeView.setState(state: challengeStateList[$0.offset])
            finalChallengeView.challengeTextField.text = challengeTextList[$0.offset]
            finalChallengeView.cachedChallengeText = challengeTextList[$0.offset]
        }
    }

    @IBAction func emptyBottleButtonDidTap(sender: Any) {
        let isCheckedList = inconveniences.map { $0.isFinished }
        let allInconveniencesChecked = isCheckedList.allSatisfy {
            guard let isFinished = $0 else { return false }
            return isFinished
        }
        presentChallengeFinalVC(isCompleted: allInconveniencesChecked)
    }

    internal func presentChallengeFinalVC(isCompleted: Bool) {
        let storyboard = UIStoryboard(name: "ChallengeFinal", bundle: nil)
        let destinationIdentifier = isCompleted ?
        "CompletedChallengeFinalVC" : "UncompletedChallengeFinalVC"
        let finalVC = storyboard.instantiateViewController(withIdentifier: destinationIdentifier)
        if isCompleted {
            guard let finalVC = finalVC as? CompletedChallengeFinalVC else { return }
            finalVC.modalPresentationStyle = .fullScreen
            finalVC.myChallenge = challengeData?.myChallenge
            self.present(finalVC, animated: true)
        } else {
            guard let finalVC = finalVC as? UncompletedChallengeFinalVC else { return }
            finalVC.modalPresentationStyle = .fullScreen
            finalVC.modalTransitionStyle = .crossDissolve
            finalVC.myChallenge = challengeData?.myChallenge
            finalVC.userNickname = userInfo?.name ?? ""
            self.present(finalVC, animated: true)
        }
    }
}
// MARK: - FinalChallengeViewDelegate
extension UncompletedChallengeFinalFixableVC: FinalChallengeViewDelegate {
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
        guard let inputText = inputText else { return }

        let finalChallengeView = challengeViewList[offset]
        let inconvenience = inconveniences[offset]
        updateInconvenience(
            inconvenience: inconvenience,
            willChangingText: inputText
        ) { [weak self] (isSuccess, changedInconvenince) in
            if isSuccess, let changedInconvenience = changedInconvenince {
                self?.inconveniences[offset] = changedInconvenience
                finalChallengeView.setChallengeText(text: inputText)
                finalChallengeView.challengeTextField.endEditing(true)
            }
        }
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }

    func toggleChallengeStateDidTap(offset: Int, state: FinalChallengeViewState) {
        let inconvenience = inconveniences[offset]
        toggleInconvenienceComplete(inconvenience: inconvenience) { [weak self] isSuccess, inconvenience in
            if isSuccess, let inconvenience = inconvenience {
                self?.inconveniences[offset] = inconvenience
            }
        }
    }
}

// MARK: - Network
extension UncompletedChallengeFinalFixableVC {
    internal func updateInconvenience(
        inconvenience: Convenience,
        willChangingText: String,
        completion: @escaping (Bool, Convenience?) -> Void
    ) {
        guard let token = accessToken else { return }
        Indicator.shared.show()
        MainChallengeService
            .shared
            .requestUpdateMyInconvenienceText(
                token: token,
                inconvenience: inconvenience,
                willChangingText: willChangingText
            ) { result in
                switch result {
                case .success((let isSuccess, let inconvenience)):
                    DispatchQueue.main.async {
                        completion(isSuccess, inconvenience)
                    }
                case .requestErr(let message):
                    print(message)
                case .serverErr:
                    break
                case .networkFail:
                    break
                }
                Indicator.shared.dismiss()
            }
    }

    internal func toggleInconvenienceComplete(
        inconvenience: Convenience,
        completion: @escaping (Bool, Convenience?) -> Void
    ) {
        guard let token = accessToken else { return }
        Indicator.shared.show()
        MainChallengeService
            .shared
            .requestCompleteMyInconvenience(token: token, inconvenience: inconvenience) { result in
                switch result {
                case .success((let isSuccess, let inconvenience)):
                    DispatchQueue.main.async {
                        completion(isSuccess, inconvenience)
                    }
                case .requestErr(let message):
                    print(message)
                case .serverErr:
                    break
                case .networkFail:
                    break
                }
                Indicator.shared.dismiss()
            }
    }
}

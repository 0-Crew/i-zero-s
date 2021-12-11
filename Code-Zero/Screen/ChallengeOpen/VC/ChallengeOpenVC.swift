//
//  ChallengeOpenVC.swift
//  Code-Zero
//
//  Created by 주혁 on 2021/12/03.
//

import UIKit
import SnapKit

typealias UserInputTextTuple = (convenienceText: String, inconvenienceText: String, isTodayStart: Bool?)

protocol ChallengeOpenStepViewType {
    var delegate: ChallengeOpenStepDelegate? { get set }
    func presentStep(userInput: UserInputTextTuple?)
}

extension ChallengeOpenStepViewType {
    func presentStep(userInput: UserInputTextTuple? = nil) { }
}

protocol ChallengeOpenStepDelegate: AnyObject {
    func challengeStep(step: ChallengeOpenStep, inputString string: String)
    func challengeStepCanPass(step: ChallengeOpenStep, canPass: Bool)
}

class ChallengeOpenVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var previousStepButton: UIButton!
    @IBOutlet weak var openStepTitleLabel: UILabel!
    @IBOutlet weak var openStepImageView: UIImageView!
    @IBOutlet weak var progressContainerView: UIView!
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var firstStepView: ChallengeOpenFirstStepView!
    @IBOutlet weak var secondStepView: ChallengeOpenSecondStepView!
    @IBOutlet weak var thirdStepView: ChallengeOpenThirdStepView!
    @IBOutlet weak var nextButton: UIButton!

    // MARK: - Property
    private var progressBarTrailingConstraints: Constraint?
    private lazy var stepViewList: [ChallengeOpenStepViewType] = [
        firstStepView, secondStepView, thirdStepView
    ]
    private var currentStep: ChallengeOpenStep = .first {
        didSet {
            currentShowingStepView = stepViewList[currentStep.rawValue]
            setOpenView(step: currentStep)
        }
    }
    private lazy var currentShowingStepView: ChallengeOpenStepViewType = firstStepView {
        didSet {
            let parameter = currentStep == .third ? userInputTextTuple : nil
            currentShowingStepView.presentStep(userInput: parameter)
        }
    }
    private var userInputTextTuple: UserInputTextTuple = ("", "", nil)

    // MARK: - Lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        unregisterForKeyboardNotifications()
    }

    // MARK: - IBAction Method
    @IBAction func nextButtonDidTap() {
        guard let nextStep = ChallengeOpenStep(rawValue: currentStep.rawValue + 1) else {
            // TODO: 챌린지 오픈 완료 시 동작
            return
        }
        view.endEditing(true)
        currentStep = nextStep
        present(to: nextStep)
    }
    @IBAction func previousButtonDidTap() {
        guard let previousStep = ChallengeOpenStep(rawValue: currentStep.rawValue - 1) else {
            dismiss(animated: true, completion: nil)
            return
        }
        view.endEditing(true)
        currentStep = previousStep
        present(to: previousStep)
    }
}
// MARK: - UI Method
extension ChallengeOpenVC {
    private func initView() {
        previousStepButton.tintColor = .gray4
        progressBarView.snp.makeConstraints {
            let progressWidth = self.progressContainerView.frame.width
            let trailingConstants = progressWidth / 3 - progressWidth
            $0.top.leading.bottom.equalToSuperview()
            progressBarTrailingConstraints = $0.trailing
                .equalToSuperview()
                .offset(trailingConstants)
                .constraint
        }
        // next button init
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.setTitleColor(.gray3, for: .disabled)
        setNextButtonState(isEnable: false)
        // step view delegate
        [firstStepView, secondStepView, thirdStepView].forEach {
            var view = $0 as? ChallengeOpenStepViewType
            view?.delegate = self
        }
    }

    private func present(to step: ChallengeOpenStep) {
        let viewWidth = Int(view.bounds.width)
        let contentOffset: CGPoint = .init(x: viewWidth * step.rawValue, y: 0)
        scrollView.setContentOffset(contentOffset, animated: true)
        // progress bar animation
        let progressWidth = progressContainerView.bounds.width
        let constants = progressWidth * CGFloat(step.rawValue + 1) / 3 - progressWidth
        progressBarTrailingConstraints?.update(offset: constants)
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            options: .curveEaseIn
        ) {
            self.progressContainerView.layoutIfNeeded()
        }
    }

    private func setNextButtonState(isEnable: Bool) {
        nextButton.isEnabled = isEnable
        nextButton.backgroundColor = isEnable ? .orangeMain : .gray2
    }

    private func setOpenView(step: ChallengeOpenStep) {
        previousStepButton.setImage(step.previousButtonImage, for: .normal)
        openStepTitleLabel.text = step.openStepTitleText
        openStepImageView.image = step.openStepImage
        nextButton.setTitle(step.nextStepTitle, for: .normal)
    }
}

// MARK: - ChallengeOpenStepDelegate
extension ChallengeOpenVC: ChallengeOpenStepDelegate {
    func challengeStep(step: ChallengeOpenStep, inputString string: String) {
        switch step {
        case .first:
            userInputTextTuple.convenienceText = string
        case .second:
            userInputTextTuple.inconvenienceText = string
        case .third:
            break
        }
    }

    func challengeStepCanPass(step: ChallengeOpenStep, canPass: Bool) {
        setNextButtonState(isEnable: canPass)
    }
}

// MARK: - Keyboard Notification Setting
extension ChallengeOpenVC {
    // keyboard가 보여질 때 어떤 동작을 수행
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard
            let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }
        let keyboardHeight: CGFloat = keyboardFrame.cgRectValue.height
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: .init(rawValue: curve)
        ) {
            let transfrom = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            self.nextButton.transform = transfrom
        }
        if currentStep == .second {
            scrollView.setContentOffset(.init(x: scrollView.contentOffset.x, y: 76), animated: true)
        }

    }

    // keyboard가 사라질 때 어떤 동작을 수행
    @objc func keyboardWillHide(_ notification: NSNotification) {
        self.nextButton.transform = .identity
        if currentStep == .second {
            scrollView.setContentOffset(.init(x: scrollView.contentOffset.x, y: 0), animated: true)
        }
    }

    // observer
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
}

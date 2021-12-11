//
//  ChallengeOpenThirdStepView.swift
//  Code-Zero
//
//  Created by 주혁 on 2021/12/04.
//

import UIKit

class ChallengeOpenThirdStepView: LoadXibView, ChallengeOpenStepViewType {

    // MARK: - IBOutlet
    @IBOutlet weak var convenienceTextLabel: UILabel!
    @IBOutlet weak var inconvenienceTextLabel: UILabel!
    @IBOutlet weak var fromTodayButton: UIButton!
    @IBOutlet weak var fromTomorrowButton: UIButton!

    // MARK: - Property
    private lazy var fromDateButtonList: [UIButton] = [fromTodayButton, fromTomorrowButton]
    private var fromDateButtonIsSelectedList: [Bool] = [false, false] {
        didSet {
            fromDateButtonIsSelectedList.enumerated().forEach {
                setButtonState(
                    button: fromDateButtonList[$0.offset],
                    isSelected: $0.element
                )
            }
        }
    }
    internal weak var delegate: ChallengeOpenStepDelegate?

    // MARK: - Lifecycle Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }

    // MARK: - UI Setting
    private func initView() {
        [fromTodayButton, fromTomorrowButton].forEach {
            guard let button = $0 else { return }
            button.setBorder(borderColor: .orangeMain, borderWidth: 1.0)
            button.setTitleColor(.orangeMain, for: .normal)
            button.setTitleColor(.white, for: .selected)
            setButtonState(button: button, isSelected: false)
        }
    }

    private func setButtonState(button: UIButton, isSelected: Bool) {
        button.isSelected = isSelected
        button.backgroundColor = isSelected ? .orangeMain : .white
    }

    // MARK: - IBAction
    @IBAction func fromDateButtonsDidTap(sender: UIButton) {
        var state = [false, false]

        if sender.isSelected {
            fromDateButtonIsSelectedList = state
        } else {
            state[sender.tag].toggle()
            fromDateButtonIsSelectedList = state
        }

        let canComplete = fromDateButtonIsSelectedList.contains(true)
        delegate?.challengeStepCanPass(step: .third, canPass: canComplete)
    }
}

// MARK: - ChallengeOpenStepViewType
extension ChallengeOpenThirdStepView {
    func presentStep(userInput: UserInputTextTuple?) {
        let canComplete = fromDateButtonIsSelectedList.contains(true)
        delegate?.challengeStepCanPass(step: .third, canPass: canComplete)

        if let userInput = userInput {
            convenienceTextLabel.text = userInput.convenienceText
            inconvenienceTextLabel.text = userInput.inconvenienceText
        }
    }
}

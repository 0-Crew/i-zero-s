//
//  ChallengeListCell.swift
//  Code-Zero
//
//  Created by 주혁 on 2021/11/20.
//

import UIKit
import SnapKit

protocol ChallengeListCellDelegate: AnyObject {
    func didCalendarButtonTap()
}

class ChallengeListCell: UICollectionViewCell {

    // MARK: - Property
    private var bottleImageLists: [UIImage?] = (0...7)
        .map { "icBottleMain\($0)" }
        .map { UIImage(named: $0) }

    internal var challengeStateList: [ChallengeState] = [
        .didChallengeCompleted,
        .didChallengeCompleted,
        .didChallengeNotCompleted,
        .didChallengeCompleted,
        .didChallengeNotCompleted,
        .didChallengeNotCompleted,
        .challengingNotCompleted
    ] {
        didSet {
            updateBottleImageView(stateList: challengeStateList)
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
    internal var optionsList: [String] = [
        "선택지1",
        "선택지2",
        "선택지3",
        "선택지4",
        "선택지5",
        "선택지6",
        "직접입력"
    ]
    private var editingChallengeOffset: Int?

    internal weak var delegate: ChallengeListCellDelegate?
    internal var isMine: Bool!

    // MARK: - IBOutlet
    @IBOutlet weak var bottleImageView: UIImageView!
    @IBOutlet weak var initialLineView: UIView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var challengeListStackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }

    // MARK: - UI Property
    private var challengeViewList: [ChallengeView?] {
        return challengeListStackView.arrangedSubviews.map { $0 as? ChallengeView }
    }

    lazy var optionsTableView: UITableView = {
        let width = bounds.width - 81 - 20
        let tableView = UITableView(frame: .init(x: 81, y: 0, width: width, height: 134))
        tableView.backgroundColor = .white
        tableView.setBorder(borderColor: .orangeMain, borderWidth: 1)
        tableView.separatorStyle = .none
        tableView.contentInset = .init(top: 7, left: 0, bottom: 7, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.registerCell(cellType: OptionCell.self)

        return tableView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
        registerForKeyboardNotifications()
    }

    deinit {
        unregisterForKeyboardNotifications()
    }

    private func initView() {
        scrollView.addSubview(optionsTableView)
        lineView.setGradient(
            startColor: .orangeMain,
            endColor: UIColor(red: 70, green: 65, blue: 57)
        )
        if UIScreen.main.bounds.height <= 667 {
            scrollView.contentInset = .init(top: 0, left: 0, bottom: 83, right: 0)
        }
        setChallengeListCell(isMine: true)
        updateBottleImageView(stateList: challengeStateList)
    }

    private func updateBottleImageView(stateList: [ChallengeState]) {
        let remainCount = 7 - stateList
            .filter {
                $0 == .willChallenge || $0 == .challengingNotCompleted || $0 == .didChallengeNotCompleted
            }
            .count

        bottleImageView.image = bottleImageLists[remainCount]
    }

    internal func setChallengeListCell(isMine: Bool) {
        self.isMine = isMine
        challengeViewList.enumerated().forEach {
            let challengView = $0.element
            challengView?.delegate = isMine ? self : nil
            setChallengeText(offset: $0.offset, text: challengeTextList[$0.offset])
            challengView?.setChallengeText(text: challengeTextList[$0.offset])
            challengView?.challengeTextField.text = challengeTextList[$0.offset]
            challengView?.setChallengeState(state: challengeStateList[$0.offset], isMine: isMine)
            challengView?.challengeOffset = $0.offset
        }
    }

    private func setChallengeText(offset: Int, text: String) {
        let challengeView = challengeViewList[offset]
        challengeView?.setChallengeText(text: text)
    }
    private func setChallengeViewChaingingState(offset: Int) {
        let challengeView = challengeViewList[offset]
        challengeView?.toggleIsChangingState(to: offset == editingChallengeOffset)
    }

    private func setChallengeTextFieldState(offset: Int) {
        let challengeView = challengeViewList[offset]
        challengeView?.toggleTextEditingState(to: offset == editingChallengeOffset)
    }

    private func presentOptionTableView(yPosition: CGFloat) {
        var mutableYPosition = yPosition + 43 + 8
        let isOver = mutableYPosition + 134 > challengeListStackView.bounds.maxY
        let width = bounds.width - 81 - 20

        mutableYPosition = isOver ? yPosition - 8 - 134 : mutableYPosition
        optionsTableView.frame = .init(x: 81, y: mutableYPosition, width: width, height: 134)
        optionsTableView.isHidden = false
    }

    @IBAction func calendarButtonDidTap(sender: UIButton) {
        delegate?.didCalendarButtonTap()
    }
}

extension ChallengeListCell: ChallengeViewDelegate {
    func didChallengeTextFieldEdit(challengeOffset: Int, text: String) {
        editingChallengeOffset = nil
        optionsTableView.isHidden = true
        setChallengeViewChaingingState(offset: challengeOffset)
        setChallengeTextFieldState(offset: challengeOffset)
        setChallengeText(offset: challengeOffset, text: text)
    }

    func didEditButtonTap(challengeOffset: Int, yPosition: CGFloat) {
        if challengeOffset == editingChallengeOffset {
            editingChallengeOffset = nil
            optionsTableView.isHidden = true
            setChallengeViewChaingingState(offset: challengeOffset)
        } else {
            if let previousOffset = editingChallengeOffset {
                editingChallengeOffset = challengeOffset
                setChallengeViewChaingingState(offset: previousOffset)
                setChallengeViewChaingingState(offset: challengeOffset)
            } else {
                editingChallengeOffset = challengeOffset
                setChallengeViewChaingingState(offset: challengeOffset)
            }

            presentOptionTableView(yPosition: yPosition)
        }
    }

    func didToggleChallengeStateAction(challengeOffset: Int, currentState: ChallengeState) {
        challengeStateList[challengeOffset] = currentState
    }
}

extension ChallengeListCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.initialLineView.isHidden = scrollView.contentOffset.y > 4.0
    }
}

extension ChallengeListCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let offset = editingChallengeOffset else { return }

        if indexPath.row == optionsList.count - 1 {
            setChallengeTextFieldState(offset: offset)
            tableView.isHidden = true
            return
        }

        let willChangeText = optionsList[indexPath.row]
        editingChallengeOffset = nil
        tableView.isHidden = true
        setChallengeText(offset: offset, text: willChangeText)
        setChallengeViewChaingingState(offset: offset)
    }
}

extension ChallengeListCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OptionCell = tableView.dequeueCell(indexPath: indexPath)
        cell.optionTextLabel.text = optionsList[indexPath.row]
        return cell
    }
}

extension ChallengeListCell {

    // keyboard가 보여질 때 어떤 동작을 수행
    @objc func keyboardWillShow(_ notification: NSNotification) {

        guard
            let offset = editingChallengeOffset,
            let challengeView = challengeViewList[offset]
        else { return }

        let contentOffset: CGPoint = .init(x: 0, y: challengeView.frame.minY)
        scrollView.setContentOffset(contentOffset, animated: true)
    }

    // keyboard가 사라질 때 어떤 동작을 수행
    @objc func keyboardWillHide(_ notification: NSNotification) {
        let contentOffset: CGPoint = .init(x: 0, y: 0)
        scrollView.setContentOffset(contentOffset, animated: true)
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

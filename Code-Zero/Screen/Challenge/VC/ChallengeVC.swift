//
//  ChallengeVC.swift
//  Code-Zero
//
//  Created by 이주혁 on 2021/11/09.
//

import UIKit
import SnapKit

class ChallengeVC: UIViewController {

    // MARK: - Property
    internal var userInfo: UserInfo?
    internal var challengeData: MainChallengeData?
    internal var followingPeopleList: [User] = [] {
        didSet {
            setFollowingListStackView()
        }
    }
    internal var inconveniences: [Convenience] = [] {
        didSet {
            updateBottleImageView()
        }
    }
    // 다른 유저의 챌린지를 조회할 때 세팅해야할 프로퍼티
    // isMine: 다른 유저일 경우 무저건 isMine = false 설정
    // fetchedUserId: 받아올 유저에 대한 id 값
    internal var isMine: Bool! = true
    internal var fetchedUserId: Int?

    // MARK: UI Data Property
    private var bottleImageLists: [UIImage?] = (0...7)
        .map { "icBottleMain\($0)" }
        .map { UIImage(named: $0) }

    private var challengeStateList: [ChallengeState] {
        return inconveniences.compactMap {
            guard
                let challengeData = challengeData,
                let startDate = challengeData.myChallenge?.startedAt.toDate()
            else {
                return .didChallengeNotCompleted
            }

            return $0.mapChallengeState(challengeStartDate: startDate)
        }
    }
    private var challengeTextList: [String] {
        return inconveniences.map { $0.name }
    }

    internal var optionsList: [String] = [] {
        didSet {
            optionsTableView.reloadData()
        }
    }
    internal var editingChallengeOffset: Int?

    // MARK: - UI Components
    internal lazy var optionsTableView: UITableView = {
        let width = view.bounds.width - 81 - 20
        let tableView = UITableView(frame: .init(x: 81, y: 0, width: width, height: 134))
        // tableView setting
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
    private lazy var alarmButton: UIBarButtonItem = {
        let button: UIButton = .init(type: .custom)
        button.frame = .init(x: 0, y: 0, width: 24, height: 24)
        button.setImage(UIImage(named: "icAlarm"), for: .normal)
        button.addTarget(self, action: #selector(alarmButtonDidTap), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        return barButtonItem
    }()
    private lazy var menuButton: UIBarButtonItem = {
        let button: UIButton = .init(type: .custom)
        button.frame = .init(x: 0, y: 0, width: 24, height: 24)
        button.setImage(UIImage(named: "icMenu"), for: .normal)
        button.addTarget(self, action: #selector(menuButtonDidTap), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        return barButtonItem
    }()
    private lazy var emptyView: EmptyChallengeView = EmptyChallengeView(frame: .zero, isMine: isMine)
    lazy var eventToastView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray2
        view.addSubview(toastTitleLabel)

        toastTitleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        return view
    }()
    lazy var toastTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .spoqaHanSansNeo(size: 14, family: .medium)
        label.textColor = .white
        return label
    }()
    internal var challengeViewList: [ChallengeView?] {
        return challengeListStackView.arrangedSubviews.map { $0 as? ChallengeView }
    }

    // MARK: IBOutlet
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var followingListStackView: UIStackView!
    @IBOutlet weak var cheerUpButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var dateTermLabel: UILabel!
    @IBOutlet weak var convenienceTextLabel: UILabel!
    @IBOutlet weak var challengeBackgroundView: UIView!
    @IBOutlet weak var bottleImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var initialLineView: UIView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var challengeListStackView: UIStackView!

    // MARK: - Lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItems()
        challengeBackgroundView.alpha = 0
        followingButton.setBorder(borderColor: .orangeMain, borderWidth: 1)
        emptyView.delegate = self
        scrollView.delegate = self
        scrollView.addSubview(optionsTableView)
        lineView.setGradient(
            startColor: .orangeMain,
            endColor: UIColor(red: 70, green: 65, blue: 57)
        )
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        registerForKeyboardNotifications()

        if isMine {
            fetchUserInfoData()
            fetchMyChallenge()
        } else {
            fetchUserChallenge(userId: fetchedUserId)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        unregisterForKeyboardNotifications()
    }

    // MARK: - IBAction Method

    @IBAction func cheerUpButtonDidTap(_ sender: Any) {
        guard let userName = userInfo?.name else { return }
        cheerUpUser { [weak self] isSuccess in
            if isSuccess {
                self?.presentToastView(text: "\(userName)님에게 챌린지 응원을 보냈어요!")
            }
        }
    }

    @IBAction func followingButtonDidTap(_ sender: Any) {
        // TODO: 팔로잉 버튼 액션
    }

    @IBAction private func moveBottleWorldButtonDidTap() {
        let storyboard = UIStoryboard(name: "BottleWorld", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "BottleWorldVC")
        navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction func didCalendarButtonTap() {
        let storyboard = UIStoryboard(name: "Calendar", bundle: nil)
        guard let calendarVC = storyboard.instantiateViewController(withIdentifier: "CalendarVC")
                as? CalendarVC else { return }
        calendarVC.modalPresentationStyle = .custom
        calendarVC.transitioningDelegate = self
        present(calendarVC, animated: true, completion: nil)
    }

    @objc private func followingListButtonsDidTab(sender: UIButton) {
        let user = followingPeopleList[sender.tag]
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "ChallengeVC")
                as? ChallengeVC else { return }

        viewController.isMine = false
        viewController.fetchedUserId = user.id
        navigationController?.pushViewController(viewController, animated: true)
    }

    // MARK: - Field Method
}

// MARK: - UI Setting
extension ChallengeVC {
    private func setNavigationItems() {
        if !isMine { return }
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 8
        navigationItem.setRightBarButtonItems(
            [menuButton, space, alarmButton],
            animated: false
        )
        let backButtonImage = UIImage(named: "icArrow")?.withAlignmentRectInsets(
            UIEdgeInsets(top: 0.0, left: -10.0, bottom: 0.0, right: 0.0)
        )
        backButtonImage?.withTintColor(.gray4)
        self.navigationController?.navigationBar.backIndicatorImage = backButtonImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
        navigationItem.backBarButtonItem?.tintColor = .gray4
    }
    private func setFollowingListStackView() {
        if !isMine {
            followingListStackView.isHidden = true
            return
        }
        resetFollowingListStackView()
        switch followingPeopleList.map({ $0.name }).count {
        case 0:
            let button = UIButton(type: .custom)
            button.setButton(text: "다른 보틀보기", font: .spoqaHanSansNeo(size: 12, family: .medium))
            button.setTitleColor(.gray3, for: .normal)
            button.addTarget(self, action: #selector(moveBottleWorldButtonDidTap), for: .touchUpInside)
            followingListStackView.insertArrangedSubview(button, at: 1)
        case 1...2:
            followingPeopleList
                .enumerated()
                .map { (offset, element) -> UIButton in
                    let text = element.name.map { "\($0)" }.first ?? ""
                    let button = makeFollowingListButton(text: text)
                    button.tag = offset
                    return button
                }
                .reversed()
                .forEach {
                    $0.addTarget(
                        self, action: #selector(followingListButtonsDidTab(sender:)), for: .touchUpInside
                    )
                    followingListStackView.insertArrangedSubview($0, at: 0)
                }
        default:
            followingPeopleList[0..<3]
                .enumerated()
                .map { (offset, element) -> UIButton in
                    let text = element.name.map { "\($0)" }.first ?? ""
                    let button = makeFollowingListButton(text: text)
                    button.tag = offset
                    return button
                }
                .reversed()
                .forEach {
                    $0.addTarget(
                        self, action: #selector(followingListButtonsDidTab(sender:)), for: .touchUpInside
                    )
                    followingListStackView.insertArrangedSubview($0, at: 0)
                }
        }
    }
    private func makeFollowingListButton(text: String) -> UIButton {
        let followingPersonButton: UIButton = {
            let button = UIButton(type: .custom)
            button.snp.makeConstraints {
                $0.width.equalTo(24)
            }
            button.makeRounded(cornerRadius: 12.5)
            button.setBorder(borderColor: .gray3, borderWidth: 1.0)
            button.setButton(
                text: text,
                font: .spoqaHanSansNeo(size: 12, family: .medium)
            )
            return button
        }()
        return followingPersonButton
    }
    private func resetFollowingListStackView() {
        followingListStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let plusButton = UIButton(type: .custom)
        plusButton.setImage(.init(named: "icPlus"), for: .normal)
        plusButton.addTarget(
            self,
            action: #selector(moveBottleWorldButtonDidTap),
            for: .touchUpInside
        )
        followingListStackView.addArrangedSubview(plusButton)
    }
    internal func bindChallenge(
        challenge: UserChallenge?,
        inconveniences: [Convenience],
        conveniences: [Convenience]
    ) {
        guard
            let challenge = challenge
        else {
            setEmptyView()
            return
        }
        emptyView.removeFromSuperview()

        guard
            let startDate = challenge.startedAt.toDate(),
            let endDate = challenge.startedAt.toDate()?.getDateIntervalBy(intervalDay: 6)
        else {
            return
        }
        let startDateText = startDate.datePickerToString(format: "MM.dd")
        let endDateText = endDate.datePickerToString(format: "dd")
        dateTermLabel.text = "\(startDateText) - \(endDateText)"
        convenienceTextLabel.text = challenge.name
        self.inconveniences = inconveniences
        optionsList = conveniences.map { $0.name } + ["직접입력"]
        inconveniences
            .map { $0.getDueDate(challengeStartDate: startDate) }
            .enumerated()
            .forEach {
                setChallengeDate(offset: $0.offset, dueDate: $0.element)
            }
        setChallengeViewList()
    }
    private func setChallengeViewList() {
        challengeViewList.enumerated().forEach {
            let challengView = $0.element
            challengView?.delegate = isMine ? self : nil
            challengView?.challengeOffset = $0.offset
            challengView?.setChallengeText(text: challengeTextList[$0.offset])
            challengView?.setChallengeState(state: challengeStateList[$0.offset], isMine: isMine)
        }
    }
    private func changeFollowingListFirstNames(names: [String]) {
        followingListStackView.arrangedSubviews.enumerated().forEach { (offset, view) in
            let button = view as? UIButton
            button?.setTitle(names[offset], for: .normal)
        }
    }
    private func setEmptyView() {
        view.addSubview(emptyView)
        emptyView.backgroundColor = .gray3
        emptyView.snp.makeConstraints {
            $0.top.equalTo(followingButton.snp.bottom)
            $0.bottom.leading.trailing.equalTo(challengeBackgroundView)
        }
    }
    internal func updateSocialButtons(isFollowing: Bool) {
        let isChallenging = challengeData?.myChallenge != nil
        cheerUpButton.isHidden = (isChallenging == false) || isMine
        followingButton.isHidden = isMine && isFollowing
    }
    private func updateBottleImageView() {

        let remainCount = 7 - challengeStateList.filter {
                $0 == .willChallenge || $0 == .challengingNotCompleted || $0 == .didChallengeNotCompleted
            }.count

        bottleImageView.image = bottleImageLists[remainCount]
    }
    internal func setChallengeTextByOptionSelected(offset: Int, text: String) {
        let challengeView = challengeViewList[offset]
        challengeView?.setChallengeText(text: text)
    }
    private func setChallengeDate(offset: Int, dueDate: Date?) {
        let challengeView = challengeViewList[offset]
        challengeView?.setChallengeDate(date: dueDate)
    }
    internal func setChallengeTextFieldState(offset: Int) {
        let challengeView = challengeViewList[offset]
        challengeView?.toggleTextEditingState(to: offset == editingChallengeOffset)
    }
    internal func setChallengeViewChangingState(offset: Int) {
        let challengeView = challengeViewList[offset]
        challengeView?.toggleIsChangingState(to: offset == editingChallengeOffset)
    }
    internal func setChallengeText(offset: Int, text: String) {
        let challengeView = challengeViewList[offset]
        challengeView?.setChallengeText(text: text)
    }
    internal func presentOptionTableView(yPosition: CGFloat) {
        var mutableYPosition = yPosition + 43 + 8
        let isOver = mutableYPosition + 134 > challengeListStackView.bounds.maxY
        let width = view.bounds.width - 81 - 20

        mutableYPosition = isOver ? yPosition - 8 - 134 : mutableYPosition
        optionsTableView.frame = .init(x: 81, y: mutableYPosition, width: width, height: 134)
        optionsTableView.isHidden = false
    }
    private func presentToastView(text: String) {
        eventToastView.alpha = 0
        toastTitleLabel.text = text
        view.addSubview(eventToastView)
        eventToastView.snp.makeConstraints {

            $0.bottom.equalToSuperview().offset(-60)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(57)
        }

        UIView.animateKeyframes(withDuration: 2, delay: 0, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/20, animations: {
                self.eventToastView.alpha = 1
            })
            UIView.addKeyframe(withRelativeStartTime: 19/20, relativeDuration: 1/20, animations: {
                self.eventToastView.alpha = 0
            })

        }, completion: { _ in
            self.eventToastView.removeFromSuperview()
        })
    }
}

// MARK: - Move Controller
extension ChallengeVC {
    @objc private func menuButtonDidTap() {
        let storybard = UIStoryboard(name: "Setting", bundle: nil)
        guard let settingVC = storybard.instantiateViewController(withIdentifier: "SettingVC")
                as? SettingVC else { return }
        settingVC.userInfo = userInfo
        navigationController?.pushViewController(settingVC, animated: true)
    }
    @objc func alarmButtonDidTap() {
        let storyboard = UIStoryboard(name: "AlarmCenter", bundle: nil)
        guard
            let viewController = storyboard
                .instantiateViewController(withIdentifier: "AlarmCenterVC") as? AlarmCenterVC
        else {
            return
        }
        self.show(viewController, sender: nil)
    }
    internal func changeRootViewToHome() {
        let storybard = UIStoryboard(name: "Home", bundle: nil)
        let homeNavigationVC = storybard.instantiateViewController(withIdentifier: "Home")
        UIApplication.shared.windows.first?.replaceRootViewController(
            homeNavigationVC,
            animated: true,
            completion: nil
        )
    }
}

extension ChallengeVC: UIViewControllerTransitioningDelegate {
       func presentationController(forPresented presented: UIViewController,
                                   presenting: UIViewController?,
                                   source: UIViewController) -> UIPresentationController? {
           return HalfModalPresentationController(presentedViewController: presented,
                                                  presenting: presenting)
       }
}

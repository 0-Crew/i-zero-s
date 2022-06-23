//
//  ChallengeVC.swift
//  Code-Zero
//
//  Created by 이주혁 on 2021/11/09.
//

import UIKit
import SnapKit

class ChallengeVC: UIViewController {

    // swiftlint:disable line_length
    let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjAsImVtYWlsIjoieTR1cnRpam5makBwcml2YXRlcmVsYXkuYXBwbGVpZC5jb20iLCJuYW1lIjoi67SJ6rWs7Iqk67Cl66mNIiwiaWRGaXJlYmFzZSI6IkpoaW16VDdaUUxWcDhmakx3c1U5eWw1ZTNaeDIiLCJpYXQiOjE2NTM0ODk4MTAsImV4cCI6MTY1NjA4MTgxMCwiaXNzIjoiV1lCIn0.5oevdqhJA_NhURaD3-OOCwbUE92GvcXDndAFPW3vOHE"
    // swiftlint:enable line_length

    // MARK: - Property
    private var userInfo: UserInfo?
    private var challengeData: MyChallengeData?
    private var followingPeopleList: [User] = [] {
        didSet {
            setFollowingListStackView()
        }
    }
    // MARK: UI Data Property
    private var bottleImageLists: [UIImage?] = (0...7)
        .map { "icBottleMain\($0)" }
        .map { UIImage(named: $0) }

    private var inconveniences: [Convenience] = [] {
        didSet {
            updateBottleImageView()
        }
    }
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

    private var optionsList: [String] = [] {
        didSet {
            optionsTableView.reloadData()
        }
    }
    internal var editingChallengeOffset: Int?
    // 내 챌린지인지 체크
    internal var isMine: Bool! = true

    // MARK: - UI Components
    private lazy var optionsTableView: UITableView = {
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
        fetchMyChallenge()
        fetchUserInfoData()
        updateSocialButtons()
        registerForKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        unregisterForKeyboardNotifications()
    }

    // MARK: - IBAction Method

    @IBAction func cheerUpButtonDidTap(_ sender: Any) {
        // TODO: 응원하기 버튼 액션
    }

    @IBAction func followingButtonDidTap(_ sender: Any) {
        // TODO: 팔로잉 버튼 액션
    }

    @IBAction private func moveBottleWorldButtonDidTap() {
        // TODO: Bottle World로 연결하는 부분
        print("move to bottle world")
    }

    @IBAction func didCalendarButtonTap() {
        let storyboard = UIStoryboard(name: "Calendar", bundle: nil)
        let calendarVC = storyboard.instantiateViewController(withIdentifier: "CalendarVC")
        present(calendarVC, animated: true, completion: nil)
    }

    @objc private func followingListButtonsDidTab(sender: UIButton) {
        // TODO: 해당 유저에 대한 챌린지 정보로 이동하는 버튼 넣기
//        let indexPath = IndexPath(item: sender.tag, section: 0)
//        selectedPersonIndex = sender.tag
//        challengeListCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }

    // MARK: - Field Method
}

// MARK: - ChallengeViewDelegate
extension ChallengeVC: ChallengeViewDelegate {
    // 텍스트 필드 편집 완료 이벤트 delegate
    func didChallengeTextFieldEdit(challengeOffset: Int, text: String) {
        let inconvenience = inconveniences[challengeOffset]
        updateInconvenience(
            inconvenience: inconvenience,
            willChangingText: text) { [weak self] (isSuccess, changedInconvenince) in
                if isSuccess, let changedInconvenince = changedInconvenince {
                    self?.editingChallengeOffset = nil
                    self?.optionsTableView.isHidden = true
                    self?.inconveniences[challengeOffset] = changedInconvenince
                    self?.setChallengeViewChangingState(offset: challengeOffset)
                    self?.setChallengeTextFieldState(offset: challengeOffset)
                    self?.setChallengeText(offset: challengeOffset, text: text)
                }
            }
    }
    // 편집, 취소, 완료 버튼 이벤트 delegate
    func didEditButtonTap(challengeOffset: Int, yPosition: CGFloat) {
        // 편집 중인 챌린지가 없을 경우
        guard editingChallengeOffset != nil else {
            editingChallengeOffset = challengeOffset
            setChallengeViewChangingState(offset: challengeOffset)
            presentOptionTableView(yPosition: yPosition)
            return
        }
        // 편집을 취소 하거나 완료한 경우
        if challengeOffset == editingChallengeOffset {
            editingChallengeOffset = nil
            optionsTableView.isHidden = true
            setChallengeViewChangingState(offset: challengeOffset)
            return
        }
        // 현재 편집중인 경우
        return
    }
    // 챌린지 완료 상태 toggle 이벤트 delegate
    func didToggleChallengeStateAction(challengeOffset: Int, currentState: ChallengeState) {
        let inconvenience = inconveniences[challengeOffset]
        toggleInconvenienceComplete(inconvenience: inconvenience) { [weak self] (isSuccess, inconvenience) in
            if isSuccess, let inconvenience = inconvenience {
                self?.inconveniences[challengeOffset] = inconvenience
            } else {
                self?.setChallengeViewChangingState(offset: challengeOffset)
            }
        }
    }
}

// MARK: - UIScrollViewDelegate
extension ChallengeVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.initialLineView.isHidden = scrollView.contentOffset.y > 4.0
    }
}

// MARK: - UITableViewDelegate
extension ChallengeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let offset = editingChallengeOffset,
            let editingChallengeOffset = editingChallengeOffset
        else { return }

        if indexPath.row == optionsList.count - 1 {
            setChallengeTextFieldState(offset: offset)
            tableView.isHidden = true
            return
        }
        let willChangeText = optionsList[indexPath.row]
        let inconvenience = inconveniences[editingChallengeOffset]

        updateInconvenience(
            inconvenience: inconvenience,
            willChangingText: willChangeText
        ) { [weak self] (isSuccess, inconvenience) in
                if isSuccess, let inconvenience = inconvenience {
                    self?.inconveniences[editingChallengeOffset] = inconvenience
                    self?.editingChallengeOffset = nil
                    tableView.isHidden = true
                    self?.setChallengeTextByOptionSelected(offset: offset, text: willChangeText)
                    self?.setChallengeViewChangingState(offset: offset)
                }
            }
    }
}

// MARK: - UITableViewDataSource
extension ChallengeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OptionCell = tableView.dequeueCell(indexPath: indexPath)
        cell.setCellType(type: .challenge)
        cell.optionTextLabel.text = optionsList[indexPath.row]
        return cell
    }
}

// MARK: - EmptyChallengeViewDelegate
extension ChallengeVC: EmptyChallengeViewDelegate {
    func didPresentCalendarViewDidTap() {
        // TODO: 캘린더 뷰 여는 부분 연결
        let storyboard = UIStoryboard(name: "Calendar", bundle: nil)
        let calendarVC = storyboard.instantiateViewController(withIdentifier: "CalendarVC")
        present(calendarVC, animated: true, completion: nil)
    }

    func didStartChallengeViewTap() {
        let challengeOpenStoryboard = UIStoryboard(name: "ChallengeOpen", bundle: nil)
        guard let challengeOpenVC = challengeOpenStoryboard.instantiateViewController(
            withIdentifier: "ChallengeOpenVC"
        ) as? ChallengeOpenVC else { return }
        present(challengeOpenVC, animated: true, completion: nil)
    }
}

// MARK: - UI Setting
extension ChallengeVC {
    private func setNavigationItems() {
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 8
        self.navigationItem.setRightBarButtonItems(
            [menuButton, space, alarmButton],
            animated: false
        )
    }
    private func setFollowingListStackView() {
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
    private func updateSocialButtons() {
        let isChallenging = true
        cheerUpButton.isHidden = (isChallenging == false) || isMine
        followingButton.isHidden = isMine
    }
    private func updateBottleImageView() {

        let remainCount = 7 - challengeStateList.filter {
                $0 == .willChallenge || $0 == .challengingNotCompleted || $0 == .didChallengeNotCompleted
            }.count

        bottleImageView.image = bottleImageLists[remainCount]
    }
    private func setChallengeTextByOptionSelected(offset: Int, text: String) {
        let challengeView = challengeViewList[offset]
        challengeView?.setChallengeText(text: text)
    }
    private func setChallengeDate(offset: Int, dueDate: Date?) {
        let challengeView = challengeViewList[offset]
        challengeView?.setChallengeDate(date: dueDate)
    }
    private func setChallengeTextFieldState(offset: Int) {
        let challengeView = challengeViewList[offset]
        challengeView?.toggleTextEditingState(to: offset == editingChallengeOffset)
    }
    private func setChallengeViewChangingState(offset: Int) {
        let challengeView = challengeViewList[offset]
        challengeView?.toggleIsChangingState(to: offset == editingChallengeOffset)
    }
    private func setChallengeText(offset: Int, text: String) {
        let challengeView = challengeViewList[offset]
        challengeView?.setChallengeText(text: text)
    }
    private func presentOptionTableView(yPosition: CGFloat) {
        var mutableYPosition = yPosition + 43 + 8
        let isOver = mutableYPosition + 134 > challengeListStackView.bounds.maxY
        let width = view.bounds.width - 81 - 20

        mutableYPosition = isOver ? yPosition - 8 - 134 : mutableYPosition
        optionsTableView.frame = .init(x: 81, y: mutableYPosition, width: width, height: 134)
        optionsTableView.isHidden = false
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
    private func changeRootViewToHome() {
        let storybard = UIStoryboard(name: "Home", bundle: nil)
        let homeNavigationVC = storybard.instantiateViewController(withIdentifier: "Home")
        UIApplication.shared.windows.first?.replaceRootViewController(
            homeNavigationVC,
            animated: true,
            completion: nil
        )
    }
}

// MARK: - Network
extension ChallengeVC {
    private func fetchUserInfoData() {
        UserSettingService.shared.requestUserInfo(token: token) { [weak self] result in
            switch result {
            case .success(let info):
                self?.userInfo = info.user
                self?.nickNameLabel.text = info.user.name
            case .requestErr(let error):
                print(error)
            case .serverErr:
                // 토큰 만료(자동 로그아웃 느낌..)
                self?.changeRootViewToHome()
            case .networkFail:
                // TODO: 서버 자체 에러 - 서버 점검 중 popup 제작?
                break
            }
        }
    }

    internal func fetchMyChallenge() {
        MainChallengeService
            .shared
            .requestMyChallenge(token: token) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.challengeBackgroundView.alpha = 1
                    self?.challengeData = data
                    let challenge = data.myChallenge
                    let myInconveniences = data.myInconveniences
                    let inconveniences = data.inconvenience

                    self?.followingPeopleList = data.myFollowings
                    self?.bindChallenge(
                        challenge: challenge,
                        inconveniences: myInconveniences,
                        conveniences: inconveniences
                    )
                case .requestErr(let message):
                    print(message)
                case .serverErr:
                    break
                case .networkFail:
                    break
                }
            }
    }

    internal func toggleInconvenienceComplete(
        inconvenience: Convenience,
        completion: @escaping (Bool, Convenience?) -> Void
    ) {
        MainChallengeService
            .shared
            .requestCompleteMyInconvenience(
                token: token,
                inconvenience: inconvenience
            ) { result in
                switch result {
                case .success((let isSuccess, let inconvenience)):
                    completion(isSuccess, inconvenience)
                case .requestErr(let message):
                    print(message)
                case .serverErr:
                    break
                case .networkFail:
                    break
                }
            }
    }

    internal func updateInconvenience(
        inconvenience: Convenience,
        willChangingText: String,
        completion: @escaping (Bool, Convenience?) -> Void
    ) {
        MainChallengeService
            .shared
            .requestUpdateMyInconvenienceText(
                token: token,
                inconvenience: inconvenience,
                willChangingText: willChangingText
            ) { result in
                switch result {
                case .success((let isSuccess, let inconvenience)):
                    completion(isSuccess, inconvenience)
                case .requestErr(let message):
                    print(message)
                case .serverErr:
                    break
                case .networkFail:
                    break
                }
            }
    }
}

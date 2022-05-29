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
    private var userInfo: UserInfo?
    private var followingPeopleList: [String] = [
        "김", "이", "박"
    ]
    // MARK: UI Data Property
    private var bottleImageLists: [UIImage?] = (0...7)
        .map { "icBottleMain\($0)" }
        .map { UIImage(named: $0) }
    private var challengeStateList: [ChallengeState] = [
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
    private var optionsList: [String] = [
        "선택지1",
        "선택지2",
        "선택지3",
        "선택지4",
        "선택지5",
        "선택지6",
        "직접입력"
    ]
    private var editingChallengeOffset: Int?
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
    private lazy var emptyView: EmptyChallengeView = EmptyChallengeView(frame: .zero)
    private var challengeViewList: [ChallengeView?] {
        return challengeListStackView.arrangedSubviews.map { $0 as? ChallengeView }
    }

    // MARK: IBOutlet
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var followingListStackView: UIStackView!
    @IBOutlet weak var cheerUpButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
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
        fetchFollowingPeopleFirstNameList()
        followingButton.setBorder(borderColor: .orangeMain, borderWidth: 1)
        setFollowingListStackView()
        setChallengeViewList()
        emptyView.delegate = self
        scrollView.delegate = self
        scrollView.addSubview(optionsTableView)
        lineView.setGradient(
            startColor: .orangeMain,
            endColor: UIColor(red: 70, green: 65, blue: 57)
        )
        updateSocialButtons()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        fetchUserInfoData()
        registerForKeyboardNotifications()
//        setEmptyView() Empty view 세팅
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
    private func fetchFollowingPeopleFirstNameList() {
        followingPeopleList = [
//            "김", "나"
        ]
    }
}

// MARK: - ChallengeViewDelegate
extension ChallengeVC: ChallengeViewDelegate {
    // 텍스트 필드 편집 완료 이벤트 delegate
    func didChallengeTextFieldEdit(challengeOffset: Int, text: String) {
        editingChallengeOffset = nil
        optionsTableView.isHidden = true
        setChallengeViewChangingState(offset: challengeOffset)
        setChallengeTextFieldState(offset: challengeOffset)
        setChallengeText(offset: challengeOffset, text: text)
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
        challengeStateList[challengeOffset] = currentState
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

        guard let offset = editingChallengeOffset else { return }

        if indexPath.row == optionsList.count - 1 {
            setChallengeTextFieldState(offset: offset)
            tableView.isHidden = true
            return
        }

        let willChangeText = optionsList[indexPath.row]
        editingChallengeOffset = nil
        tableView.isHidden = true
        setChallengeTextByOptionSelected(offset: offset, text: willChangeText)
        setChallengeViewChangingState(offset: offset)
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
        switch followingPeopleList.count {
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
                    let button = makeFollowingListButton(text: element)
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
                    let button = makeFollowingListButton(text: element)
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
        emptyView.snp.makeConstraints {
            $0.top.equalTo(followingListStackView.snp.bottom)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
    private func updateSocialButtons() {
        let isChallenging = true
//        let isChallenging = followingPeopleChallengingLists[offset].isChallenging
        cheerUpButton.isHidden = (isChallenging == false) || isMine
        followingButton.isHidden = isMine
    }
    private func updateBottleImageView(stateList: [ChallengeState]) {
        let remainCount = 7 - stateList.filter {
                $0 == .willChallenge || $0 == .challengingNotCompleted || $0 == .didChallengeNotCompleted
            }.count

        bottleImageView.image = bottleImageLists[remainCount]
    }
    private func setChallengeTextByOptionSelected(offset: Int, text: String) {
        let challengeView = challengeViewList[offset]
        challengeView?.setChallengeText(text: text)
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

// MARK: - Keyboard Notification Setting
extension ChallengeVC {

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
        // swiftlint:disable line_length
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjAsImVtYWlsIjoieTR1cnRpam5makBwcml2YXRlcmVsYXkuYXBwbGVpZC5jb20iLCJuYW1lIjoi67SJ6rWs7Iqk67Cl66mNIiwiaWRGaXJlYmFzZSI6IkpoaW16VDdaUUxWcDhmakx3c1U5eWw1ZTNaeDIiLCJpYXQiOjE2NTM0ODk4MTAsImV4cCI6MTY1NjA4MTgxMCwiaXNzIjoiV1lCIn0.5oevdqhJA_NhURaD3-OOCwbUE92GvcXDndAFPW3vOHE"
        // swiftlint:enable line_length
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
}

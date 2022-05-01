//
//  ChallengeVC.swift
//  Code-Zero
//
//  Created by 이주혁 on 2021/11/09.
//

import UIKit
import SnapKit

class ChallengeVC: UIViewController {

    typealias FollowingPepleChallengeTuple = (firstName: String, isChallenging: Bool)

    // MARK: - Property
    // followingPeopleChallengingLists[0] bool 값을 false 로 바꾸면 Empty View 보입니다.
    private var followingPeopleChallengingLists: [FollowingPepleChallengeTuple] = [
        ("김", true), ("이", false), ("박", false)
    ]
    private var selectedPersonIndex: Int = 0 {
        didSet {
            highlightingFollowingListButton(offset: selectedPersonIndex)
            updateSocialButtons(offset: selectedPersonIndex)
        }
    }
    private var userInfo: UserInfo?

    // MARK: - UI Components
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

    // MARK: IBOutlet
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var followingListStackView: UIStackView!
    @IBOutlet weak var cheerUpButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var challengeListCollectionView: UICollectionView!

    // MARK: - Lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItems()
        fetchFollowingPeopleFirstNameList()
        followingButton.setBorder(borderColor: .orangeMain, borderWidth: 1)
        setFollowingListStackView()
        setCollectionView()
        highlightingFollowingListButton(offset: selectedPersonIndex)
        updateSocialButtons(offset: selectedPersonIndex)
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        fetchUserInfoData()
    }

    // MARK: - IBAction Method

    @IBAction func cheerUpButtonDidTap(_ sender: Any) {

    }

    @IBAction func followingButtonDidTap(_ sender: Any) {

    }

    @IBAction func alarmButtonDidTap() {
        let storyboard = UIStoryboard(name: "AlarmCenter", bundle: nil)
        guard
            let viewController = storyboard
                .instantiateViewController(withIdentifier: "AlarmCenterVC") as? AlarmCenterVC
        else {
            return
        }
        self.show(viewController, sender: nil)
    }

    @objc private func followingListButtonsDidTab(sender: UIButton) {
        let indexPath = IndexPath(item: sender.tag, section: 0)
        selectedPersonIndex = sender.tag
        challengeListCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    // MARK: - Field Method
    private func fetchFollowingPeopleFirstNameList() {
        followingPeopleChallengingLists = [
            ("김", false),
            ("이", true),
            ("박", false)
        ]
    }

}

// MARK: - UICollectionViewDataSource
extension ChallengeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return followingPeopleChallengingLists.count <= 3 ? 3 : followingPeopleChallengingLists.count
    }
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        if followingPeopleChallengingLists[indexPath.item].isChallenging {
            let cell: ChallengeListCell = collectionView.dequeueCell(indexPath: indexPath)
            cell.setChallengeListCell(isMine: indexPath.item == 0)
            cell.delegate = self
            return cell
        }

        let cell: EmptyChallengeCell = collectionView.dequeueCell(indexPath: indexPath)
        cell.setEmptyChallengeView(isMine: indexPath.item == 0)
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ChallengeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}

// MARK: - UIScrollViewDelegate
extension ChallengeVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        selectedPersonIndex = Int(scrollView.contentOffset.x / view.bounds.width)
    }
}

// MARK: - ChallengeListCellDelegate
extension ChallengeVC: ChallengeListCellDelegate {
    func didCalendarButtonTap() {
        let storyboard = UIStoryboard(name: "Calendar", bundle: nil)
        let calendarVC = storyboard.instantiateViewController(withIdentifier: "CalendarVC")
        present(calendarVC, animated: true, completion: nil)
    }
}

extension ChallengeVC: EmptyChallengeCellDelegate {
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
        let menuButton: UIBarButtonItem = {
            let button: UIButton = .init(type: .custom)
            button.frame = .init(x: 0, y: 0, width: 24, height: 24)
            button.setImage(UIImage(named: "icMenu"), for: .normal)
            let barButtonItem = UIBarButtonItem(customView: button)
            return barButtonItem
        }()

        let alarmButton: UIBarButtonItem = {
            let button: UIButton = .init(type: .custom)
            button.frame = .init(x: 0, y: 0, width: 24, height: 24)
            button.setImage(UIImage(named: "icAlarm"), for: .normal)
            button.addTarget(self, action: #selector(alarmButtonDidTap), for: .touchUpInside)
            let barButtonItem = UIBarButtonItem(customView: button)
            barButtonItem.target = self
            barButtonItem.action = #selector(alarmButtonDidTap)
            return barButtonItem
        }()

        let space = UIBarButtonItem(
            barButtonSystemItem: .fixedSpace,
            target: nil,
            action: nil
        )
        space.width = 8

        self.navigationItem.setRightBarButtonItems(
            [menuButton, space, alarmButton],
            animated: false
        )
    }
    private func setFollowingListStackView() {
        followingPeopleChallengingLists[0..<3]
            .enumerated()
            .map { (offset, element) -> UIButton in
                let button = makeFollowingListButton(text: element.firstName)
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
    private func setCollectionView() {
        challengeListCollectionView.registerCell(nibName: "ChallengeListCell")
        challengeListCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.top.equalTo(self.followingListStackView.snp.bottom).offset(97 * deviceHeightRatio)
        }
    }
    private func makeFollowingListButton(text: String) -> UIButton {
        let followingPersonButton: UIButton = {
            let button = UIButton(type: .custom)
            button.snp.makeConstraints {
                $0.width.equalTo(24)
            }
            button.makeRounded(cornerRadius: 12.5)
            button.setButton(
                text: text,
                font: .spoqaHanSansNeo(size: 12, family: .medium)
            )
            return button
        }()
        return followingPersonButton
    }
    private func changeFollowingListFirstNames(names: [String]) {
        followingListStackView.arrangedSubviews.enumerated().forEach { (offset, view) in
            let button = view as? UIButton
            button?.setTitle(names[offset], for: .normal)
        }
    }
    private func highlightingFollowingListButton(offset: Int) {
        followingListStackView.arrangedSubviews[0..<3].enumerated().forEach { (offset, view) in
            guard let button = view as? UIButton else { return }
            let color: UIColor = offset == selectedPersonIndex ? .darkGray2 : .gray3
            button.setTitleColor(color, for: .normal)
            button.setBorder(borderColor: color, borderWidth: 1)
        }
    }
    private func updateSocialButtons(offset: Int) {
        let isMine = offset == 0
        let isChallenging = followingPeopleChallengingLists[offset].isChallenging
        cheerUpButton.isHidden = (isChallenging == false) || isMine
        followingButton.isHidden = isMine
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
        UserInfoService.shared.requestLogin(token: token) { [weak self] result in
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

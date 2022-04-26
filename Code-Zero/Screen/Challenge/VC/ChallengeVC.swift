//
//  ChallengeVC.swift
//  Code-Zero
//
//  Created by 이주혁 on 2021/11/09.
//

import UIKit
import SnapKit

class ChallengeVC: UIViewController {

    typealias FollowingPeopleChallengingTuple = (firstName: String, userChallenge: UserChallenge?)


    // MARK: - Property
    // followingPeopleChallengingLists[0] bool 값을 false 로 바꾸면 Empty View 보입니다.
    private var myChallengeData: MyChallengeData?
    private var followingPeopleChallengingLists: [FollowingPeopleChallengingTuple] = [
        ("김", nil), ("이", nil), ("박", nil)
    ]
    private var selectedPersonIndex: Int = 0 {
        didSet {
            highlightingFollowingListButton(offset: selectedPersonIndex)
            updateSocialButtons(offset: selectedPersonIndex)
        }
    }

    // MARK: - UI Components
    private let menuButton: UIBarButtonItem = {
        let button: UIButton = .init(type: .custom)
        button.frame = .init(x: 0, y: 0, width: 24, height: 24)
        button.setImage(UIImage(named: "icAlarm"), for: .normal)
        let barButtonItem = UIBarButtonItem(customView: button)
        return barButtonItem
    }()
    private let alarmButton: UIBarButtonItem = {
        let button: UIButton = .init(type: .custom)
        button.frame = .init(x: 0, y: 0, width: 24, height: 24)
        button.setImage(UIImage(named: "icMenu"), for: .normal)
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
        followingButton.setBorder(borderColor: .orangeMain, borderWidth: 1)
        setFollowingListStackView()
        setCollectionView()
        highlightingFollowingListButton(offset: selectedPersonIndex)
        updateSocialButtons(offset: selectedPersonIndex)
    }
    // MARK: - IBAction Method

    @IBAction func cheerUpButtonDidTap(_ sender: Any) {

    }

    @IBAction func followingButtonDidTap(_ sender: Any) {

    }

    @objc private func followingListButtonsDidTab(sender: UIButton) {
        let indexPath = IndexPath(item: sender.tag, section: 0)
        selectedPersonIndex = sender.tag
        challengeListCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    // MARK: - Field Method
}

extension ChallengeVC {
    func fetchMyChallenge() {
        // swiftlint:disable line_length
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTgsImVtYWlsIjoieHdvdWRAdGVzdC5jb20iLCJuYW1lIjoibWluaTMiLCJpZEZpcmViYXNlIjoidzZtblY4VklVU1hWY080Q0paVkNPTHowS2F1MiIsImlhdCI6MTY0NTM3NTM4MCwiZXhwIjoxNjQ3OTY3MzgwLCJpc3MiOiJXWUIifQ.JYS2amG9ydX_BeDCYDc93_cWDGhGOQ29Nq2CGW4SpZE"
        // swiftlint:enable line_length
        Indicator.shared.show()
        MainChallengeService
            .shared
            .requestMyChallenge(token: token) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.myChallengeData = data
                case .requestErr(let message):
                    print(message)
                    self?.myChallengeData = nil
                case .serverErr:
                    self?.myChallengeData = nil
                case .networkFail:
                    self?.myChallengeData = nil
                }
                Indicator.shared.dismiss()
            }
    }
}

// MARK: - UICollectionViewDataSource
extension ChallengeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return followingPeopleChallengingLists.count + 1 <= 3 ? 3 : followingPeopleChallengingLists.count
    }
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let isMine = indexPath.item == 0

        if indexPath.item == 0 {
            if let myChallengeDataValue = myChallengeData {
                let cell: ChallengeListCell = collectionView.dequeueCell(indexPath: indexPath)
                cell.setChallengeListCell(isMine: isMine)
                cell.bindChallenge(
                    challenge: myChallengeDataValue.myChallenge,
                    inconveniences: myChallengeDataValue.inconvenience,
                    conveniences: myChallengeDataValue.inconvenience
                )
                cell.delegate = self
                return cell
            } else {
                let cell: EmptyChallengeCell = collectionView.dequeueCell(indexPath: indexPath)
                cell.setEmptyChallengeView(isMine: indexPath.item == 0)
                cell.delegate = self
                return cell
            }
        }

        guard let userChallengeValue = followingPeopleChallengingLists[indexPath.item].userChallenge else {
            let cell: EmptyChallengeCell = collectionView.dequeueCell(indexPath: indexPath)
            cell.setEmptyChallengeView(isMine: isMine)
            cell.delegate = self
            return cell
        }
        let cell: ChallengeListCell = collectionView.dequeueCell(indexPath: indexPath)
        cell.setChallengeListCell(isMine: isMine)
        cell.bindChallenge(challenge: userChallengeValue, inconveniences: [], conveniences: [])
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
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 8
        self.navigationItem.setRightBarButtonItems(
            [alarmButton, space, menuButton],
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

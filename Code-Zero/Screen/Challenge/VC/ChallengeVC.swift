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
        fetchFollowingPeopleFirstNameList()
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
    private func fetchFollowingPeopleFirstNameList() {
        followingPeopleChallengingLists = [
            ("김", true),
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
        // TODO: - 캘린더 뷰 연결할 곳
        print("Calendar Button Presents")
    }
}

extension ChallengeVC: EmptyChallengeCellDelegate {
    func didStartChallengeViewTap() {
        // TODO: - 챌린지 오픈 뷰 연결할 곳
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

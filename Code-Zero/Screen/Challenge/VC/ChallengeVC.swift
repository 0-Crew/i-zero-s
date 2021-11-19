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
    private var followingPeopleFirstNameArray: [String] = ["김", "이", "박"]
    private var selectedPersonIndex: Int = 0

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

    // MARK: - Lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItems()
        fetchFollowingPeopleFirstNameList()
        setFollowingListStackView()
        highlightingFollowingListButton(offset: selectedPersonIndex)
    }

    // MARK: - IBAction Method

    // MARK: - Field Method
    private func fetchFollowingPeopleFirstNameList() {
        followingPeopleFirstNameArray = ["김", "이", "박"]
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
        followingPeopleFirstNameArray[0..<3]
            .map(provideFollowingListButton)
            .reversed()
            .forEach {
                followingListStackView.insertArrangedSubview($0, at: 0)
            }
    }
    private func provideFollowingListButton(text: String) -> UIButton {
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

    private func highlightingFollowingListButton(offset: Int) {
        followingListStackView.arrangedSubviews[0..<3].enumerated().forEach { (offset, view) in
            guard let button = view as? UIButton else { return }
            let color: UIColor = offset == selectedPersonIndex ? .darkGray2 : .gray3
            button.setTitleColor(color, for: .normal)
            button.setBorder(borderColor: color, borderWidth: 1)
        }
    }
    private func changeFollowingListFirstNames(names: [String]) {
        followingListStackView.arrangedSubviews.enumerated().forEach { (offset, view) in
            let button = view as? UIButton
            button?.setTitle(names[offset], for: .normal)
        }
    }
}

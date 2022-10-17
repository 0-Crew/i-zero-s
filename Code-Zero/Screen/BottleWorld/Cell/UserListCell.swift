//
//  UserListCell.swift
//  Code-Zero
//
//  Created by 미니 on 2021/12/13.
//

import UIKit

protocol UserListCellDelegate: AnyObject {
    func didFollowButtonTap(id: Int)
}

class UserListCell: UITableViewCell {

    // MARK: - @IBOutlet
    @IBOutlet weak var bottleBackView: UIView!
    @IBOutlet weak var bottleImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var challengeTermLabel: UILabel!
    @IBOutlet weak var challengeLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!

    // MARK: - @IBAction
    @IBAction func followButtonDidTap(_ sender: UIButton) {
        guard let userId = userId else { return }
        delegate?.didFollowButtonTap(id: userId)
        feedbackGenerator?.impactOccurred()
    }

    // MARK: - Property
    internal var userId: Int?
    internal weak var delegate: UserListCellDelegate?
    private var follow: Bool?
    private var feedbackGenerator: UIImpactFeedbackGenerator?

    override func awakeFromNib() {
        super.awakeFromNib()
        setView()
        setupGenerator()
    }
}

extension UserListCell {
    // MARK: - Style Set Function
    private func setView() {
        bottleBackView.makeRounded(cornerRadius: nil)
        bottleBackView.setBorder(borderColor: .lightGray1, borderWidth: 1)
        followButton.setBorder(borderColor: .orangeMain, borderWidth: 1)
        selectionStyle = .none
    }
    func fetchUserData(data: BottleWorldUser) {
        challengeLabel.textColor = .orangeMain
        data.follow ? setFollowingButton() : setFollowButton()
        follow = data.follow
        userNameLabel.text = "\(data.user.name)의 보틀"
        userNameLabel.setFontWith(font: .futuraStd(size: 13, family: .bold), in: [data.user.name])

        if let challenge = data.challenge {
            let challengeTerm = getChallengeWeek(startDate: challenge.startedAt)
            challengeTermLabel.setLabel(text: challengeTerm,
                                        color: .gray4,
                                        font: .spoqaHanSansNeo(size: 12, family: .medium))
            challengeLabel.isHidden = false
            challengeLabel.text = challenge.name
            bottleImage.image = UIImage(named: "icBottleMain\(challenge.count ?? "0")")
        } else {
            challengeLabel.isHidden = true
            challengeTermLabel.setLabel(text: "보틀 씻는 중",
                                        color: .gray2,
                                        font: .spoqaHanSansNeo(size: 13, family: .bold))
            bottleImage.image = UIImage(named: "icBottleMain7")
        }
    }
    private func setFollowButton() {
        followButton.setButton(text: "팔로우",
                               color: .white,
                               font: .spoqaHanSansNeo(size: 12, family: .bold),
                               backgroundColor: .orangeMain)
    }
    private func setFollowingButton() {
        followButton.setButton(text: "팔로잉",
                               color: .orangeMain,
                               font: .spoqaHanSansNeo(size: 12, family: .bold),
                               backgroundColor: .white)

    }
    private func getChallengeWeek(startDate: String) -> String {
        let startDay = startDate.recordDate(origin: "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
                                            change: "MM.dd")
        let startDayToDate = startDate.toDate()
        let aftertWeekDay = startDayToDate?.getDateIntervalBy(intervalDay: 7)
        guard let lastDay = aftertWeekDay?.description.recordDate(origin: "yyyy-MM-dd HH:mm:ss Z",
                                                                  change: "dd") else {
            return ""
        }
        return "\(startDay) - \(lastDay)"
    }
    private func setupGenerator() {
        feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator?.prepare()
    }
}

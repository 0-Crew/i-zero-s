//
//  UserListCell.swift
//  Code-Zero
//
//  Created by 미니 on 2021/12/13.
//

import UIKit

protocol UserListCellDelegate: AnyObject {
    func didFollowButtonTap(index: Int)
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
        delegate?.didFollowButtonTap(index: cellIndex?.row ?? 0)
    }

    // MARK: - Property
    internal var cellIndex: IndexPath?
    internal weak var delegate: UserListCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setView()
        // Initialization code
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
        challengeTermLabel.isHidden = false
        let challengeTerm = getChallengeWeek(startDate: data.challenge.startedAt)
        challengeTermLabel.text = challengeTerm
        challengeLabel.text = data.challenge.name
        challengeLabel.textColor = .orangeMain
        bottleImage.image = UIImage(named: "icBottleMain\(data.challenge.count ?? "0")")
        data.follow ? setFollowButton() : setFollowingButton()
        userNameLabel.text = "\(data.user.name)의 보틀"
        userNameLabel.setFontWith(font: .futuraStd(size: 13, family: .bold), in: [data.user.name])

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
}

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

    // MARK: - Style Set Function
    private func setView() {
        bottleBackView.makeRounded(cornerRadius: nil)
        bottleBackView.setBorder(borderColor: .lightGray1, borderWidth: 1)
        followButton.setBorder(borderColor: .orangeMain, borderWidth: 1)
        selectionStyle = .none
    }
    func setUserInfo(user: UserData) {
        if user.term != nil {
            challengeTermLabel.isHidden = false
            challengeTermLabel.text = user.term
            challengeLabel.text = user.subject
            challengeLabel.textColor = .orangeMain
        } else {
            challengeTermLabel.isHidden = true
            challengeLabel.text = "보틀 씻는 중"
            challengeLabel.textColor = .gray2
        }
        bottleImage.image = UIImage(named: "icBottleMain\(user.bottleLevel)")
        user.follow ? setFollowButton() : setFollowingButton()
        userNameLabel.text = "\(user.name)의 보틀"
        if let text = userNameLabel.text {
            let attributedStr = NSMutableAttributedString(string: text)
            attributedStr.addAttribute(NSAttributedString.Key(rawValue: kCTFontAttributeName as String),
                                       value: UIFont.futuraStd(size: 13, family: .bold),
                                       range: (text as NSString).range(of: user.name))
            userNameLabel.attributedText = attributedStr
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
}

//
//  UserListCell.swift
//  Code-Zero
//
//  Created by 미니 on 2021/12/13.
//

import UIKit

class UserListCell: UITableViewCell {

    // MARK: - @IBOutlet
    @IBOutlet weak var bottleBackView: UIView!
    @IBOutlet weak var bottleImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var challengeTermLabel: UILabel!
    @IBOutlet weak var challengeLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!

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
    }
    func setUserInfo(userName: String, term: String, challenge: String, isFollow: Bool) {
        userNameLabel.text = "\(userName)의 보틀"
        challengeTermLabel.text = term
        challengeLabel.text = challenge
        isFollow ? setFollowButton() : setFollowingButton()
        if let text = userNameLabel.text {
            let attributedStr = NSMutableAttributedString(string: text)
            attributedStr.addAttribute(NSAttributedString.Key(rawValue: kCTFontAttributeName as String),
                                       value: UIFont.futuraStd(size: 13, family: .bold),
                                       range: (text as NSString).range(of: userName))
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

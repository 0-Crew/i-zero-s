//
//  FollowEmptyView.swift
//  Code-Zero
//
//  Created by 미니 on 2021/12/12.
//

import UIKit

enum EmptyBottleViewType {
    case noneFollowing
    case noneFollower
    case noneSearch
}
extension EmptyBottleViewType {
    var noneLabel: String {
        switch self {
        case .noneFollowing:
            return "다른 보틀을 팔로우해 보세요!"
        case .noneFollower:
            return "아직 팔로워가 없습니다"
        case .noneSearch:
            return "검색 결과가 없습니다"
        }
    }
    var noneImage: String {
        switch self {
        case .noneFollowing:
            return "imgFollowNone"
        case .noneFollower:
            return "imgFollowNone"
        case .noneSearch:
            return "imgSearchNone"
        }
    }
}

class FollowEmptyView: UIView {

    // MARK: Property
    var viewType: EmptyBottleViewType = .noneFollower {
        didSet {
            noneTitleLabel.text = viewType.noneLabel
            emptyImage.image = UIImage(named: viewType.noneImage)
        }
    }

    // MARK: @IBOutlet
    @IBOutlet weak var emptyImage: UIImageView!
    @IBOutlet weak var noneTitleLabel: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }

    // MARK: Init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: View Set Function
    private func loadView() {
        guard let view = Bundle.main.loadNibNamed("FollowEmptyView",
                                                  owner: self,
                                                  options: nil)?.first as? UIView else { return }
        view.frame = bounds
        addSubview(view)
    }
}

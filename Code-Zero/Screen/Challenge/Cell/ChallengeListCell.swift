//
//  ChallengeListCell.swift
//  Code-Zero
//
//  Created by 주혁 on 2021/11/20.
//


import UIKit

import SnapKit

class ChallengeListCell: UICollectionViewCell {
    static let identifier = "ChallengeListCell"

    //MARK: - IBOutlet
    @IBOutlet weak var initialLineView: UIView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var challengeListStackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }

    private func initView() {
        lineView.setGradient(
            startColor: .orangeMain,
            endColor: UIColor(red: 70, green: 65, blue: 57)
        )
        challengeListStackView.arrangedSubviews.enumerated().forEach {
            let challengView = $0.element as? ChallengeView
            challengView?.delegate = self
            challengView?.editButton.tag = $0.offset
        }
    }
}

extension ChallengeListCell: ChallengeViewDelegate {
    func didEditButtonTap(tag: Int) {
        print("\(tag)")
    }


}

extension ChallengeListCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.initialLineView.isHidden = scrollView.contentOffset.y > 4.0
    }
}

// MARK: - ChallengeView

protocol ChallengeViewDelegate {
    func didEditButtonTap(tag: Int)
}

class ChallengeView: UIView {
    @IBOutlet weak var dropWaterImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var challengeTextLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!

    internal var delegate: ChallengeViewDelegate!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
        initView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
        initView()
    }

    private func loadView() {
        let nibs = Bundle.main.loadNibNamed("ChallengeView", owner: self, options: nil)

        guard let xibView = nibs?.first as? UIView else { return }
        xibView.frame = self.bounds
        addSubview(xibView)
        xibView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func initView() {
        backgroundColor = .clear
    }
    

    @IBAction func editButtonDidTap(sender: UIButton) {
        delegate.didEditButtonTap(tag: sender.tag)
    }
}




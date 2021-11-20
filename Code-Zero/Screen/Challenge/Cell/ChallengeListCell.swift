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
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }
    @IBOutlet weak var challengeListStackView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }

    private func initView() {
        lineView.setGradient(
            startColor: .orangeMain,
            endColor: UIColor(red: 70, green: 65, blue: 57)
        )
    }
}

extension ChallengeListCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("🥰\(scrollView.contentOffset.y)")
        self.initialLineView.isHidden = scrollView.contentOffset.y > 4.0
    }
}

// MARK: - ChallengeView

protocol ChallengeViewDelegate {
    func didEditButtonTap()
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
        editButton.isHidden = true
    }
    

    @IBAction func editButtonDidTap(sender: UIButton) {
        delegate.didEditButtonTap()
    }
}




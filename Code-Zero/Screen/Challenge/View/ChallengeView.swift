//
//  ChallengeView.swift
//  Code-Zero
//
//  Created by 주혁 on 2021/11/20.
//

import UIKit

protocol ChallengeViewDelegate: AnyObject {
    func didEditButtonTap(buttonTag: Int)
}

class ChallengeView: UIView {
    @IBOutlet weak var dropWaterImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var challengeTextLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!

    internal weak var delegate: ChallengeViewDelegate!

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
        delegate?.didEditButtonTap(buttonTag: sender.tag)
    }
}

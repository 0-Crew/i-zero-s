//
//  AlarmReactionVC.swift
//  Code-Zero
//
//  Created by 주혁 on 2022/05/09.
//

import UIKit

import Lottie
import SnapKit

extension AlarmType {
    var reactionBackgroundViewColor: UIColor? {
        switch self {
        case .totalCheeredUp, .beCheered:
            return .black
        case .totalCelebrated, .beCelebrated:
            return .white
        default:
            return nil
        }
    }

    var reactionAnimationJsonFileName: String {
        switch self {
        case .totalCheeredUp, .beCheered:
            return "challenge_cheerup"
        case .totalCelebrated, .beCelebrated:
            return "challenge_congratulate"
        default:
            return ""
        }
    }

    var reactionExplainText: String {
        switch self {
        case .totalCheeredUp, .beCheered:
            return "내 챌린지를 응원해요!"
        case .totalCelebrated, .beCelebrated:
            return "챌린지 성공을 축하해줬어요!"
        default:
            return ""
        }
    }

    var reactionLabelTextColor: UIColor? {
        switch self {
        case .totalCheeredUp, .beCheered:
            return .white
        case .totalCelebrated, .beCelebrated:
            return .black
        default:
            return nil
        }
    }

    var totalLookButtonIsHidden: Bool {
        switch self {
        case .totalCheeredUp, .totalCelebrated:
            return false
        default:
            return true
        }
    }

    var totalLookButtonBackgroundColor: UIColor? {
        switch self {
        case .totalCelebrated:
            return .white
        case .totalCheeredUp:
            return .orangeMain
        default:
            return nil
        }
    }

    var totalLookButtonTextColor: UIColor? {
        switch self {
        case .totalCelebrated:
            return .orangeMain
        case .totalCheeredUp:
            return .white
        default:
            return nil
        }
    }

    var totalLookButtonText: String {
        switch self {
        case .totalCelebrated:
            return "축하해 준 친구들 모두보기"
        case .totalCheeredUp:
            return "응원해 준 친구들 모두보기"
        default:
            return ""
        }
    }
}

class AlarmReactionVC: UIViewController {

    internal var alarmType: AlarmType!
    internal var reactingName: String = "이주혁"
    internal var reactingCount: Int = 1

    private var animationView: AnimationView!
    @IBOutlet weak var reactionLabel: UILabel!
    @IBOutlet weak var totalLookButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }

    private func initView() {
        animationView = AnimationView(name: alarmType.reactionAnimationJsonFileName)

        view.backgroundColor = alarmType.reactionBackgroundViewColor
        reactionLabel.textColor = alarmType.reactionLabelTextColor

        totalLookButton.isHidden = alarmType.totalLookButtonIsHidden
        totalLookButton.setTitle(alarmType.totalLookButtonText, for: .normal)
        totalLookButton.setTitleColor(alarmType.totalLookButtonTextColor, for: .normal)
        totalLookButton.backgroundColor = alarmType.totalLookButtonBackgroundColor
        totalLookButton.setBorder(borderColor: .orangeMain, borderWidth: 1.0)

        view.addSubview(animationView)
        animationView.snp.makeConstraints {
            $0.width.equalTo(300)
            $0.height.equalTo(400)
            $0.top.equalTo(reactionLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        animationView.play() { isFinished in
            if isFinished {
                self.dismiss(animated: true)
            }
        }
        setReactionLabel()
    }

    private func setReactionLabel() {
        let firstLine = "\(reactingName)님"
        let countText = reactingCount > 1 ? " 외 \(reactingCount)명이" : "이"
        reactionLabel.text = "\(firstLine)\(countText)\n\(alarmType.reactionExplainText)"
    }

}

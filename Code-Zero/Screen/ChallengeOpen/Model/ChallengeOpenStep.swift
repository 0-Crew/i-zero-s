//
//  ChallengeOpenStep.swift
//  Code-Zero
//
//  Created by 주혁 on 2021/12/11.
//

import UIKit

enum ChallengeOpenStep: Int {
    case first = 0
    case second = 1
    case third = 2
}

extension ChallengeOpenStep {
    var previousButtonImage: UIImage? {
        switch self {
        case .first:
            return UIImage(named: "icXBlack")
        case .second, .third:
            return UIImage(named: "icArrowLeft")?.withRenderingMode(.alwaysTemplate)
        }
    }
    var openStepTitleText: String {
        switch self {
        case .first:
            return "보틀 씻는 중"
        case .second:
            return "거의 다 씻었어요!"
        case .third:
            return "보틀 씻기 완료!"
        }
    }
    var openStepImage: UIImage? {
        switch self {
        case .first, .second:
            return UIImage(named: "icChallengeOpenBottle")
        case .third:
            return UIImage(named: "icNavBottle")
        }
    }
    var nextStepTitle: String {
        switch self {
        case .first, .second:
            return "다음"
        case .third:
            return "챌린지 시작하기"
        }
    }
}

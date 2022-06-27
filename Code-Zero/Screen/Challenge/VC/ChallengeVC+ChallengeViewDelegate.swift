//
//  ChallengeVC+ChallengeViewDelegate.swift
//  Code-Zero
//
//  Created by 주혁 on 2022/06/28.
//

import UIKit

// MARK: - ChallengeViewDelegate
extension ChallengeVC: ChallengeViewDelegate {
    // 텍스트 필드 편집 완료 이벤트 delegate
    func didChallengeTextFieldEdit(challengeOffset: Int, text: String) {
        let inconvenience = inconveniences[challengeOffset]
        updateInconvenience(
            inconvenience: inconvenience,
            willChangingText: text) { [weak self] (isSuccess, changedInconvenince) in
                if isSuccess, let changedInconvenince = changedInconvenince {
                    self?.editingChallengeOffset = nil
                    self?.optionsTableView.isHidden = true
                    self?.inconveniences[challengeOffset] = changedInconvenince
                    self?.setChallengeViewChangingState(offset: challengeOffset)
                    self?.setChallengeTextFieldState(offset: challengeOffset)
                    self?.setChallengeText(offset: challengeOffset, text: text)
                }
            }
    }
    // 편집, 취소, 완료 버튼 이벤트 delegate
    func didEditButtonTap(challengeOffset: Int, yPosition: CGFloat) {
        // 편집 중인 챌린지가 없을 경우
        guard editingChallengeOffset != nil else {
            editingChallengeOffset = challengeOffset
            setChallengeViewChangingState(offset: challengeOffset)
            presentOptionTableView(yPosition: yPosition)
            return
        }
        // 편집을 취소 하거나 완료한 경우
        if challengeOffset == editingChallengeOffset {
            editingChallengeOffset = nil
            optionsTableView.isHidden = true
            setChallengeViewChangingState(offset: challengeOffset)
            return
        }
        // 현재 편집중인 경우
        return
    }
    // 챌린지 완료 상태 toggle 이벤트 delegate
    func didToggleChallengeStateAction(challengeOffset: Int, currentState: ChallengeState) {
        let inconvenience = inconveniences[challengeOffset]
        toggleInconvenienceComplete(inconvenience: inconvenience) { [weak self] (isSuccess, inconvenience) in
            if isSuccess, let inconvenience = inconvenience {
                self?.inconveniences[challengeOffset] = inconvenience
            } else {
                self?.setChallengeViewChangingState(offset: challengeOffset)
            }
        }
    }
}

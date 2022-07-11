//
//  ChallengeVC+UITableView.swift
//  Code-Zero
//
//  Created by 주혁 on 2022/06/28.
//

import UIKit

// MARK: - UIScrollViewDelegate
extension ChallengeVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.initialLineView.isHidden = scrollView.contentOffset.y > 4.0
    }
}

// MARK: - UITableViewDelegate
extension ChallengeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let offset = editingChallengeOffset,
            let editingChallengeOffset = editingChallengeOffset
        else { return }

        if indexPath.row == optionsList.count - 1 {
            setChallengeTextFieldState(offset: offset)
            tableView.isHidden = true
            return
        }
        let willChangeText = optionsList[indexPath.row]
        let inconvenience = inconveniences[editingChallengeOffset]

        updateInconvenience(
            inconvenience: inconvenience,
            willChangingText: willChangeText
        ) { [weak self] (isSuccess, inconvenience) in
                if isSuccess, let inconvenience = inconvenience {
                    self?.inconveniences[editingChallengeOffset] = inconvenience
                    self?.editingChallengeOffset = nil
                    tableView.isHidden = true
                    self?.setChallengeTextByOptionSelected(offset: offset, text: willChangeText)
                    self?.setChallengeViewChangingState(offset: offset)
                }
            }
    }
}

// MARK: - UITableViewDataSource
extension ChallengeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OptionCell = tableView.dequeueCell(indexPath: indexPath)
        cell.setCellType(type: .challenge)
        cell.optionTextLabel.text = optionsList[indexPath.row]
        return cell
    }
}

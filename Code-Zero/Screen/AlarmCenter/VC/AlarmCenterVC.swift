//
//  AlarmCenterVC.swift
//  Code-Zero
//
//  Created by 주혁 on 2022/04/26.
//

import UIKit

class AlarmCenterVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var alarms: [String] = [
        "박수빈빈빈님의 보틀을 ",
        "박수빈빈빈님이 새로운 챌린지를 시작했어요!",
        "가니가니가님이 내 챌린지 성공을 축하해요!",
        "가니가니가님이 내 챌린지 성공을 축하해요!",
        "가니가니가님이 내 챌린지 성공을 축하해요!",
        "박수빈빈빈님이 새로운 시작했어요!",
        "박수빈빈빈님이 새로운 시작했어요!",
        "박수빈빈빈님이 새로운 챌린지를 시작했어요!"
    ]

    var types: [AlarmType] = [
        .cheerUp,
        .beCelebrated,
        .beCheered,
        .cheerUp,
        .celebrate,
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }

    private func setNavigationBar() {
        self.navigationItem.title = "알림"
    }
}

extension AlarmCenterVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AlarmCell = tableView.dequeueCell(indexPath: indexPath)
        cell.delegate = self
        cell.bindData(type: types[indexPath.item], text: alarms[indexPath.item])
        return cell
    }
}

extension AlarmCenterVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = types[indexPath.item]
        switch cellType {
        case .beCheered, .beCelebrated:
            guard
                let viewController = storyboard?.instantiateViewController(
                    withIdentifier: "AlarmReactionVC"
                ) as? AlarmReactionVC
            else {
                return
            }
            viewController.alarmType = cellType
            present(viewController, animated: true, completion: nil)
        default:
            break
        }
    }
}

extension AlarmCenterVC: AlarmCellDelegate {
    func subActionButtonDidTap(cellType: AlarmType, offset: Int) {
        switch cellType {
        case .cheerUp:
            print("cheerUp")
        case .celebrate:
            print("celebrate")
        default:
            break
        }
    }
}

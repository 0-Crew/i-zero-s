//
//  AlarmCenterVC.swift
//  Code-Zero
//
//  Created by 주혁 on 2022/04/26.
//

import UIKit
import SnapKit

class AlarmCenterVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    lazy var emptyView: UIView = {
        let view = UIView(frame: .zero)
        let backgroundView = UIView(frame: .zero)
        let imageView = UIImageView(image: UIImage(named: "imgAlarmNone"))

        let titleLabel: UILabel = {
            let label = UILabel()
            label.setLabel(text: "오늘은 알림이 없습니다",
                           color: .gray4,
                           font: .spoqaHanSansNeo(size: 16, family: .bold))
            label.textAlignment = .center
            return label
        }()
        let subtitleLabel: UILabel = {
            let label = UILabel()
            label.setLabel(text: "새로운 소식이 생기면 알려드릴게요!",
                           color: .gray4,
                           font: .spoqaHanSansNeo(size: 14, family: .medium))
            label.textColor = .gray4
            label.textAlignment = .center
            return label
        }()

        backgroundView.addSubview(imageView)
        backgroundView.addSubview(titleLabel)
        backgroundView.addSubview(subtitleLabel)
        view.addSubview(backgroundView)

        imageView.snp.makeConstraints {
            $0.width.height.equalTo(90)
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }

        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        backgroundView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        view.backgroundColor = .white

        return view
    }()

    lazy var eventToastView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray2
        view.addSubview(toastTitleLabel)

        toastTitleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        return view
    }()
    lazy var toastTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .spoqaHanSansNeo(size: 14, family: .medium)
        label.textColor = .white
        return label
    }()
    var notificationList: [NotificationData] = [] {
        didSet {
            if notificationList.count == 0 {
                setEmptyView()
            } else {
                tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        fetchNotificationList()
    }

    private func setNavigationBar() {
        self.navigationItem.title = "알림"
        let backButtonImage = UIImage(named: "icArrowLeftDark")?.withAlignmentRectInsets(
            UIEdgeInsets(top: 0.0, left: -10.0, bottom: 0.0, right: 0.0)
        )
        self.navigationController?.navigationBar.backIndicatorImage = backButtonImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
    }

    private func setEmptyView() {
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(view)
        }
    }

    private func fetchNotificationList() {
        guard let token = accessToken else { return }
        AlarmCenterService.shared.requestNotificationList(token: token) { [weak self] result in
            switch result {
            case .success(let data):
                self?.notificationList = data
            case .requestErr(let errorMessage):
                print(errorMessage)
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }

    private func presentToastView(text: String) {
        eventToastView.alpha = 0
        toastTitleLabel.text = text
        view.addSubview(eventToastView)
        eventToastView.snp.makeConstraints {

            $0.bottom.equalToSuperview().offset(-60)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(57)
        }

        UIView.animateKeyframes(withDuration: 2, delay: 0, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/20, animations: {
                self.eventToastView.alpha = 1
            })
            UIView.addKeyframe(withRelativeStartTime: 19/20, relativeDuration: 1/20, animations: {
                self.eventToastView.alpha = 0
            })

        }, completion: { _ in
            self.eventToastView.removeFromSuperview()
        })
    }
}

extension AlarmCenterVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AlarmCell = tableView.dequeueCell(indexPath: indexPath)
        cell.delegate = self
        let notification = notificationList[indexPath.item]
        cell.offset = indexPath.item
        cell.bindData(notification: notification)
        return cell
    }
}

extension AlarmCenterVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = notificationList[indexPath.item].alarmType
        let userName = notificationList[indexPath.item].sentUser.name
        switch cellType {
        case .beCheered, .beCongratulated:
            guard
                let viewController = storyboard?.instantiateViewController(
                    withIdentifier: "AlarmReactionVC"
                ) as? AlarmReactionVC
            else {
                return
            }
            viewController.alarmType = cellType
            viewController.reactingName = userName
            viewController.reactingCount = 1
            present(viewController, animated: true, completion: nil)
        default:
            break
        }
    }
}

extension AlarmCenterVC: AlarmCellDelegate {
    func subActionButtonDidTap(cellType: AlarmType, offset: Int) {

        guard let token = accessToken else { return }
        let notification = notificationList[offset]
        let user = notification.sentUser

        AlarmCenterService.shared.requestNotificationButton(
            token: token,
            type: .cheer,
            receiverUserId: user.id
        ) { [weak self] result in
            switch result {
            case .success(let isSuccess):
                if isSuccess {
                    self?.presentToastView(text: cellType.getSubActionToastText(user: user) ?? "")
                }
            case .requestErr(let message):
                print(message)
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
}

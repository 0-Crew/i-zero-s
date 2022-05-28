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
            label.text = "오늘은 알림이 없습니다"
            label.font = .spoqaHanSansNeo(size: 16, family: .bold)
            label.textColor = .gray4
            label.textAlignment = .center
            return label
        }()
        let subtitleLabel: UILabel = {
            let label = UILabel()
            label.text = "새로운 소식이 생기면 알려드릴게요!"
            label.font = .spoqaHanSansNeo(size: 14, family: .medium)
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

    // alarms가 빈배열일 경우 emptyView 노출
    var alarms: [(String, AlarmType)] = [
        ("박수빈빈님이 챌린지를 성공했어요!", .celebrate),
        ("가니가니가님이 내 챌린지 성공을 축하해요!", .beCelebrated),
        ("가니가니가님이 내 챌린지를 응원해요!", .beCheered),
        ("가니가니가님이 내 챌린지를 응원해요!", .beCheered),
        ("박수빈빈빈님이 새로운 챌린지를 시작했어요!", .cheerUp),
        ("박수빈빈빈님이 새로운 챌린지를 시작했어요!", .cheerUp),
        ("박수빈빈빈님이 새로운 챌린지를 시작했어요!", .cheerUp)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        if alarms.count == 0 {
            setEmptyView()
        }
    }

    private func setNavigationBar() {
        self.navigationItem.title = "알림"
    }

    private func setEmptyView() {
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(view)
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
        return alarms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AlarmCell = tableView.dequeueCell(indexPath: indexPath)
        cell.delegate = self
        cell.bindData(type: alarms[indexPath.item].1, text: alarms[indexPath.item].0)
        return cell
    }
}

extension AlarmCenterVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = alarms[indexPath.item].1
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
        // TODO: AlarmCenter 서버 연결 후 다시 작업
        switch cellType {
        case .cheerUp:
            presentToastView(text: "박수빈님에게 챌린지 응원을 보냈어요!")
            print("cheerUp")
        case .celebrate:
            presentToastView(text: "celebrate")
            print("celebrate")
        default:
            break
        }
    }
}

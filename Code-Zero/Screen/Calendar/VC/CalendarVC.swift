//
//  CalendarVC.swift
//  Code-Zero
//
//  Created by 김민희 on 2021/11/04.
//

import UIKit
import FSCalendar
import SnapKit

struct ChallengeData {
    let subject: String
    let list: [DayChallengeState]
    let colorNumber: Int
}

struct DayChallengeState {
    let title: String
    let sucess: Bool
}

class CalendarVC: UIViewController {

    // MARK: - Property
    private lazy var leftMonthButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icArrowLeft"), for: .normal)
        button.addTarget(self, action: #selector(moveMonthButtonDidTap), for: .touchUpInside)
        button.tag = -1
        return button
    }()
    private lazy var rightMonthButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icArrowRight"), for: .normal)
        button.addTarget(self, action: #selector(moveMonthButtonDidTap), for: .touchUpInside)
        button.tag = 1
        return button
    }()
    private let gregorian = Calendar(identifier: .gregorian)
    private var challengeDates: [(String, Int)] = []
    private var challengeContext: [ChallengeData] = []
    private var selectedChallege: [(String)] = [] { // 현재 선택 되어있는 챌린지
        didSet {
            if selectedChallege != [] {
                let challengeNumber = challengeDates.filter { $0.0 == selectedChallege[0] }[0].1
                let challengeData = challengeContext.filter { $0.colorNumber == challengeNumber }[0]
                let challengeWeek = challengeDates.filter { $0.1 == challengeNumber }.map { $0.0 }.map { $0.components(separatedBy: "-")[2] }.sorted()
                let stringToDate = calendar.today?.datePickerToString(format: "yyyy-MM-dd")
                let challengeColor = challengeDates.filter { $0.1 == challengeNumber }.map { $0.0 }.contains
                { $0 == stringToDate } ? -1 : challengeData.colorNumber
                let challengeListView = ChallengeListView(frame: CGRect(x: 0,
                                                                        y: 0,
                                                                        width: view.frame.width-40,
                                                                        height: 273),
                                                          color: challengeColor,
                                                          date: "11.\(challengeWeek.first!) - \(challengeWeek.last!)",
                                                          subject: challengeData.subject,
                                                          list: challengeData.list)
                challengeView.subviews[0].removeFromSuperview()
                challengeView.addSubview(challengeListView)
            } else {
                let todayJoinChallengeView = JoinChallengeView(frame: CGRect(x: 0,
                                                                             y: 0,
                                                                             width: view.frame.width-40,
                                                                             height: 167))
                challengeView.subviews[0].removeFromSuperview()
                challengeView.addSubview(todayJoinChallengeView)
            }
        }
    }

    // MARK: - @IBOutlet
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var challengeView: UIView!

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setChallengeView()
        makeButton()
        makeDumyData()
        findTodayIsChallenge()
        // Do any additional setup after loading the view.
    }
}

// MARK: - View Function

extension CalendarVC {

    func setChallengeView() {
        let todayJoinChallengeView = JoinChallengeView(frame: CGRect(x: 0,
                                                                     y: 0,
                                                                     width: view.frame.width-40,
                                                                     height: 167))
        challengeView.addSubview(todayJoinChallengeView)
    }
    @objc func moveMonthButtonDidTap(sender: UIButton) {
        calendar.setCurrentPage(moveMonth(date: calendar.currentPage, value: sender.tag), animated: true)
    }
    func findTodayIsChallenge() {
        let stringToDate = calendar.today?.datePickerToString(format: "yyyy-MM-dd")
        if challengeDates.contains(where: { $0.0 == stringToDate }) {
            if let challengeColor = challengeDates.filter({ $0.0 == stringToDate }).map({ $0.1 }).first {
                selectedChallege = challengeDates.filter { $0.1 == challengeColor }.map { $0.0 }
            }
        }
    }

}

// MARK: - FSCalendar Delegate
extension CalendarVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    func calendar(_ calendar: FSCalendar,
                  willDisplay cell: FSCalendarCell,
                  for date: Date,
                  at position: FSCalendarMonthPosition) {
        // willDisplay: cell 이 화면에 처음 표시될 때 call (달이 바뀔 때 마다도 호출)
        configure(cell: cell, for: date, at: position)
    }
    func calendar(_ calendar: FSCalendar,
                  shouldSelect date: Date,
                  at monthPosition: FSCalendarMonthPosition) -> Bool {
        let challengeDate = challengeDates.map { $0.0 }
        let stringToDate = date.datePickerToString(format: "yyyy-MM-dd")
        return (challengeDate.contains(stringToDate) || date == calendar.today) ? true : false
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // didSelect : cell 미선택 -> 선택 시 호출
        let stringToDate = date.datePickerToString(format: "yyyy-MM-dd")
        if let challengeColor = challengeDates.filter({ $0.0 == stringToDate }).map({ $0.1 }).first {
            selectedChallege = challengeDates.filter { $0.1 == challengeColor }.map { $0.0 }
        }
        selectedChallege = date == calendar.today && !challengeDates.contains { $0.0 == stringToDate } ?
        [] : selectedChallege
        configureVisibleCells()
    }
    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        // didDeselect : cell 선택 -> 미선택 시 호출
        configureVisibleCells()
    }
    func calendar(_ calendar: FSCalendar,
                  cellFor date: Date,
                  at position: FSCalendarMonthPosition) -> FSCalendarCell {
        // cellFor : 각 cell 에 대해 설정
        let cell = calendar.dequeueReusableCell(withIdentifier: "challengeCell", for: date, at: position)
        return cell
    }
    func calendar(_ calendar: FSCalendar,
                  appearance: FSCalendarAppearance,
                  borderDefaultColorFor date: Date) -> UIColor? {
        // borderDefaultColorFor : default 상태일 때(not 선택) 테두리 설정
        return isToday(calendar: calendar, date: date) ? .white : .clear
    }
    func calendar(_ calendar: FSCalendar,
                  appearance: FSCalendarAppearance,
                  borderSelectionColorFor date: Date) -> UIColor? {
        // borderSelectionColorFor : 클릭 상태일 때 테두리 설정
        return isToday(calendar: calendar, date: date) ? .white : .clear
    }
    func calendar(_ calendar: FSCalendar,
                  appearance: FSCalendarAppearance,
                  fillSelectionColorFor date: Date) -> UIColor? {
        return isToday(calendar: calendar, date: date) ? .white : .clear
    }
    func isToday(calendar: FSCalendar, date: Date) -> Bool {
        // 오늘 챌린지를 진행중이라면 true
        let stringToDate = calendar.today?.datePickerToString(format: "yyyy-MM-dd")
        return date == calendar.today && !challengeDates.contains(where: { $0.0 == stringToDate }) ?
            true : false
    }
    func moveMonth(date: Date, value: Int) -> Date {
        // 현재 달(기준: 0)에서 특정 달(value)만큼 이동
        return Calendar.current.date(byAdding: .month, value: value, to: date)!
    }
    private func configureVisibleCells() {
        calendar.visibleCells().forEach { (cell) in
            if let date = calendar.date(for: cell) {
                let position = calendar.monthPosition(for: cell)
                configure(cell: cell, for: date, at: position)
            }
        }
    }
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {

        let challengeCell = (cell as? ChallengeCalendarCell)

        guard position == .current else {
            challengeCell?.cellBoarderType = .none
            challengeCell?.cellDayType = .days
            return
        }

        challengeCell?.cellDayType = date == calendar.today ? .today : .days

        let stringToDate = date.datePickerToString(format: "yyyy-MM-dd")
        let challengeColor = challengeDates.filter { $0.0 == stringToDate }.map { $0.1 }.first ?? -1
        let todayChallengeColor = challengeDates.filter {
            $0.0 == calendar.today?.datePickerToString(format: "yyyy-MM-dd")
        }.first?.1
        let previousDate = gregorian.date(byAdding: .day, value: -1, to: date)!
            .datePickerToString(format: "yyyy-MM-dd")
        let nextDate = gregorian.date(byAdding: .day, value: 1, to: date)!
            .datePickerToString(format: "yyyy-MM-dd")
        challengeCell?.isClick = selectedChallege.contains { $0 == stringToDate }
        if calendar.selectedDate == calendar.today && date == calendar.today { challengeCell?.isClick = true }
        challengeCell?.cellBoarderType = {
            if challengeDates.contains(where: { $0.0 == stringToDate }) {

                if date.dayNumberOfWeek() == 7 { // 토요일이라면
                    if !challengeDates.contains(where: { $0.0 == previousDate }) {
                        return challengeColor == todayChallengeColor ?
                            .bothBorder(color: -1) : .bothBorder(color: challengeColor)
                    }
                    return challengeColor == todayChallengeColor ?
                        .rightBorder(color: -1) : .rightBorder(color: challengeColor)
                } else if date.dayNumberOfWeek() == 1 { // 일요일이라면
                    if !challengeDates.contains(where: { $0.0 == nextDate }) {
                        return challengeColor == todayChallengeColor ?
                            .bothBorder(color: -1) : .bothBorder(color: challengeColor)
                    }
                    return challengeColor == todayChallengeColor ?
                        .leftBorder(color: -1) : .leftBorder(color: challengeColor)
                }
                if challengeDates.contains(where: { $0.0 == previousDate && $0.1 == challengeColor }) &&
                    challengeDates.contains(where: { $0.0 == nextDate && $0.1 == challengeColor }) {
                    // 이전, 다음날이 선택된 날의 다음날로 들어가 있다면
                    return challengeColor == todayChallengeColor ?
                        .middle(color: -1) : .middle(color: challengeColor) // 중간 취급
                } else if challengeDates.contains(where: { $0.0 == previousDate && $0.1 == challengeColor }) {
                    // 이전날만 존재한다면
                    return challengeColor == todayChallengeColor ?
                        .rightBorder(color: -1) : .rightBorder(color: challengeColor) // 오른쪽 라운드 담당
                } else { // 다음날만 존재한다면
                    return challengeColor == todayChallengeColor ?
                        .leftBorder(color: -1) : .leftBorder(color: challengeColor) // 왼쪽 라운드 담당
                }
            } else {
                return .none
            }
        }()
    }
}

// MARK: - View Style
extension CalendarVC {
    private func setView() {
        view.backgroundColor = .darkGray2
        scrollView.backgroundColor = .darkGray2

        calendar.dataSource = self
        calendar.delegate = self
        calendar.register(ChallengeCalendarCell.self, forCellReuseIdentifier: "challengeCell")
        calendar.backgroundColor = .darkGray2
        calendar.headerHeight = 50
        calendar.placeholderType = .fillHeadTail
        // title: Day
        calendar.appearance.titleDefaultColor = .gray2
        calendar.appearance.titleWeekendColor = .gray2
        calendar.appearance.titleFont = .spoqaHanSansNeo(size: 14, family: .medium)
        // headerTitle: 달력 이름
        calendar.appearance.headerTitleColor = .white
        calendar.appearance.headerTitleFont = .futuraStd(size: 20, family: .heavy)
        calendar.appearance.headerMinimumDissolvedAlpha = 0 // 이전, 다음 달 text hide
        // weekday: 요일
        calendar.appearance.weekdayTextColor = .gray2
        calendar.appearance.weekdayFont = .futuraStd(size: 13, family: .heavy)
        calendar.appearance.selectionColor = .none
        calendar.appearance.titleSelectionColor = .darkGray
        calendar.appearance.caseOptions = [.weekdayUsesUpperCase]

        calendar.appearance.todayColor = .clear
        calendar.appearance.todaySelectionColor = .none
        calendar.select(calendar.today) // 처음 view open 시 오늘 날짜 선택
    }
    private func makeButton() {
        view.addSubview(leftMonthButton)
        view.addSubview(rightMonthButton)
        leftMonthButton.snp.makeConstraints {
            $0.centerY.equalTo(calendar.calendarHeaderView.snp.centerY)
            $0.left.equalTo(calendar.snp.left).offset(5)
            $0.width.height.equalTo(24)
        }
        rightMonthButton.snp.makeConstraints {
            $0.centerY.equalTo(calendar.calendarHeaderView.snp.centerY)
            $0.right.equalTo(calendar.snp.right).offset(-5)
            $0.width.height.equalTo(24)
        }
    }
    override func updateViewConstraints() {
        var height: CGFloat = 0.0
        height += calendar.frame.height
        view.frame.size.height = 800 // 추상적인 숫자 변경 필요
        view.frame.origin.y = UIScreen.main.bounds.height - height - 450

        view.clipsToBounds = true
        view.layer.cornerRadius = 25
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)

        super.updateViewConstraints()
    }
}

// MARK: - Server
extension CalendarVC {
    // 서버 연결 전 더미데이터 생성
    private func makeDumyData() {
        let data1 = DayChallengeState(title: "종이 컵홀더 안 쓰기", sucess: true)
        let data2 = DayChallengeState(title: "종이 컵홀더 안 쓰기종이 컵", sucess: true)
        let data3 = DayChallengeState(title: "종이 컵홀더 안 쓰기종이 컵홀더 안 쓰기", sucess: false)
        let data4 = DayChallengeState(title: "종이 컵홀더", sucess: true)
        let data5 = DayChallengeState(title: "종이 컵홀더 안 쓰기 종이", sucess: true)
        let data6 = DayChallengeState(title: "민희", sucess: true)
        let data7 = DayChallengeState(title: "종이 쇼핑백 사용하기", sucess: false)
        let firstChallenge: [DayChallengeState] = [data1, data2, data3, data4, data5, data6, data7]

        let data8 = DayChallengeState(title: "텀블러 가져가서 사용하기 'ㅅ'", sucess: true)
        let data9 = DayChallengeState(title: "텀블러 가져가서 사용하기 'ㅇ'", sucess: true)
        let data10 = DayChallengeState(title: "텀블러 가져가서 사용하기 'ㅁ'", sucess: true)
        let data11 = DayChallengeState(title: "텀블러 가져가서 사용하기 'ㅋ'", sucess: true)
        let data12 = DayChallengeState(title: "휴지대신 손수건 사용하기", sucess: true)
        let data13 = DayChallengeState(title: "텀블러 가져가서 사용하기 'ㅆ'", sucess: true)
        let data14 = DayChallengeState(title: "텀블러 가져가서 사용하기 'w '", sucess: true)
        let secondeChallenge: [DayChallengeState] = [data8, data9, data10, data11, data12, data13, data14]

        let data15 = DayChallengeState(title: "☁️ 영수증 안받기(전자 영수증)", sucess: true)
        let data16 = DayChallengeState(title: "☁️ 영수증 안받기(전자 영수증)", sucess: true)
        let data17 = DayChallengeState(title: "☁️ 영수증 안받기(전자 영수증)", sucess: true)
        let data18 = DayChallengeState(title: "☁️ 영수증 안받기(전자 영수증)", sucess: true)
        let data19 = DayChallengeState(title: "😏 빨대 안받기", sucess: true)
        let data20 = DayChallengeState(title: "☁️ 영수증 안받기(전자 영수증)", sucess: false)
        let data21 = DayChallengeState(title: "☁️ 영수증 안받기(전자 영수증)", sucess: true)
        let thirdChallenge: [DayChallengeState] = [data15, data16, data17, data18, data19, data20, data21]

        let challenge1 = ChallengeData(subject: "오늘도 화이팅", list: firstChallenge, colorNumber: 1)
        let challenge2 = ChallengeData(subject: "빨대는 포기 못해", list: secondeChallenge, colorNumber: 2)
        let challenge3 = ChallengeData(subject: "인공눈물", list: thirdChallenge, colorNumber: 3)

        challengeContext = [challenge1, challenge2, challenge3]
        challengeDates
        = [("2021-11-01", 1), ("2021-11-02", 1), ("2021-11-03", 1), ("2021-11-04", 1), ("2021-11-05", 1),
           ("2021-11-06", 1), ("2021-11-07", 1), ("2021-11-11", 2), ("2021-11-12", 2), ("2021-11-13", 2),
           ("2021-11-14", 2), ("2021-11-15", 2), ("2021-11-16", 2), ("2021-11-17", 2), ("2021-11-28", 3),
           ("2021-11-22", 3), ("2021-11-23", 3), ("2021-11-24", 3), ("2021-11-25", 3), ("2021-11-26", 3),
           ("2021-11-27", 3)]
    }
}

//
//  CalendarVC.swift
//  Code-Zero
//
//  Created by 김민희 on 2021/11/04.
//

import UIKit
import FSCalendar
import SnapKit

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

    fileprivate let gregorian = Calendar(identifier: .gregorian)
    private var challengeDates: [(String, Int)] = [("2021-11-22", 1), ("2021-11-23", 1), ("2021-11-24", 1),
                                                   ("2021-11-01", 2), ("2021-11-02", 2), ("2021-11-03", 2),
                                                   ("2021-11-04", 2), ("2021-11-05", 3), ("2021-11-06", 3),
                                                   ("2021-11-07", 3)]

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
        // Do any additional setup after loading the view.
    }

}

// MARK: - Extensions
extension CalendarVC {

    // MARK: - View Style
    func setView() {
        view.backgroundColor = .darkGray2
        scrollView.backgroundColor = .darkGray2

        calendar.dataSource = self
        calendar.delegate = self

        calendar.register(TodayCalendarCell.self, forCellReuseIdentifier: "todayCell")
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
        calendar.appearance.selectionColor = .white
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
        view.frame.size.height = 700 // 추상적인 숫자 변경 필요
        view.frame.origin.y = UIScreen.main.bounds.height - height - 350

        view.clipsToBounds = true
        view.layer.cornerRadius = 25
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)

        super.updateViewConstraints()
    }

    // MARK: - ChildView Setting
    func setChallengeView() {
        let todayJoinChallengeView = JoinChallengeView(frame: CGRect(x: 0,
                                                                     y: 0,
                                                                     width: view.frame.width-40,
                                                                     height: 167))
        self.challengeView.addSubview(todayJoinChallengeView)
    }

    // MARK: - Action
    @objc func moveMonthButtonDidTap(sender: UIButton) {
        calendar.setCurrentPage(moveMonth(date: calendar.currentPage, value: sender.tag), animated: true)
    }

}

// MARK: - FSCalendar Delegate
extension CalendarVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    func calendar(_ calendar: FSCalendar,
                  willDisplay cell: FSCalendarCell,
                  for date: Date,
                  at position: FSCalendarMonthPosition) {
        // willDisplay: cell 이 화면에 처음 표시될 때 call (달이 바뀔 때 마다도 호출)

        self.configure(cell: cell, for: date, at: position)
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // didSelect : cell 미선택 -> 선택 시 호출

        self.configureVisibleCells()
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        // didDeselect : cell 선택 -> 미선택 시 호출

        self.configureVisibleCells()
    }

    func calendar(_ calendar: FSCalendar,
                  cellFor date: Date,
                  at position: FSCalendarMonthPosition) -> FSCalendarCell {
        // cellFor : 각 cell 에 대해 설정

        let identifier = date == calendar.today ? "todayCell" : "challengeCell"
        let cell = calendar.dequeueReusableCell(withIdentifier: identifier, for: date, at: position)

        return cell
    }

    func calendar(_ calendar: FSCalendar,
                  appearance: FSCalendarAppearance,
                  borderDefaultColorFor date: Date) -> UIColor? {
        // borderDefaultColorFor : default 상태일 때(not 선택) 테두리 설정

        return date == calendar.today ? .white : .clear
    }

    func moveMonth(date: Date, value: Int) -> Date {
        // 현재 달(기준: 0)에서 특정 달(value)만큼 이동

        return Calendar.current.date(byAdding: .month, value: value, to: date)!
    }

    private func configureVisibleCells() {

        calendar.visibleCells().forEach { (cell) in
            if let date = calendar.date(for: cell) {
                let position = calendar.monthPosition(for: cell)
                self.configure(cell: cell, for: date, at: position)
            }
        }
    }

    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {

        let todayCell = (cell as? TodayCalendarCell)
        let challengeCell = (cell as? ChallengeCalendarCell)

        guard position == .current else {
            challengeCell?.cellBoarderType = .none
            return }

        todayCell?.selectionType = {
            if calendar.selectedDates.contains($0) {
                return .selected
            } else {
                return .none
            }
        }(date)

        let stringToDate = date.datePickerToString(format: "yyyy-MM-dd")
        let challengeColor = challengeDates.filter { $0.0 == stringToDate }.map { $0.1 }.first ?? -1
        let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
            .datePickerToString(format: "yyyy-MM-dd")
        let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
            .datePickerToString(format: "yyyy-MM-dd")

        challengeCell?.cellBoarderType = {
            print(date, challengeColor)
            if challengeDates.contains(where: { $0.0 == stringToDate }) {

                if date.dayNumberOfWeek() == 7 { // 토요일이라면
                    if !challengeDates.contains(where: { $0.0 == previousDate }) {
                        return .bothBorder(color: challengeColor)
                    }
                    return .rightBorder(color: challengeColor)
                } else if date.dayNumberOfWeek() == 1 { // 일요일이라면
                    if !challengeDates.contains(where: { $0.0 == nextDate }) {
                        return .bothBorder(color: challengeColor)
                    }
                    return .leftBorder(color: challengeColor)
                }

                if challengeDates.contains(where: { $0.0 == previousDate && $0.1 == challengeColor }) &&
                    challengeDates.contains(where: { $0.0 == nextDate && $0.1 == challengeColor }) {
                    // 이전, 다음날이 선택된 날의 다음날로 들어가 있다면
                    return .middle(color: challengeColor) // 중간 취급
                } else if challengeDates.contains(where: { $0.0 == previousDate && $0.1 == challengeColor }) {
                    // 이전날만 존재한다면
                    return .rightBorder(color: challengeColor) // 오른쪽 라운드 담당
                } else { // 다음날만 존재한다면
                    return .leftBorder(color: challengeColor) // 왼쪽 라운드 담당
                }

            } else {
                return .none
            }

        }()

    }

}

extension String {
    func toDate() -> Date? {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date

        } else {
            return nil
        }

    }

}

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}

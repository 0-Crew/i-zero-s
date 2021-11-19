//
//  CalendarVC.swift
//  Code-Zero
//
//  Created by 김민희 on 2021/11/04.
//

import UIKit
import FSCalendar

class CalendarVC: UIViewController {

    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()

    let borderDefaultColors = [Date().datePickerToString(format: "yyyy/MM/dd"): UIColor.white]

    // MARK: - @IBOutlet

    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var challengeView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setChallengeView()
        // Do any additional setup after loading the view.
    }

}

extension CalendarVC {

    func setView() {

        self.view.backgroundColor = .darkGray2
        scrollView.backgroundColor = .darkGray2

        calendar.dataSource = self
        calendar.delegate = self

        calendar.register(TodayCalendarCell.self, forCellReuseIdentifier: "todayCell")
        calendar.register(ChallengeCalendarCell.self, forCellReuseIdentifier: "challengeCell")

        calendar.backgroundColor = .darkGray2

        // title: Day
        calendar.appearance.titleDefaultColor = .gray2
        calendar.appearance.titleWeekendColor = .gray2
        calendar.appearance.titleFont = .spoqaHanSansNeo(size: 14, family: .medium)

        // headerTitle: 달력 이름
        calendar.appearance.headerTitleColor = .white
        calendar.appearance.headerTitleFont = .futuraStd(size: 20, family: .heavy)

        // weekday: 요일
        calendar.appearance.weekdayTextColor = .gray2
        calendar.appearance.weekdayFont = .futuraStd(size: 13, family: .heavy)
        calendar.appearance.selectionColor = .white
        calendar.appearance.titleSelectionColor = .darkGray

        calendar.appearance.todayColor = .clear
        calendar.appearance.todaySelectionColor = .none
        calendar.select(calendar.today) // 처음 view open 시 오늘 날짜 선택

    }

    func setChallengeView() {
        let todayJoinChallengeView = JoinChallengeView(frame: CGRect(x: 0,
                                                                     y: 0,
                                                                     width: view.frame.width-40,
                                                                     height: 167))
        self.challengeView.addSubview(todayJoinChallengeView)
    }

    override func updateViewConstraints() {

        var height: CGFloat = 0.0
        height += calendar.frame.height
        self.view.frame.size.height = 700 // 추상적인 숫자 변경 필요
        self.view.frame.origin.y = UIScreen.main.bounds.height - height - 300

        super.updateViewConstraints()
    }

}

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

        if date == calendar.today {
            if let cell = calendar.dequeueReusableCell(withIdentifier: "todayCell",
                                                    for: date,
                                                    at: position) as? TodayCalendarCell {
                return cell
            }
        }
        let cell = calendar.dequeueReusableCell(withIdentifier: "challengeCell", for: date, at: position)
        return cell
    }

    func calendar(_ calendar: FSCalendar,
                  appearance: FSCalendarAppearance,
                  borderDefaultColorFor date: Date) -> UIColor? {

        if date == calendar.today {
            return .white
        }

        return .clear
    }

    private func configureVisibleCells() {
        calendar.visibleCells().forEach { (cell) in
            let date = calendar.date(for: cell)
            let position = calendar.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }

    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {

        let todayCell = (cell as? TodayCalendarCell)
        if position == .current { // 현재 달

            var selectionType = SelectedType.none
            if calendar.selectedDates.contains(date) { // 선택 그룹 안에 존재한다면
                selectionType = .selected
            } else { // 선택 그룹 안에 존재하지 않는다면
                selectionType = .none
            }

            todayCell?.selectionType = selectionType
        }

    }

}

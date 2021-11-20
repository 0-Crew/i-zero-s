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

    lazy var leftMonthButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icArrowLeft"), for: .normal)
        button.addTarget(self, action: #selector(moveMonthButtonDidTap), for: .touchUpInside)
        button.tag = -1
        return button
    }()

    lazy var rightMonthButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icArrowRight"), for: .normal)
        button.addTarget(self, action: #selector(moveMonthButtonDidTap), for: .touchUpInside)
        button.tag = 1
        return button
    }()

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

        self.view.backgroundColor = .darkGray2
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

        self.view.addSubview(leftMonthButton)
        self.view.addSubview(rightMonthButton)

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
        self.view.frame.size.height = 700 // 추상적인 숫자 변경 필요
        self.view.frame.origin.y = UIScreen.main.bounds.height - height - 350

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

        guard position == .current else { return }
        let todayCell = (cell as? TodayCalendarCell)

        todayCell?.selectionType = {
            if calendar.selectedDates.contains($0) {
                return .selected
            } else {
                return .none
            }
        }(date)
    }

}

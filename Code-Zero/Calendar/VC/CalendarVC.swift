//
//  CalendarVC.swift
//  Code-Zero
//
//  Created by 김민희 on 2021/11/04.
//

import UIKit
import FSCalendar

class CalendarVC: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    let borderDefaultColors = ["2021/11/13": UIColor.white]
    
    // MARK: - @IBOutlet

    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var calendar: FSCalendar!

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
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

        
        calendar.appearance.todayColor = .clear
        calendar.appearance.todaySelectionColor = .white
        calendar.select(Date()) // 처음 view open 시 오늘 날짜 선택

    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
       
        let todayDate = self.dateFormatter1.string(from: date)
        
        if todayDate == self.dateFormatter1.string(from: Date()) {
            let cell = calendar.dequeueReusableCell(withIdentifier: "todayCell", for: date, at: position)
            return cell
        }
        
        let cell = calendar.dequeueReusableCell(withIdentifier: "challengeCell", for: date, at: position)
        return cell
    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        let key = self.dateFormatter1.string(from: date)
        if let color = self.borderDefaultColors[key] {
            return color
        }
        return .clear
    }
}

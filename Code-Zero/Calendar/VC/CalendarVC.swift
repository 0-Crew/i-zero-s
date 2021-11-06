//
//  CalendarVC.swift
//  Code-Zero
//
//  Created by 김민희 on 2021/11/04.
//

import UIKit
import FSCalendar

class CalendarVC: UIViewController {

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

       
        calendar.appearance.todaySelectionColor = .white
        calendar.select(Date())
    }
}

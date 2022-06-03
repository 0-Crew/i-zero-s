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
    var list: [DayChallengeState]?
    let id: Int
}

struct DayChallengeState {
    let title: String
    let sucess: Bool
}

struct ChallengeList {
    let date: String
    let id: Int
    let color: Int
}

enum CalendarUser {
    case user
    case follower
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
    private var challengeDates: [ChallengeList] = []
    private var challengeContext: [ChallengeData] = []
    private var serverData: CalendarData?
    private var selectedChallege: [(String)] = [] { // 현재 선택 되어있는 챌린지
        didSet {
            selectedChallege != [] ? setChallengeListView() : setChallengeJoinView()
        }
    }
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?

    // MARK: - @IBOutlet
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var challengeView: UIView!

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        setView()
        setChallengeJoinView()
        makeButton()
        //        fetchCalendar(id: nil)
        jsonData(name: "test2")
        findTodayIsChallengeTest()
    }
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
            let translation = sender.translation(in: view)
            
            // Not allowing the user to drag the view upward
            guard translation.y >= 0 else { return }
            
            // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
            view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
            
            if sender.state == .ended {
                let dragVelocity = sender.velocity(in: view)
                if dragVelocity.y >= 1300 {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    // Set back to original position of the view controller
                    UIView.animate(withDuration: 0.3) {
                        self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                    }
                }
            }
        }
}

// MARK: - View Function
extension CalendarVC {
    @objc private func moveMonthButtonDidTap(sender: UIButton) {
        calendar.setCurrentPage(moveMonth(date: calendar.currentPage, value: sender.tag), animated: true)
    }
    private func findTodayIsChallenge() {
        let stringToDate = calendar.today?.datePickerToString(format: "yyyy-MM-dd")
        if challengeDates.contains(where: { $0.date == stringToDate }) {
            if let challengeId = challengeDates.filter({ $0.date == stringToDate }).map({ $0.id }).first {
                selectedChallege = challengeDates.filter { $0.id == challengeId }.map { $0.date }
            }
        }
    }
    private func findTodayIsChallengeTest() {
        guard let serverData = serverData else { return }
        let selected = serverData.selectedChallenge
        guard let today = selected.myChallenge?.startedAt.toKoreaData() else { return }
        guard let conveninces = selected.myInconveniences else { return }
        selectedChallege = conveninces.map {
            today.getDateIntervalBy(
                intervalDay: ($0.day ?? 0) - 1
            )?.datePickerToString(format: "yyyy-MM-dd") ?? ""
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
        // 크기 변환?
        configure(cell: cell, for: date, at: position)
    }
    func calendar(_ calendar: FSCalendar,
                  shouldSelect date: Date,
                  at monthPosition: FSCalendarMonthPosition) -> Bool {
        let challengeDate = challengeDates.map { $0.date }
        let stringToDate = date.datePickerToString(format: "yyyy-MM-dd")
        let ableClickDate: Bool = challengeDate.contains(stringToDate) || date == calendar.today
        // 챌린지를 한 날이거나 오늘인 경우에만 클릭 가능하게 구성
        return ableClickDate ? true : false
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // didSelect : cell 미선택 -> 선택 시 호출
        // 서버 통신 한번 더 id 값 넣어서 (근데 먼저 list 있나 확인 한 후 해도 좋을듯?)
        let stringToDate = date.datePickerToString(format: "yyyy-MM-dd")
        if let challengeId = challengeDates.filter({ $0.date == stringToDate }).map({ $0.id }).first {
            selectedChallege = challengeDates.filter { $0.id == challengeId }.map { $0.date }
            if challengeContext.filter({ $0.id == challengeId })[0].list == nil {
                // 서버 통신 한번 더 (왜냐면 이미 있으면 다시 안불러두 됩니다..!!
//                fetchCalendar(id: challengeId)
                jsonData(name: "beforeData")
            }
        }
        selectedChallege = date == calendar.today && !challengeDates.contains { $0.date == stringToDate } ?
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
    private func isToday(calendar: FSCalendar, date: Date) -> Bool {
        // 오늘 챌린지를 진행중이라면 true
        let stringToDate = calendar.today?.datePickerToString(format: "yyyy-MM-dd")
        return date == calendar.today && !challengeDates.contains(where: { $0.date == stringToDate }) ?
            true : false
    }
    private func moveMonth(date: Date, value: Int) -> Date {
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
//        guard position == .current else {
//            // 요기다!!!!
//            challengeCell?.cellDayType = .days(.none)
//            return
//        }

        challengeCell?.cellDayType = date == calendar.today ? .today(.none) : .days(.none)

        let stringToDate = date.datePickerToString(format: "yyyy-MM-dd") // 현재 선택된 날짜 String
        let challengeId = challengeDates.filter { $0.date == stringToDate }.map { $0.id }.first ?? -1
        // 만약 날짜가 챌린지한 날짜라면 id 값 추출
        let todayChallengeId = challengeDates.filter {
            $0.date == calendar.today?.datePickerToString(format: "yyyy-MM-dd")
        }.first?.id // 현재 날짜(오늘)의 id 추출 (없다면 nil)
        let colorChip = (challengeId == todayChallengeId ?
                         -1 : challengeDates.filter { $0.date == stringToDate }.map { $0.color }.first) ?? -1
        let previousDate = gregorian.date(byAdding: .day, value: -1, to: date)!
            .datePickerToString(format: "yyyy-MM-dd") // 이전 날짜
        let nextDate = gregorian.date(byAdding: .day, value: 1, to: date)!
            .datePickerToString(format: "yyyy-MM-dd") // 다음 날짜
        challengeCell?.isClick = selectedChallege.contains { $0 == stringToDate } // 날짜가 선택된 챌린지인지

        if calendar.selectedDate == calendar.today && date == calendar.today { challengeCell?.isClick = true }
        // 만약 오늘이 선택되어 있고 날짜가 오늘이라면? 클릭으로 변경 ( 챌린지 한 날이 아니여도 오늘은 선택 가능하기 때문 )

        challengeCell?.cellDayType = {
            if date == calendar.today && challengeId == -1 { // 오늘이면서 선택되지 않았다면?
                return .today(.none)
            }
            if challengeDates.contains(where: { $0.date == stringToDate }) {
                if date.dayNumberOfWeek() == 7 { // 토요일이라면
                    if !challengeDates.contains(where: { $0.date == previousDate }) {
                        return returnType(border: .bothBorder(color: colorChip), findDate: date)
                    }
                    return returnType(border: .rightBorder(color: colorChip), findDate: date)
                } else if date.dayNumberOfWeek() == 1 { // 일요일이라면
                    if !challengeDates.contains(where: { $0.date == nextDate }) {
                        return returnType(border: .bothBorder(color: colorChip), findDate: date)
                    }
                    return returnType(border: .leftBorder(color: colorChip), findDate: date)
                }

                if challengeDates.contains(where: { $0.date == previousDate && $0.id == challengeId }) &&
                    challengeDates.contains(where: { $0.date == nextDate && $0.id == challengeId }) {
                    // 이전, 다음날이 선택된 날의 다음날로 들어가 있다면
                    return returnType(border: .middle(color: colorChip), findDate: date) // 중간 취급
                } else if challengeDates.contains(where: {
                    $0.date == previousDate && $0.id == challengeId
                }) {
                    // 이전날만 존재한다면
                    return returnType(border: .rightBorder(color: colorChip), findDate: date) // 오른쪽 라운드 담당
                } else { // 다음날만 존재한다면
                    return returnType(border: .leftBorder(color: colorChip), findDate: date) // 왼쪽 라운드 담당
                }
            } else {
                return .days(.none)
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
//        var height: CGFloat = 0.0
//        height += calendar.frame.height
//        view.frame.size.height = 800 // 추상적인 숫자 변경 필요
//        view.frame.origin.y = UIScreen.main.bounds.height - height - 450

        view.clipsToBounds = true
        view.layer.cornerRadius = 25
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)

        super.updateViewConstraints()
    }
    private func returnType(border: CalendarBoarderType, findDate: Date) -> SelectedType {
        return findDate == calendar.today ? .today(border) : .days(border)
    }
    private func findTodayChallenge(_ challengeColor: Int, _ todayChallengeColor: Int?) -> Int {
        return challengeColor == todayChallengeColor ? -1 : challengeColor
    }
    private func setChallengeListView() {
        let challengeId = challengeDates.filter { $0.date == selectedChallege[0] }[0].id
        // 지금 선택되어 있는 챌린지 날짜의 아이디를 찾아줌
        let challengeSubject = challengeContext.filter { $0.id == challengeId }[0]
        // 챌린지 주제 목록에서 현재 챌린지 날짜의 아이디를 통해 어떤 주제인지 찾아줌
        let challengeDateList = challengeDates.filter { $0.id == challengeId }.map { $0.date }
        let challengeWeek = challengeDateList.map { $0.components(separatedBy: "-")[2] }
        // 챌린지 날짜 구하기(기간 표시를 위해)
        let challengeFirstMonth = challengeDateList[0].components(separatedBy: "-")[1]
        let challengeLastMonth = challengeDateList[6].components(separatedBy: "-")[1]
        let challengeDate = challengeFirstMonth == challengeLastMonth
        ? "\(challengeFirstMonth).\(challengeWeek.first!) - \(challengeWeek.last!)"
        : "\(challengeFirstMonth).\(challengeWeek.first!) - \(challengeLastMonth).\(challengeWeek.last!)"
        let stringToDate = calendar.today?.datePickerToString(format: "yyyy-MM-dd") // 오늘 날짜(String화)
        let color = challengeDates.filter({ $0.id == challengeId }).map({ $0.color }).first ?? -1
        let challengeColor = challengeDateList.contains { $0 == stringToDate }
        ? -1 : color
        // 오늘 날짜가 선택되어 있따면 컬러를 오렌지 컬러로 변경해주기 위한 코드(오렌지 컬러는 -1)
        guard let list = challengeSubject.list else { return }
        let challengeListView = ChallengeListView(frame: CGRect(x: 0,
                                                                y: 0,
                                                                width: view.frame.width-40,
                                                                height: 273),
                                                  color: challengeColor,
                                                  date: challengeDate,
                                                  subject: challengeSubject.subject,
                                                  list: list)
        challengeView.subviews[0].removeFromSuperview()
        challengeView.addSubview(challengeListView) // 이전에 다른 뷰가 삽입되어 있을 수 있어서 삭제 후 삽입
    }
    private func setChallengeJoinView() {
        let todayJoinChallengeView = JoinChallengeView(frame: CGRect(x: 0,
                                                                     y: 0,
                                                                     width: view.frame.width-40,
                                                                     height: 167))

        challengeView.subviews[safe: 0]?.removeFromSuperview()
        challengeView.addSubview(todayJoinChallengeView)
    }
}

// MARK: - Server
extension CalendarVC {
    private func fetchCalendar(id: Int?) {
        // swiftlint:disable line_length
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjAsImVtYWlsIjoieTR1cnRpam5makBwcml2YXRlcmVsYXkuYXBwbGVpZC5jb20iLCJuYW1lIjoi67SJ6rWs7Iqk67Cl66mNIiwiaWRGaXJlYmFzZSI6IkpoaW16VDdaUUxWcDhmakx3c1U5eWw1ZTNaeDIiLCJpYXQiOjE2NTM0ODk4MTAsImV4cCI6MTY1NjA4MTgxMCwiaXNzIjoiV1lCIn0.5oevdqhJA_NhURaD3-OOCwbUE92GvcXDndAFPW3vOHE"
        // swiftlint:enable line_length
        CalendarService.shared.requestCalendar(myChallengeId: id,
                                               token: token) { [weak self] result in
            switch result {
            case .success(let calendar):
                self?.serverData = calendar
                self?.makeCalendarData(data: calendar)
            case .requestErr(let error):
                print(error)
            case .serverErr:
                // 토큰 만료(자동 로그아웃 느낌..)
                self?.changeRootViewToHome()
            case .networkFail:
                // TODO: 서버 자체 에러 - 서버 점검 중 popup 제작?
                break
            }
        }
    }
    private func jsonData(name: String) {
        do {
            let decoder = JSONDecoder()
            guard let response: NSDataAsset = NSDataAsset(name: name) else { return }
            let body = try decoder.decode(
                GenericResponse<CalendarData>.self,
                from: response.data
            )
            guard let data = body.data else { return }
            self.serverData = data
            makeCalendarData(data: data)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    private func makeCalendarData(data: CalendarData) {
        let contextCount = challengeContext.count
        switch contextCount {
        case 0: // 캘린더 서버 연결 첫번째 일 때
            challengeContext = data.challengeContext
            var challengeDatesTest: [ChallengeList] = []
            for index in Range(0...data.myChallenges.count-1) {
                let multiArray: [ChallengeList] = data.myChallenges[index].dates.map({
                    return ChallengeList(date: $0, id: data.myChallenges[index].id, color: (index+1)%6)
                })
                challengeDatesTest += multiArray
            }
            challengeDates = challengeDatesTest
        default: // 캘린더 서버 연결 2번째 이상
            let validData = data.challengeContext.filter { $0.list != nil }
            for index in 0...challengeContext.count-1 {
                if challengeContext[index].id == validData[0].id {
                    challengeContext[index].list = validData[0].list
                    break
                }
            }
        }
    }
    private func changeRootViewToHome() {
        let storybard = UIStoryboard(name: "Home", bundle: nil)
        let homeNavigationVC = storybard.instantiateViewController(withIdentifier: "Home")
        UIApplication.shared.windows.first?.replaceRootViewController(
            homeNavigationVC,
            animated: true,
            completion: nil
        )
    }
}

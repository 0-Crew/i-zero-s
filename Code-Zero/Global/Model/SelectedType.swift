//
//  SelectedType.swift
//  Code-Zero
//
//  Created by 미니 on 2021/11/19.
//

import Foundation

enum SelectedType {
    case none // 아무것도 아닐 때
    case selected // 선택 됐을 때
    case challenge(position: CalendarBoarderType) // 챌린지한 날짜일 때
}

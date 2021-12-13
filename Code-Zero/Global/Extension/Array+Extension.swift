//
//  Array+Extension.swift
//  Code-Zero
//
//  Created by 미니 on 2021/12/05.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        // 옵셔널이 아닌 배열을 옵셔널화 시켜주는 Extension
        return indices ~= index ? self[index] : nil
    }
}

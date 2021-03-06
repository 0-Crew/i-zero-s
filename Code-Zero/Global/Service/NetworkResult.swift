//
//  NetworkResult.swift
//  Code-Zero
//
//  Created by 이주혁 on 2021/10/17.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case requestErr(String)
    case serverErr
    case networkFail
}

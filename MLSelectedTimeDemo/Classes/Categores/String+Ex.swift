//
//  String+Ex.swift
//  MLSelectedTimeDemo
//
//  Created by Melo on 2021/7/23.
//

import Foundation

extension String {

    /// 根据字符串返回NSDate
    /// - Parameter dateFormat: 日期格式字符串
    /// - Returns: 日期
    func toDate(dateFormat: String) -> Date? {
        let fmt = DateFormatter()
        fmt.dateFormat = dateFormat
        return fmt.date(from: self)
    }
    
}

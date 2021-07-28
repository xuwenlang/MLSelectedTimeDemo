//
//  Double+Ex.swift
//  MLSelectedTimeDemo
//
//  Created by Melo on 2021/7/23.
//

import Foundation

extension Double {

    /// 时间戳 to 日期字符串
    func timestampToString(dateFormat: String) -> String {
        var timestamp: Double = self
        if String(timestamp).count == 13 {
            timestamp = timestamp / 1000
        }

        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat

        let timeInterval: TimeInterval = TimeInterval(timestamp)
        let date = Date(timeIntervalSince1970: timeInterval)

        return formatter.string(from: date)
    }

    /// 时间戳 to 日期
    func timestampToDate() -> Date {
        var timestamp: Double = self
        if String(timestamp).count == 13 {
            timestamp = timestamp / 1000
        }

        let timeInterval: TimeInterval = TimeInterval(timestamp)
        let date = Date(timeIntervalSince1970: timeInterval)

        return date
    }

}

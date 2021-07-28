//
//  Date+Ex.swift
//  MLSelectedTimeDemo
//
//  Created by Melo on 2021/7/23.
//

import Foundation

extension Date {

    var year: Int { return dateComponents.year! }
    var years: Int { return year }
    var month: Int { return dateComponents.month! }
    var months: Int { return month }
    var day: Int { return dateComponents.day! }
    var days: Int { return day }
    var hour: Int { return dateComponents.hour! }
    var hours: Int { return hour }
    var minute: Int { return dateComponents.minute! }
    var minutes: Int { return minute }
    var second: Int { return dateComponents.second! }
    var seconds: Int { return second }
    var nanosecond: Int { return dateComponents.nanosecond! }
    var nanoseconds: Int { return nanosecond }
    var weekday: Int { return dateComponents.weekday! }
    var weekdays: Int { return weekday }

    var calendar: Calendar { return .current }

    var dateComponents: DateComponents { return calendar.dateComponents([.era, .year, .month, .weekday, .day, .hour, .minute, .second, .nanosecond], from: self) }

    static func + (left: Date, right: DateComponents) -> Date? {
        return Calendar.current.date(byAdding: right, to: left)
    }

    /// 初始化日期
    /// - Parameters:
    ///   - dateFormat: 日期格式 eg: yyyy-MM-dd HH:mm:ss
    ///   - dateString: 日期字符串
    /// - Returns: NSDate
    static func dateWith(dateFormat: String, dateString: String) -> Date? {
        let fmt = DateFormatter()
        fmt.dateFormat = dateFormat
        return fmt.date(from: dateString)
    }

    /**
     根据Date返回字符串

     - parameter formaterString: 日期格式字符串

     - returns: 字符串
     */
    func toString(_ dateFormat: String) -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = dateFormat
        return fmt.string(from: self)
    }

    /// 日期加上/减去某天数后的新日期
    /// - Parameter days: 天数
    func getNewDate(byAdding days: Int) -> Date {
        return self.addingTimeInterval(TimeInterval(60 * 60 * 24 * days))
    }

    /// Date 转 时间戳
    /// - Returns: 时间戳
    func toTimeStamp() -> Double {
        let timeStamp = self.timeIntervalSince1970
        return timeStamp
    }

}

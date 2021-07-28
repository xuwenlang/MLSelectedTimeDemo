//
//  Int+Ex.swift
//  MLSelectedTimeDemo
//
//  Created by Melo on 2021/7/23.
//

import Foundation

extension Int {
    var years: DateComponents { return DateComponents(year: self) }
    var months: DateComponents { return DateComponents(month: self) }
    var days: DateComponents { return DateComponents(day: self) }
    var weeks: DateComponents { return DateComponents(day: 7 * self) }
    var hours: DateComponents { return DateComponents(hour: self) }
    var minuts: DateComponents { return DateComponents(minute: self) }
    var seconds: DateComponents { return DateComponents(second: self) }
    var nanosecond: DateComponents { return DateComponents(nanosecond: self)}

    func zero() -> String {
        if self < 10 {
            return "0" + String(self)
        } else {
            return String(self)
        }
    }

    func toWeekString(isSimple: Bool = false) -> String {
        var week = ""
        switch self {
        case 1:
            week = isSimple ? "周日" : "星期天"
            return week
        case 2:
            week = isSimple ? "周一" : "星期一"
            return week
        case 3:
            week = isSimple ? "周二" : "星期二"
            return week
        case 4:
            week = isSimple ? "周三" : "星期三"
            return week
        case 5:
            week = isSimple ? "周四" : "星期四"
            return week
        case 6:
            week = isSimple ? "周五" : "星期五"
            return week
        case 7:
            week = isSimple ? "周六" : "星期六"
            return week
        default:
            return week
        }
    }
}

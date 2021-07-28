//
//  PickupTimeSelectViewModel.swift
//  MLSelectedTimeDemo
//
//  Created by Melo on 2021/7/23.
//

import UIKit

enum PickupTimeSelectViewError: Swift.Error {
    case expired
}

extension PickupTimeSelectViewError {
    var localizedDescription: String {
        switch self {
        case .expired:
            return "处方已过期"
        }
    }
}

final class PickupTimeSelectViewModel: NSObject {

    private var expiredTimestamp: Double
    private var businessTimeStrStart: String  // "08:30"
    private var businessTimeStrEnd: String    // "18:30"

    init(expiredTimestamp: Double, businessTimeStrStart: String, businessTimeStrEnd: String) {
        self.expiredTimestamp = expiredTimestamp
        self.businessTimeStrStart = businessTimeStrStart
        self.businessTimeStrEnd = businessTimeStrEnd
    }

    public func loadData() throws -> [PickupDateModel] {

        let expiredDate = expiredTimestamp.timestampToDate() // 过期日
        let today = Date() // 今日
        guard today.compare(expiredDate) != .orderedDescending else {
            throw PickupTimeSelectViewError.expired
        }

        let days = getDates(from: today, to: expiredDate)
        for day in days {
            print("========== 日期: \(day.toString("yyyy-MM-dd"))")
        }

        var resultDates = [PickupDateModel]()

        var thatDate: Date = today // 当天

        for i in 0..<days.count {
            thatDate = (today + i.days)!

            var weekStr = ""
            if i > 0 {
                weekStr = "（\(thatDate.weekdays.toWeekString())）"
            } else {
                weekStr = "（今天）"
            }
            let dayStr = thatDate.toString("MM月dd日") + weekStr

            let thatDayStr = thatDate.toString("yyyy-MM-dd")

            var resultHour = [PickupDateHourPeriod]()
            // 全天的营业时间段
            let hourPeriods = getFullDayHourPeriodArr(businessStart: businessTimeStrStart, businessEnd: businessTimeStrEnd)
            for (_, hourPeriod) in hourPeriods.enumerated() {
                print("========== 日期: \(thatDayStr) 时间段: \(hourPeriod)")

                let hourPeriodStartTimeStr = thatDayStr + " " + (hourPeriod.startTimeStr)
                let hourPeriodEndTimeStr = thatDayStr + " " + (hourPeriod.endTimeStr)
                // 时间段的开始
                let startDate: Date = hourPeriodStartTimeStr.toDate(dateFormat: "yyyy-MM-dd HH:mm")!
                // 时间段的结束
                let endDate: Date = hourPeriodEndTimeStr.toDate(dateFormat: "yyyy-MM-dd HH:mm")!
                // 此刻 < `时间段的开始`，`时间段的结束` <= 过期时间
                if today.compare(startDate) == .orderedAscending && endDate.compare(expiredDate) != .orderedDescending {
                    resultHour.append(hourPeriod)
                }
            }

            if resultHour.count != 0 {
                let date = PickupDateModel(dayStr: dayStr, dayDate: thatDate, hourPeriod: resultHour)
                resultDates.append(date)
            }
        }

        return resultDates
    }

    /// 获取两个`date`之间的日期
    private func getDates(from startDate: Date, to endDate: Date) -> [Date] {

        var componentArr = [Date]()
        let calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)

        var comps: DateComponents!
        var start = startDate
        let end = endDate
        var result = start.compare(end)
        while (result != .orderedDescending) {
            comps = calendar.dateComponents([.year, .month, .day, .weekday], from: start)
            componentArr.append(start)
            //后一天
            comps.day = (comps.day ?? 0) + 1
            start = calendar.date(from: comps)!
            //对比日期大小
            result = start.compare(end)
        }
        return componentArr;
    }

    /// 获取全天的营业时间段
    /// - Parameters:
    ///   - businessStart: 开始营业时间，格式：HH:mm
    ///   - businessEnd: 结束营业时间，格式：HH:mm
    /// - Returns: 营业时间段
    private func getFullDayHourPeriodArr(businessStart: String, businessEnd: String) -> [PickupDateHourPeriod] {
        var startTimeStr = ""
        var endTimeStr = ""
        var middleTimeStr = ""

        let businessStartDate: Date = businessStart.toDate(dateFormat: "HH:mm")!
        let businessEndDate: Date = businessEnd.toDate(dateFormat: "HH:mm")!

        var tempStartDateHour: Int = businessStartDate.hour
        var tempStartDateMinute: Int = businessStartDate.minute
        var tempEndDateMinute: Int = 0

        var takeHourPeriodArr = [PickupDateHourPeriod]()

        repeat {
            startTimeStr = String(format: "%02d:%02d", tempStartDateHour, tempStartDateMinute)
            if (tempStartDateMinute == 0) {
                tempStartDateHour += 1
            } else {
                tempStartDateHour += 2
            }
            tempStartDateMinute = 0
            if tempStartDateHour == businessEndDate.hour { // 最后一个小时数
                tempEndDateMinute = businessEndDate.minute
            }
            endTimeStr = String(format: "%02d:%02d", tempStartDateHour, tempEndDateMinute)

            middleTimeStr = "\(startTimeStr)-\(endTimeStr)"
            let hp = PickupDateHourPeriod.init(startTimeStr: startTimeStr, endTimeStr: endTimeStr, hourPeriodStr: middleTimeStr)
            takeHourPeriodArr.append(hp)
        } while (endTimeStr.toDate(dateFormat: "HH:mm")?.compare(businessEndDate) == .orderedAscending) // 升序，前者 < 后者，继续执行

        return takeHourPeriodArr
    }

}

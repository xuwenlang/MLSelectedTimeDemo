//
//  PickupDateModel.swift
//  MLSelectedTimeDemo
//
//  Created by Melo on 2021/7/23.
//

import UIKit

struct PickupDateModel: Codable {
    public var dayStr: String
    public var dayDate: Date
    public var hourPeriod: [PickupDateHourPeriod]

    init(dayStr: String, dayDate: Date, hourPeriod: [PickupDateHourPeriod]) {
        self.dayStr = dayStr
        self.dayDate = dayDate
        self.hourPeriod = hourPeriod
    }
}

struct PickupDateHourPeriod: Codable {
    public var startTimeStr: String
    public var endTimeStr: String
    public var hourPeriodStr: String

    init(startTimeStr: String, endTimeStr: String, hourPeriodStr: String) {
        self.startTimeStr = startTimeStr
        self.endTimeStr = endTimeStr
        self.hourPeriodStr = hourPeriodStr
    }
}

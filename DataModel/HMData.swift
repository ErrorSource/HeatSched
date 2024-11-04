//
//  HMData.swift
//  HeatSched
//
//  Created by Georg Kemser on 02.11.24.
//

import SwiftUI
import SwiftData

enum HMWeekDay: String, CaseIterable {
	typealias RawValue = String
	case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

@Model
class HMSegment: Identifiable {
	var id = UUID()
	var startMinute: Int
	var endMinute: Int
	var targetTemp: Double

	init(startMinute: Int, endMinute: Int, targetTemp: Double) {
		self.startMinute = startMinute
		self.endMinute = endMinute
		self.targetTemp = targetTemp
	}
}

// @Model
// class HMDay: Identifiable {
//	var id = UUID()
//	var weekDay: HMWeekDay
//	var segments: [HMSegment]
//
//	init(weekDay: HMWeekDay, segments: [HMSegment]) {
//		self.weekDay = HMWeekDay.monday
//		self.segments = []
//	}
// }

//
//  HMData.swift
//  HeatSched
//

import SwiftUI
import SwiftData

enum HMWeekDay: String, CaseIterable {
	typealias RawValue = String
	case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

@Model
class HMSegment: Identifiable {
	// gk76: this is a workaround! normaly we would use:
	// var id = UUID()
	// but with this, the DeviceDayView will not update accordingly, if cancel-button was pressed
	// and a modelContext.rollback() was executed
	// (see: https://stackoverflow.com/questions/78775761/swiftdata-rollback-not-updating-the-ui)
	var id: String {
		"\(persistentModelID) \(startMinute) \(endMinute) \(targetTemp)"
	}

	var startMinute: Int
	var endMinute: Int
	var targetTemp: Double

	init(startMinute: Int, endMinute: Int, targetTemp: Double) {
		self.startMinute = startMinute
		self.endMinute = endMinute
		self.targetTemp = targetTemp
	}

	func copy(with zone: NSZone? = nil) -> Any {
		let copy = HMSegment(startMinute: startMinute, endMinute: endMinute, targetTemp: targetTemp)
		return copy
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

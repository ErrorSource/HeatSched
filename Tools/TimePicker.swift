//
//  TimePicker.swift
//  HeatSched
//

import SwiftUI

struct TimePicker: View {
	@Binding var targetTime: Int
	@State var source: timePickerSource
	@Binding var neighbours: (left: HMSegment?, right: HMSegment?)
	@State var limit: Int

	var body: some View {
		HStack {
			DatePicker(
				"",
				selection: self.$targetTime.minutes2TimePicker(),
				in: minutes2Date(minutes: self.limit)...,
				displayedComponents: .hourAndMinute
			)
			.labelsHidden()
			.datePickerStyle(WheelDatePickerStyle())
			.onAppear {
				UIDatePicker.appearance().minuteInterval = 5
			}
			.onChange(of: self.targetTime) { (_, newValue) in
				if (source == timePickerSource.from) {
					self.neighbours.left?.endMinute = newValue
				} else {
					self.neighbours.right?.startMinute = newValue
				}
			}
		}
		.frame(width: 60, height: 100, alignment: .center)
		.transformEffect(.init(scaleX: 1.4, y: 1.4))
	}

	func calculateLimits() -> Int {
		// unsed for now
		return 0
	}
}

// needed for converting binded Int to binded Date, readable for timepicker
extension Binding where Value == Int {
	func minutes2TimePicker() -> Binding<Date> {
		return Binding<Date>(
			get: { minutes2Date(minutes: self.wrappedValue) },
			set: { self.wrappedValue = date2Minutes(date: $0) }
		)
	}
}

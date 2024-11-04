//
//  TimePicker.swift
//  HeatSched
//
//  Created by Georg Kemser on 18.10.24.
//

import SwiftUI

struct TimePicker: View {
	@Binding var targetTime: Int

	var body: some View {
		HStack {
			DatePicker(
				"",
				selection: self.$targetTime.minutes2TimePicker(),
				displayedComponents: .hourAndMinute
			)
			.labelsHidden()
			.datePickerStyle(WheelDatePickerStyle())
			.onAppear {
				UIDatePicker.appearance().minuteInterval = 5
			}
		}
		.frame(width: 60, height: 100, alignment: .center)
		.transformEffect(.init(scaleX: 1.4, y: 1.4))
	}
}

// needed for converting binded Int to binded Date, readable for timepicker
extension Binding where Value == Int {
	func minutes2TimePicker() -> Binding<Date> {
		return Binding<Date>(get: { minutes2Date(minutes: self.wrappedValue) }, set: { self.wrappedValue = date2Minutes(date: $0) })
	}
}

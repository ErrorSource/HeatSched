//
//  TimePicker.swift
//  HeatSched
//
//  Created by Georg Kemser on 18.10.24.
//

import SwiftUI

struct TimePicker: View {
	@Binding var targetTime: Date
	
	var body: some View {
		HStack {
			DatePicker(
				"",
				selection: $targetTime,
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

//
//  TimePicker.swift
//  HeatSched
//

import SwiftUI

struct TimePicker: View {
	@Binding var targetTime: Int
	@State var source: timePickerSource
	@Binding var neighbours: (left: HMSegment?, right: HMSegment?)
	@Binding var chartSegments: [HMSegment]
	@State var leftLimit: Int?
	@State var rightLimit: Int?

	@Environment(\.dismiss) var dismiss

	var body: some View {
		ZStack {
			VStack {
				DatePicker(
					"",
					selection: self.$targetTime.minutes2TimePicker(),
					in: self.calculateLeftLimit() ... self.calculateRightLimit(),
					displayedComponents: .hourAndMinute
				)
				.id(self.targetTime)
				.labelsHidden()
				.datePickerStyle(WheelDatePickerStyle())
				.onAppear {
					UIDatePicker.appearance().minuteInterval = Properties.minuteInterval
					// append a new segement, if till time was 1440 and should be changed (23:45)
					if (self.source == timePickerSource.till && self.targetTime == 1440) {
						self.chartSegments.append(HMSegment(startMinute: 1440 - Properties.minuteInterval, endMinute: 1440, targetTemp: 19.0))
						self.targetTime = 1440 - Properties.minuteInterval
					}
				}
				.onChange(of: self.targetTime) { (_, newValue) in
					if (self.source == timePickerSource.from) {
						// "move"/change the neighbour-segment as well
						self.neighbours.left?.endMinute = newValue
					} else {
						if (self.neighbours.left?.endMinute != nil && newValue <= self.neighbours.left!.endMinute) {
							// don't let the start-time be less then the end-time of segment in front of
							self.targetTime = self.neighbours.left!.endMinute + Properties.minuteInterval
						} else {
							// "move"/change the neighbour-segment as well
							self.neighbours.right?.startMinute = newValue
						}
					}
				}
				.frame(width: 60, height: 100, alignment: .center)
				.transformEffect(.init(scaleX: 1.4, y: 1.4))

				Spacer().frame(height: 40)
			}

			if (self.source == timePickerSource.till && self.neighbours.right?.endMinute == 1440 && self.targetTime < 1440) {
				HStack {
					Spacer()

					Button(action: {
						// remove last "virtual" low-temperature segment, because actual segment will be last one
						self.chartSegments.removeLast()
						self.targetTime = 1440 // manually set targettime to 00:00 the next day
						self.dismiss()
					}) {
						Image(systemName: "arrow.right.to.line.circle.fill")
							.resizable()
							.scaledToFit()
							.frame(width: 40, height: 40)
					}
					.tint(Color.gray)
					.padding()
				}
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
	}

	func calculateLeftLimit() -> Date {
		let limit = minutes2Date(minutes: self.leftLimit ?? 0)
		return limit
	}

	func calculateRightLimit() -> Date {
		let limit = minutes2Date(minutes: self.rightLimit ?? 1440 - Properties.minuteInterval)
		return limit
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

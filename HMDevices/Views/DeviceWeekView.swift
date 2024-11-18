//
//  DeviceWeekView.swift
//  HeatSched
//

import SwiftUI

struct DeviceWeekView: View {
	let device: String
	let profile: String

	var body: some View {
		NavigationStack {
			List(weekDays, id: \.self) { weekDay in
				NavigationLink {
					DeviceDayView(device: device, profile: profile, weekDay: weekDay)
				} label: {
					Text(weekDay)
				}
			}
			.navigationTitle("\(device) - \(profile)")
			.listStyle(PlainListStyle())
//			.navigationBarTitleDisplayMode(.inline)
		}
	}
}

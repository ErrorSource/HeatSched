//
//  DeviceWeekView.swift
//  HeatSched
//
//  Created by Georg Kemser on 26.02.23.
//

import SwiftUI

struct DeviceWeekView: View {
	let device: String
	let profile: String

	let weekDays = [
		"Montag",
		"Dienstag",
		"Mittwoch",
		"Donnerstag",
		"Freitag",
		"Samstag",
		"Sonntag"
	]

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

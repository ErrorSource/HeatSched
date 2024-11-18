//
//  DeviceOverview.swift
//  HeatSched
//

import SwiftUI

struct DeviceProfilesView: View {
	let device: String

	var body: some View {
		NavigationStack {
			List(profiles, id: \.self) { profile in
				NavigationLink {
					DeviceWeekView(device: device, profile: profile)
				} label: {
					Text(profile)
				}
			}
			.navigationTitle(device)
			.listStyle(PlainListStyle())
//			.navigationBarTitleDisplayMode(.inline)
		}
	}
}

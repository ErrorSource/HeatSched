//
//  DeviceOverview.swift
//  HeatSched
//
//  Created by Georg Kemser on 25.02.23.
//

import SwiftUI

struct DeviceProfilesView: View {
	let device: String

	let profiles = [
		"Profil 1",
		"Profil 2",
		"Profil 3"
	]

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

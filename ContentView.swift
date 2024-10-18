//
//  ContentView.swift
//  HeatSched
//
//  Created by Georg Kemser on 25.02.23.
//

import SwiftUI

struct ContentView: View {
	let devices = [
		"Wohnzimmer",
		"Esszimmer",
		"Arbeitszimmer",
		"Kinderzimmer",
		"Küche",
		"Bad"
	]
	
	var body: some View {
		NavigationStack {
			List(devices, id: \.self) { device in
				NavigationLink {
					DeviceProfilesView(device: device)
				} label: {
					Text(device)
				}
			}
			.navigationTitle("Thermostate")
			.listStyle(PlainListStyle())
//			.navigationBarTitleDisplayMode(.inline)
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}

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
			List(devices, id: \.self) { devices in
				NavigationLink {
					DeviceOverview(name: devices)
				} label: {
					Text(devices)
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

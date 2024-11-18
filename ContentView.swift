//
//  ContentView.swift
//  HeatSched
//

import SwiftUI

struct ContentView: View {
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

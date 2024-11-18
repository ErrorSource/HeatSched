//
//  HeatSchedApp.swift
//  HeatSched
//

import SwiftUI
import SwiftData

@main
struct HeatSchedApp: App {
	var body: some Scene {
		WindowGroup {
//			ContentView()
			DeviceDayView(device: "Wohnzimmer", profile: "Profil 1", weekDay: "Montag")
		}
		.modelContainer(for: [HMSegment.self], isAutosaveEnabled: false)
	}
}

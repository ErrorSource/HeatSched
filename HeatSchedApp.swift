//
//  HeatSchedApp.swift
//  HeatSched
//
//  Created by Georg Kemser on 25.02.23.
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
		.modelContainer(for: HMSegment.self)
	}
}

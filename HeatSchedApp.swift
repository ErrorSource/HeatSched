//
//  HeatSchedApp.swift
//  HeatSched
//
//  Created by Georg Kemser on 25.02.23.
//

import SwiftUI

@main
struct HeatSchedApp: App {
	var body: some Scene {
		WindowGroup {
//			ContentView()
			DeviceDayView(device: "Wohnzimmer", profile: "Profil 1", weekDay: "Montag")
		}
	}
}

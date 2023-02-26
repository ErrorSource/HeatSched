//
//  DeviceOverview.swift
//  HeatSched
//
//  Created by Georg Kemser on 25.02.23.
//

import SwiftUI

struct DeviceOverview: View {
	let name: String

	var body: some View {
		Text("Selected player: \(name)")
			.font(.largeTitle)
	}
}

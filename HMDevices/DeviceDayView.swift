//
//  DeviceDayView.swift
//  HeatSched
//
//  Created by Georg Kemser on 26.02.23.
//

import SwiftUI

struct DeviceDayView: View {
	let device: String
	let profile: String
	let weekDay: String
	
	var body: some View {
		HStack{
			Text("\(device) - \(profile) - \(weekDay)")
			.font(.subheadline)
			.fontWeight(.bold)
			.foregroundColor(Color.orange)
		}
	}
}

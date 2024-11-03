//
//  EditTempChangeView.swift
//  HeatSched
//
//  Created by Georg Kemser on 02.11.24.
//

import SwiftUI
import SwiftData

struct EditSegmentView: View {
	@Bindable var segment: HMSegment
	
	@Environment(\.dismiss) var dismiss
	
	// initial tab-/button-selection of tabbar [ start | temp | end ]
	@State private var selectedOption: Int = 2
	
//	@State var targetTemp: CGFloat = 20.5
//	@State var targetFromDate: Date = minutes2Date(minutes: 375)
//	@State var targetTillDate: Date = minutes2Date(minutes: 950)
	
	var body: some View {
		VStack {
			Picker(selection: $selectedOption, label: Text("")) {
				Text(minutes2TimeOutput(segment.startMinute)).tag(1)
				Text(temperatureOutput(segment.targetTemp)).tag(2)
				Text(minutes2TimeOutput(segment.endMinute)).tag(3)
			}
			.pickerStyle(SegmentedPickerStyle())
			
			if (selectedOption == 1) {
				FromTime(startMinute: $segment.startMinute)
			} else if (selectedOption == 2) {
				TargetTemp(targetTemp: $segment.targetTemp)
			} else if (selectedOption == 3) {
				TillTime(endMinute: $segment.endMinute)
			} else {
				TargetTemp(targetTemp: $segment.targetTemp)
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
		.navigationBarBackButtonHidden(true)
		
		HStack {
			Button(action: {
				dismiss()
			}) {
				Image(systemName: "x.circle.fill")
					.resizable()
					.scaledToFit()
					.frame(width: 40, height: 40)
			}
			.padding()
			Spacer()
			Button(action: {
				dismiss()
			}) {
				Image(systemName: "checkmark.circle.fill")
					.resizable()
					.scaledToFit()
					.frame(width: 40, height: 40)
			}
			.padding()
			.disabled(segment.startMinute >= segment.endMinute)
		}
	}
}

struct FromTime: View {
	@Binding var startMinute: Int
	
	var body: some View {
		VStack {
			TimePicker(targetTime: $startMinute)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
	}
}

struct TargetTemp: View {
	@Binding var targetTemp: Double
	
	var body: some View {
		VStack {
			TemperatureControlView(targetTemp: $targetTemp)
			
			Spacer().frame(height: 32)
			
			HStack {
				Button(action: {
					targetTemp = 19.0
				}) {
					Image(systemName: "moon.circle.fill")
						.resizable()
						.scaledToFit()
						.foregroundColor(Color.blue)
						.frame(width: 40, height: 40)
				}
				.padding()
				Spacer().frame(width: 16)
				Button(action: {
					targetTemp = 21.0
				}) {
					Image(systemName: "sun.max.circle.fill")
						.resizable()
						.scaledToFit()
						.foregroundColor(Color.red)
						.frame(width: 40, height: 40)
				}
				.padding()
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
	}
}

struct TillTime: View {
	@Binding var endMinute: Int
	
	var body: some View {
		VStack {
			TimePicker(targetTime: $endMinute)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
	}
}

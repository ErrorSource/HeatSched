//
//  DeviceDayView.swift
//  HeatSched
//
//  Created by Georg Kemser on 26.02.23.
//

import SwiftUI
import Charts

struct DeviceDayView: View {
	let device: String
	let profile: String
	let weekDay: String
	
	@State var targetTempSet: CGFloat = 0.0
	
	let weekDays = [
		"Montag",
		"Dienstag",
		"Mittwoch",
		"Donnerstag",
		"Freitag",
		"Samstag",
		"Sonntag"
	]
	
	var body: some View {
		GeometryReader { geometry in
			VStack {
				VStack {
					Text(profile)
						.font(.subheadline)
						.fontWeight(.bold)
						.foregroundColor(Color.orange)
						.frame(maxWidth: .infinity, alignment: .leading)
					HStack {
						Text(device)
						Spacer()
						Text(weekDay)
					}
					.frame(maxWidth: .infinity)
				}
				.frame(alignment: .topLeading)
				
				VStack {
					Chart(data) {
						LineMark(
							x: .value("Hour", $0.date, unit: .hour),
							y: .value("Temp", $0.targetTemp)
						)
					}
					.chartYScale(domain: 18...23)
					.frame(height: 100)
				}
				.frame(maxWidth: .infinity, minHeight: 100, maxHeight: 100, alignment: .top)
				
				Spacer().frame(height: 20)
				
				NavigationStack {
					List(weekDays, id: \.self) { weekDay in
						NavigationLink {
							EditSegmentItem(weekDay: weekDay)
						} label: {
							Segments()
						}
						.swipeActions(edge: .leading) {
							Button() {
								print("Kopieren!")
							} label: {
								Label("", systemImage: "document.on.document.fill")
							}
							.tint(Color.blue)
						}
						.swipeActions(edge: .trailing) {
							Button() {
								print("Löschen!")
							} label: {
								Label("", systemImage: "delete.left.fill")
							}
							.tint(Color.red)
						}
					}
					.listStyle(PlainListStyle())
		//			.navigationBarTitleDisplayMode(.inline)
					
					HStack {
						Spacer()
						
						Button(action: {
							// add an item
						}) {
							Image(systemName: "plus.circle.fill")
								.resizable()
								.scaledToFit()
								.frame(width: 40, height: 40)
						}
						.padding()
					}
					.frame(maxWidth: .infinity, alignment: .trailing)
				}
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
			.padding()
		}
	}
}

struct Segments: View {
	var body: some View {
		HStack {
			VStack {
				Text("06:00")
				Text("09:00")
			}
			Spacer()
			Text("21,0")
		}
		.frame(maxWidth: .infinity)
	}
}

struct EditSegmentItem: View {
	@Environment(\.dismiss) var dismiss
	
	let weekDay: String
	
	// initial tab-/button-selection
	@State private var selectedOption: Int = 2
	
	@State var targetTemp: CGFloat = 20.5
	@State var targetFromDate: Date = Calendar.current.nextDate(after: Date(), matching: .init(hour: 8, minute: 30), matchingPolicy: .strict)!
	@State var targetTillDate: Date = Calendar.current.nextDate(after: Date(), matching: .init(hour: 14, minute: 15), matchingPolicy: .strict)!
	
	var body: some View {
		VStack {
			Picker(selection: $selectedOption, label: Text("")) {
				Text("\(targetFromDate.formatted(.dateTime.hour().minute())) Uhr").tag(1)
				Text("\(String.init(format: "%.1f", targetTemp))ºC").tag(2)
				Text("\(targetTillDate.formatted(.dateTime.hour().minute())) Uhr").tag(3)
			}
			.pickerStyle(SegmentedPickerStyle())
			
			if (selectedOption == 1) {
				FromTime(targetFromTime: $targetFromDate)
			} else if (selectedOption == 2) {
				TargetTemp(targetTemp: $targetTemp)
			} else if (selectedOption == 3) {
				TillTime(targetTillTime: $targetTillDate)
			} else {
				TargetTemp(targetTemp: $targetTemp)
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
			.disabled(targetFromDate >= targetTillDate)
		}
	}
}

struct FromTime: View {
	@Binding var targetFromTime: Date
	
	var body: some View {
		VStack {
			TimePicker(targetTime: $targetFromTime)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
	}
}

struct TargetTemp: View {
	@Binding var targetTemp: CGFloat
	
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
	@Binding var targetTillTime: Date
	
	var body: some View {
		VStack {
			TimePicker(targetTime: $targetTillTime)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
	}
}

struct TempChange: Identifiable {
	var id = UUID()
	var date: Date
	var targetTemp: Double
	
	init(hour: Int, minutes: Int, targetTemp: Double) {
		let calendar = Calendar.autoupdatingCurrent
		self.date = calendar.date(from: DateComponents(hour: hour, minute: minutes))!
		self.targetTemp = targetTemp
	}
}

var data: [TempChange] = [
	TempChange(hour: 0, minutes: 0, targetTemp: 19),
	TempChange(hour: 6, minutes: 15, targetTemp: 19),
	TempChange(hour: 6, minutes: 15, targetTemp: 21),
	TempChange(hour: 12, minutes: 30, targetTemp: 21),
	TempChange(hour: 12, minutes: 30, targetTemp: 20),
	TempChange(hour: 19, minutes: 0, targetTemp: 20),
	TempChange(hour: 19, minutes: 0, targetTemp: 19),
	TempChange(hour: 24, minutes: 0, targetTemp: 19)
]

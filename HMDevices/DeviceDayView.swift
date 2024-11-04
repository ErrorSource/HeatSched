//
//  DeviceDayView.swift
//  HeatSched
//
//  Created by Georg Kemser on 26.02.23.
//

import SwiftUI
import SwiftData
import Charts

struct DeviceDayView: View {
	let device: String
	let profile: String
	let weekDay: String
	
	@Environment(\.modelContext) var modelContext
	@Query(sort: \HMSegment.startMinute, order: .forward) var segments: [HMSegment]
	
	@State var navigationPath: [HMSegment] = []
	
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
		GeometryReader { _ in
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
					Chart(segments) {
						LineMark(
							x: .value("Hour", minutes2Date(minutes: $0.startMinute), unit: .hour),
							y: .value("Temp", $0.targetTemp)
						)
						LineMark(
							x: .value("Hour", minutes2Date(minutes: $0.endMinute), unit: .hour),
							y: .value("Temp", $0.targetTemp)
						)
					}
					.chartYScale(domain: 18 ... 23)
					.frame(height: 100)
				}
				.frame(maxWidth: .infinity, minHeight: 100, maxHeight: 100, alignment: .top)
				
				Spacer().frame(height: 20)
				
				NavigationStack(path: $navigationPath) {
					List {
						ForEach(segments, id: \.self) { (segment) in
							NavigationLink(value: segment) {
								SegmentItemView(segment: segment)
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
									deleteSegment(segment: segment)
								} label: {
									Label("", systemImage: "delete.left.fill")
								}
								.tint(Color.red)
							}
						}
					}
					.listStyle(PlainListStyle())
					// .navigationBarTitleDisplayMode(.inline)
					.navigationDestination(for: HMSegment.self) { segment in
						EditSegmentView(segment: segment)
					}
					
					HStack {
						Spacer()
						
						Button(action: addSegment) {
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
	
	func addSegment() {
		let newSegment = HMSegment(startMinute: 0, endMinute: 1440, targetTemp: 19.0)
		modelContext.insert(newSegment)
		navigationPath.append(newSegment)
	}
	
	func deleteSegment(segment: HMSegment) {
		modelContext.delete(segment)
		try! modelContext.save()
	}
}

struct SegmentItemView: View {
	var segment: HMSegment
	
	var body: some View {
		HStack {
			VStack {
				Text(minutes2TimeOutput(segment.startMinute))
				Text(minutes2TimeOutput(segment.endMinute))
			}
			Spacer()
			Text(temperatureOutput(segment.targetTemp))
		}
		.frame(maxWidth: .infinity)
	}
}

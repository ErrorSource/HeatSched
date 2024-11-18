//
//  DeviceDayView.swift
//  HeatSched
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
	@State var chartSegments: [HMSegment] = []
	
	@State var leftSegment: HMSegment?
	@State var rightSegment: HMSegment?
	@State var neighbours: (left: HMSegment?, right: HMSegment?)

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
					Chart(chartSegments) {
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
						ForEach(segments, id: \.id) { (segment) in
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
						EditSegmentView(segment: segment, neighbours: getNeighbourSegments(ofSegment: segment)) { action in
							switch action {
							case .save:
								saveSegment(segment: segment)
							case .cancel:
								if (modelContext.hasChanges) {
									modelContext.rollback()
								}
								chartSegments = calculateChartSegments(dataSegments: segments)
							}
						}
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
						.disabled(segments.count > 10) // HM just allowes 13 segments; also substract 2 segments for virtual beginning- and ending-segments
					}
					.frame(maxWidth: .infinity, alignment: .trailing)
				}
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
			.padding()
		}
		.onAppear() {
			chartSegments = calculateChartSegments(dataSegments: segments)
		}
	}
	
	func addSegment() {
		let newSegment = HMSegment(startMinute: getNextAvailbleSegmentStart(), endMinute: 1440, targetTemp: 19.0)
		navigationPath.append(newSegment)
		if (chartSegments.last?.endMinute == 1440) {
			chartSegments.removeLast()
		}
		chartSegments.append(newSegment)
	}
	
	func deleteSegment(segment: HMSegment) {
		modelContext.delete(segment)
		try! modelContext.save()
		chartSegments = calculateChartSegments(dataSegments: segments)
	}
	
	func saveSegment(segment: HMSegment) {
		if (!segments.contains(segment)) {
			modelContext.insert(segment)
		}
		try! modelContext.save()
		chartSegments = calculateChartSegments(dataSegments: segments)
	}
	
	func getNextAvailbleSegmentStart() -> Int {
		let lastSegment = segments.last
		return lastSegment?.endMinute ?? 0
	}
	
	func calculateChartSegments(dataSegments: [HMSegment]) -> [HMSegment] {
		chartSegments = dataSegments
		
		// no segments definded yet? display one line with lower temperature
		if (dataSegments.isEmpty) {
			return [HMSegment(startMinute: 0, endMinute: 1440, targetTemp: 19.0)]
		} else {
			// add beginning (from 00:00) and ending (to 24:00) "virtual" segment, if needed
			if (dataSegments.first?.startMinute != 0) {
				chartSegments.insert(HMSegment(startMinute: 0, endMinute: chartSegments.first!.startMinute, targetTemp: 19.0), at: 0)
			}
			if (dataSegments.last?.endMinute != 1440) {
				chartSegments.append(HMSegment(startMinute: chartSegments.last!.endMinute, endMinute: 1440, targetTemp: 19.0))
			}
		}
		
		// add intermediate segment, if there is a gap between the segments
		for segment in dataSegments {
			if let nextSegment = dataSegments.sorted(by: { $0.startMinute < $1.startMinute }).first(where: { $0.startMinute >= segment.endMinute }) {
				if (segment.endMinute != nextSegment.startMinute) {
					chartSegments.append(HMSegment(startMinute: segment.endMinute, endMinute: nextSegment.startMinute, targetTemp: 19.0))
				}
			}
		}
		
		return chartSegments.sorted { $0.startMinute < $1.startMinute }
	}
	
	func getNeighbourSegments(ofSegment: HMSegment) -> Binding<(left: HMSegment?, right: HMSegment?)> {
//		if let currentSegment = chartSegments.first {
//			prevSegment = chartSegments.first(where: { $0.startMinute > currentSegment.startMinute })
//			nextSegment = chartSegments.first(where: { $0.startMinute < currentSegment.startMinute })
//		}
		// find "virtual" (lower temperature) previous and next segments in chartSegments; if there are any, change them as well
		leftSegment = chartSegments.sorted(by: { $0.startMinute < $1.startMinute }).first(where: { $0.endMinute == ofSegment.startMinute })
		rightSegment = chartSegments.sorted(by: { $0.startMinute < $1.startMinute }).first(where: { $0.startMinute == ofSegment.endMinute })
		
		neighbours = (left: leftSegment, right: rightSegment)
		return $neighbours
	}
}

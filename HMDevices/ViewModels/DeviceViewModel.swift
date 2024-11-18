////
////  DeviceViewModel.swift
////  HeatSched
////
//
// import Foundation
// import SwiftData
//
// class DeviceViewModel: ObservableObject {
//	var modelContext: ModelContext
//
//	init(modelContext: ModelContext) {
//		self.modelContext = modelContext
//	}
//
//	func addSegment(path: inout [HMSegment]) {
//		let newSegment = HMSegment(startMinute: 0, endMinute: 1440, targetTemp: 19.0)
//		modelContext.insert(newSegment)
//		try! modelContext.save()
//		path.append(newSegment)
//	}
//
//	func deleteSegment(segment: HMSegment) {
//		modelContext.delete(segment)
//		try! modelContext.save()
//	}
// }

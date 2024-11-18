//
//  SegmentItemView.swift
//  HeatSched
//

import SwiftUI

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

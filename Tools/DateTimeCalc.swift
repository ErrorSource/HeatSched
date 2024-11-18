//
//  DateTimeCalc.swift
//  HeatSched
//

import SwiftUI

// calculate daily minutes to a date object: 750 minutes = 12:30 o'clock
func minutes2Date(minutes: Int) -> Date {
	let timeInterval = TimeInterval(minutes * 60)
	return Calendar.current.startOfDay(for: Date()).addingTimeInterval(timeInterval)
}

// calculate a date object to daily minutes: 12:30 o'clock = 750 minutes
func date2Minutes(date: Date) -> Int {
	let hourMinutes = Calendar.current.dateComponents([.hour, .minute], from: date)
	return hourMinutes.hour! * 60 + hourMinutes.minute!
}

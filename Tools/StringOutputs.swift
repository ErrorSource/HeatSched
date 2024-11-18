//
//  StringOutputs.swift
//  HeatSched
//

import Foundation

func temperatureOutput(_ temperature: Double) -> String {
	let nfDE = NumberFormatter()
	nfDE.numberStyle = .decimal
	nfDE.minimumFractionDigits = 1
	nfDE.maximumFractionDigits = 1
	nfDE.decimalSeparator = ","

	return "\(nfDE.string(from: temperature as NSNumber) ?? "")ºC"
}

func minutes2TimeOutput(_ minutes: Int) -> String {
	let date = minutes2Date(minutes: minutes)
	let formatter = DateFormatter()
	formatter.dateFormat = "HH:mm"

	return "\(formatter.string(from: date)) Uhr"
}

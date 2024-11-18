//
//  TemperatureControlView.swift
//  HeatSched
//

import SwiftUI

let config = Config(
	radius: 125.0,
	knobRadius: 15.0,
	minimumValue: 18.0,
	maximumValue: 24.0,
	lowValue: 19.0
)

struct TemperatureControlView: View {
	@Binding var targetTemp: Double
	@State private var angleValue: CGFloat = 0.0
	
	init(targetTemp: Binding<Double>) {
		self._targetTemp = targetTemp
		_angleValue = State(initialValue: calcAngelFromTargetTemp(targetTemp: targetTemp.wrappedValue))
	}
	
	var body: some View {
		ZStack {
//			Circle()
//				.stroke(Color.gray.opacity(0.2), lineWidth: 1)
//				.frame(width: config.radius * 2, height: config.radius * 2)
//				.scaleEffect(1.2)
			
			Circle()
				.stroke(Color.gray, style: StrokeStyle(lineWidth: 3, lineCap: .butt, dash: [3, 23.18]))
				.frame(width: config.radius * 2, height: config.radius * 2)
			
			Circle()
				.trim(from: 0.0, to: (targetTemp - config.minimumValue) / (config.maximumValue - config.minimumValue))
				.stroke((targetTemp <= config.lowValue) ? Color.blue : Color.red, lineWidth: 4)
				.frame(width: config.radius * 2, height: config.radius * 2)
				.rotationEffect(.degrees(-90))
			
			Circle()
				.fill((targetTemp <= config.lowValue) ? Color.blue : Color.red)
				.frame(width: config.knobRadius * 2, height: config.knobRadius * 2)
				.padding(10)
				.offset(y: -config.radius)
				.rotationEffect(Angle.degrees(Double(angleValue)))
				.gesture(DragGesture(minimumDistance: 0.0)
					.onChanged { value in
						change(location: value.location)
					})
			
			Text("\(String(format: "%.1f", targetTemp))ºC")
				.font(.system(size: 60))
				.foregroundColor((targetTemp <= config.lowValue) ? Color.blue : Color.red)
		}
		.onChange(of: targetTemp) {
			angleValue = calcAngelFromTargetTemp(targetTemp: targetTemp)
		}
	}
	
	private func change(location: CGPoint) {
		// creating vector from location point
		let vector = CGVector(dx: location.x, dy: location.y)
		
		// geting angle in radian need to subtract the knob radius and padding from the dy and dx
		let angle = atan2(vector.dy - (config.knobRadius + 10), vector.dx - (config.knobRadius + 10)) + .pi / 2.0
		
		// convert angle range from (-pi to pi) to (0 to 2pi)
		let fixedAngle = (angle < 0.0) ? angle + 2.0 * .pi : angle
		
		// convert angle value to temperature value
		let value = CGFloat(roundf(Float(fixedAngle / (2.0 * .pi) * (config.maximumValue - config.minimumValue)) * 2.0) * 0.5) + config.minimumValue
		
		if value >= config.minimumValue && value <= config.maximumValue {
			targetTemp = value
			angleValue = fixedAngle * 180 / .pi // converting to degree
		}
	}
}

func calcAngelFromTargetTemp(targetTemp: Double) -> Double {
	return ((((targetTemp - config.minimumValue) / 0.5) / 2.0) / (config.maximumValue - config.minimumValue) * 360)
}

struct Config {
	let radius: CGFloat
	let knobRadius: CGFloat
	let minimumValue: CGFloat
	let maximumValue: CGFloat
	let lowValue: CGFloat
}

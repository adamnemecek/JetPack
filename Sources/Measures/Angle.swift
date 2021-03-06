private let degreesPerRadian = 180.0 / .Pi
private let radiansPerDegree = .Pi / 180.0


public struct Angle: Measure {

	public static let name = "Angle"
	public static let rawUnit = AngleUnit.Degrees

	public var rawValue: Double


	public init(_ value: Double, unit: AngleUnit) {
		precondition(!value.isNaN, "Value must not be NaN.")

		switch unit {
		case .Degrees: rawValue = value
		case .Radians: rawValue = value * degreesPerRadian
		}
	}


	public init(degrees: Double) {
		self.init(degrees, unit: .Degrees)
	}


	public init(radians: Double) {
		self.init(radians, unit: .Radians)
	}


	public init(rawValue: Double) {
		self.rawValue = rawValue
	}


	public var degrees: Double {
		return rawValue
	}


	public var radians: Double {
		return degrees * radiansPerDegree
	}


	public func valueInUnit(unit: AngleUnit) -> Double {
		switch unit {
		case .Degrees: return degrees
		case .Radians: return radians
		}
	}
}


extension Angle: CustomDebugStringConvertible {

	public var debugDescription: String {
		return "\(rawValue.description) \(Angle.rawUnit.debugDescription)"
	}
}


extension Angle: CustomStringConvertible {

	public var description: String {
		return "\(rawValue.description) \(Angle.rawUnit.abbreviation)"
	}
}


extension Angle: Hashable {

	public var hashValue: Int {
		return rawValue.hashValue
	}
}



public enum AngleUnit: Unit {
	case Degrees
	case Radians
}


extension AngleUnit {

	public var abbreviation: String {
		switch self {
		case .Degrees:
			return "deg"

		case .Radians:
			return "rad"
		}
	}


	public var pluralName: String {
		switch self {
		case .Degrees:
			return "Degrees"

		case .Radians:
			return "Radians"
		}
	}


	public var singularName: String {
		switch self {
		case .Degrees:
			return "Degree"

		case .Radians:
			return "Radian"
		}
	}


	public var symbol: String? {
		switch self {
		case .Degrees:
			return "°"

		case .Radians:
			return "\u{33AD}"
		}
	}
}


extension AngleUnit: CustomDebugStringConvertible {

	public var debugDescription: String {
		return "AngleUnit(\(pluralName))"
	}
}


extension AngleUnit: CustomStringConvertible {

	public var description: String {
		return pluralName
	}
}

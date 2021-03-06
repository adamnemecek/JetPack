import Darwin


public extension Float {

	public static let Epsilon = Float(FLT_EPSILON)
	public static let Pi = Float(M_PI)


	public var rounded: Float {
		return round(self)
	}


	public func roundedTo(increment: Float) -> Float {
		return round(self / increment) * increment
	}


	public var roundedDown: Float {
		return floor(self)
	}


	public var roundedUp: Float {
		return ceil(self)
	}
}

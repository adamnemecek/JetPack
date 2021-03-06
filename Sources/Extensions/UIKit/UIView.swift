import UIKit

private let dummyView = UIView()


public extension UIView {

	@nonobjc
	@warn_unused_result
	public final func alignToGrid(rect: CGRect) -> CGRect {
		return CGRect(origin: alignToGrid(rect.origin), size: alignToGrid(rect.size))
	}


	@nonobjc
	@warn_unused_result
	public final func alignToGrid(point: CGPoint) -> CGPoint {
		return CGPoint(left: roundToGrid(point.left), top: roundToGrid(point.top))
	}


	@nonobjc
	@warn_unused_result
	public final func alignToGrid(size: CGSize) -> CGSize {
		return CGSize(width: ceilToGrid(size.width), height: ceilToGrid(size.height))
	}


	@nonobjc
	@warn_unused_result
	public final func ceilToGrid(value: CGFloat) -> CGFloat {
		let scale = gridScaleFactor
		return ceil(value * scale) / scale
	}


	@nonobjc
	public static func defaultActionForLayer(layer: CALayer, forKey key: String) -> CAAction? {
		guard key != "delegate" else {
			return nil
		}

		let dummyLayer = dummyView.layer

		let layerDelegate = layer.delegate
		layer.delegate = dummyView
		defer { layer.delegate = layerDelegate }

		return layer.actionForKey(key)
	}


	@nonobjc
	public final var delegateViewController: UIViewController? {
		// this or private API…
		return nextResponder() as? UIViewController
	}


	@nonobjc
	@warn_unused_result
	public final func floorToGrid(value: CGFloat) -> CGFloat {
		let scale = gridScaleFactor
		return floor(value * scale) / scale
	}


	@nonobjc
	@warn_unused_result
	public func frameWhenApplyingTransform(transform: CGAffineTransform) -> CGRect {
		return untransformedFrame.transform(transform, anchorPoint: layer.anchorPoint)
	}


	@nonobjc
	public final var gridScaleFactor: CGFloat {
		return max(contentScaleFactor, (window?.screen.scale ?? UIScreen.mainScreen().scale))
	}


	@nonobjc
	@warn_unused_result
	public final func heightThatFits() -> CGFloat {
		return sizeThatFitsSize(.max).height
	}


	@nonobjc
	@warn_unused_result
	public final func heightThatFitsWidth(maximumWidth: CGFloat) -> CGFloat {
		return sizeThatFitsSize(CGSize(width: maximumWidth, height: .max)).height
	}


	@nonobjc
	public var needsLayout: Bool {
		return layer.needsLayout()
	}


	@nonobjc
	public var participatesInHitTesting: Bool {
		return (!hidden && userInteractionEnabled && alpha >= 0.01)
	}


	@nonobjc
	public func pixelsForPoints(points: CGFloat) -> CGFloat {
		return points * gridScaleFactor
	}


	@nonobjc
	public func pointsForPixels(pixels: CGFloat) -> CGFloat {
		return pixels / gridScaleFactor
	}


	@nonobjc
	public func recursivelyFindSuperviewOfType <ViewType: UIView>(type: ViewType.Type) -> ViewType? {
		var view = self
		while let superview = view.superview {
			if let superview = superview as? ViewType {
				return superview
			}

			view = superview
		}

		return nil
	}


	@nonobjc
	public func removeAllSubviews() {
		for subview in subviews.reverse() {
			subview.removeFromSuperview()
		}
	}


	@nonobjc
	@warn_unused_result
	public final func roundToGrid(value: CGFloat) -> CGFloat {
		let scale = gridScaleFactor
		return round(value * scale) / scale
	}


	@nonobjc
	@warn_unused_result
	public final func sizeThatFits() -> CGSize {
		return sizeThatFitsSize(.max)
	}


	@nonobjc
	@warn_unused_result
	public final func sizeThatFitsHeight(maximumHeight: CGFloat, allowsTruncation: Bool = false) -> CGSize {
		return sizeThatFitsSize(CGSize(width: .max, height: maximumHeight), allowsTruncation: allowsTruncation)
	}


	@nonobjc
	@warn_unused_result
	public final func sizeThatFitsWidth(maximumWidth: CGFloat, allowsTruncation: Bool = false) -> CGSize {
		return sizeThatFitsSize(CGSize(width: maximumWidth, height: .max), allowsTruncation: allowsTruncation)
	}


	@objc(JetPack_sizeThatFitsSize:)
	@warn_unused_result
	public func sizeThatFitsSize(maximumSize: CGSize) -> CGSize {
		return sizeThatFits(maximumSize)
	}


	@nonobjc
	@warn_unused_result
	public final func sizeThatFitsSize(maximumSize: CGSize, allowsTruncation: Bool) -> CGSize {
		var fittingSize = sizeThatFitsSize(maximumSize)
		if allowsTruncation {
			fittingSize = fittingSize.constrainTo(maximumSize)
		}

		return fittingSize
	}


	@objc(JetPack_subviewDidInvalidateIntrinsicContentSize:)
	public func subviewDidInvalidateIntrinsicContentSize(view: UIView) {
		// override in subclasses
	}


	@objc(JetPack_didChangeFromWindow:toWindow:)
	private dynamic func swizzled_didChangeWindow(from from: UIWindow?, to: UIWindow?) {
		swizzled_didChangeWindow(from: from, to: to)

		delegateViewController?.viewDidMoveToWindow()
	}


	@objc(JetPack_invalidateIntrinsicContentSize)
	private dynamic func swizzled_invalidateIntrinsicContentSize() {
		swizzled_invalidateIntrinsicContentSize()

		if let superview = superview {
			superview.subviewDidInvalidateIntrinsicContentSize(self)
		}
	}


	@nonobjc
	public var untransformedFrame: CGRect {
		get {
			let size = bounds.size
			let anchorPoint = layer.anchorPoint
			let centerOffset = CGPoint(left: (0.5 - anchorPoint.left) * size.width, top: (0.5 - anchorPoint.top) * size.height)

			return CGRect(size: size).centeredAt(center.offsetBy(centerOffset))
		}
		set {
			let anchorPoint = layer.anchorPoint
			let centerOffset = CGPoint(left: (0.5 - anchorPoint.left) * -newValue.width, top: (0.5 - anchorPoint.top) * -newValue.height)

			bounds = CGRect(origin: bounds.origin, size: newValue.size)
			center = newValue.center.offsetBy(centerOffset)
		}
	}


	@nonobjc
	internal static func UIView_setUp() {
		// cannot use didMoveToWindow() because some subclasses don't call super's implementation
		swizzleMethodInType(self, fromSelector: obfuscatedSelector("_", "did", "Move", "From", "Window:", "to", "Window:"), toSelector: #selector(swizzled_didChangeWindow(from:to:)))

		swizzleMethodInType(self, fromSelector: #selector(invalidateIntrinsicContentSize), toSelector: #selector(swizzled_invalidateIntrinsicContentSize))
	}


	@nonobjc
	@warn_unused_result
	public final func widthThatFits() -> CGFloat {
		return sizeThatFitsSize(.max).width
	}


	@nonobjc
	@warn_unused_result
	public final func widthThatFitsHeight(maximumHeight: CGFloat) -> CGFloat {
		return sizeThatFitsSize(CGSize(width: .max, height: maximumHeight)).width
	}
}



extension UIViewAnimationCurve: CustomStringConvertible {

	public var description: String {
		switch self.rawValue {
		case EaseIn.rawValue:    return "UIViewAnimationCurve.EaseIn"
		case EaseInOut.rawValue: return "UIViewAnimationCurve.EaseInOut"
		case EaseOut.rawValue:   return "UIViewAnimationCurve.EaseOut"
		case Linear.rawValue:    return "UIViewAnimationCurve.Linear"
		default:                 return "UIViewAnimationCurve(\(rawValue))"
		}
	}
}



public extension UIViewAnimationOptions {

	public init(curve: UIViewAnimationCurve) {
		self.init(rawValue: UInt((curve.rawValue & 7) << 16))
	}


	public var curve: UIViewAnimationCurve {
		return UIViewAnimationCurve(rawValue: Int((rawValue >> 16) & 7))!
	}
}


extension UIViewAnimationOptions: CustomStringConvertible {

	public var description: String {
		var options = [String]()
		if contains(.AllowAnimatedContent) {
			options.append("AllowAnimatedContent")
		}
		if contains(.AllowUserInteraction) {
			options.append("AllowUserInteraction")
		}
		if contains(.Autoreverse) {
			options.append("Autoreverse")
		}
		if contains(.BeginFromCurrentState) {
			options.append("BeginFromCurrentState")
		}
		switch curve.rawValue {
		case UIViewAnimationCurve.EaseIn.rawValue:    options.append("CurveEaseIn")
		case UIViewAnimationCurve.EaseInOut.rawValue: options.append("CurveEaseInOut")
		case UIViewAnimationCurve.EaseOut.rawValue:   options.append("CurveEaseOut")
		case UIViewAnimationCurve.Linear.rawValue:    options.append("CurveLinear")
		default:                                      options.append("Curve(\(curve.rawValue))")
		}
		if contains(.LayoutSubviews) {
			options.append("LayoutSubviews")
		}
		if contains(.OverrideInheritedCurve) {
			options.append("OverrideInheritedCurve")
		}
		if contains(.OverrideInheritedDuration) {
			options.append("OverrideInheritedDuration")
		}
		if contains(.OverrideInheritedOptions) {
			options.append("OverrideInheritedOptions")
		}
		if contains(.Repeat) {
			options.append("Repeat")
		}
		if contains(.ShowHideTransitionViews) {
			options.append("ShowHideTransitionViews")
		}
		if contains(.TransitionCurlUp) {
			options.append("TransitionCurlUp")
		}
		if contains(.TransitionCurlDown) {
			options.append("TransitionCurlDown")
		}
		if contains(.TransitionCrossDissolve) {
			options.append("TransitionCrossDissolve")
		}
		if contains(.TransitionFlipFromBottom) {
			options.append("TransitionFlipFromBottom")
		}
		if contains(.TransitionFlipFromLeft) {
			options.append("TransitionFlipFromLeft")
		}
		if contains(.TransitionFlipFromRight) {
			options.append("TransitionFlipFromRight")
		}
		if contains(.TransitionFlipFromTop) {
			options.append("TransitionFlipFromTop")
		}

		return "UIViewAnimationOptions(\(options.joinWithSeparator(", ")))"
	}
}


extension UIViewTintAdjustmentMode: CustomStringConvertible {

	public var description: String {
		switch self {
		case .Automatic: return "UIViewTintAdjustmentMode.Automatic"
		case .Dimmed:    return "UIViewTintAdjustmentMode.Dimmed"
		case .Normal:    return "UIViewTintAdjustmentMode.Normal"
		}
	}
}

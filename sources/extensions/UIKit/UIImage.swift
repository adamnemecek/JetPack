import UIKit


public extension UIImage {

	@nonobjc
	public convenience init?(placeholderOfSize size: CGSize) {
		let context = CGBitmapContextCreate(nil, Int(ceil(size.width)), Int(ceil(size.height)), 8, 0, CGColorSpaceCreateDeviceRGB(), CGImageAlphaInfo.PremultipliedLast.rawValue)
		guard let cgimage = CGBitmapContextCreateImage(context) else {
			return nil
		}

		self.init(CGImage: cgimage, scale: 1, orientation: .Up)
	}


	@nonobjc
	@warn_unused_result
	public static func fromColor(color: UIColor, withSize size: CGSize = CGSize(square: 1), scale: CGFloat = 1) -> UIImage {
		let frame = CGRect(size: size.scaleBy(scale))

		UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)

		let context = UIGraphicsGetCurrentContext()
		CGContextSetFillColorWithColor(context, color.CGColor)
		CGContextFillRect(context, frame)

		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return image
	}


	@nonobjc
	public var hasAlphaChannel: Bool {
		let info = CGImageGetAlphaInfo(CGImage)
		switch info {
		case .First, .Last, .Only, .PremultipliedFirst, .PremultipliedLast:
			return true

		case .None, .NoneSkipFirst, .NoneSkipLast:
			return false
		}
	}


	@available(*, deprecated=1, message="Define rendering mode in the asset catalog or use imageWithRenderingMode(_:)")
	@nonobjc
	@warn_unused_result
	public static func templateNamed(name: String) -> UIImage? {
		return self.init(named: name)?.imageWithRenderingMode(.AlwaysTemplate)
	}
}

import UIKit


public extension UIEdgeInsets {

	public static let zeroInsets = UIEdgeInsets()


	public init(all: CGFloat) {
		self.init(top: all, left: all, bottom: all, right: all)
	}
}


extension UIEdgeInsets: Equatable {}


public func == (a: UIEdgeInsets, b: UIEdgeInsets) -> Bool {
	return (a.top == b.top && a.left == b.left && a.bottom == b.bottom && a.right == b.right)
}

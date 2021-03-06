import UIKit


public extension UINavigationBar {

	@nonobjc
	internal private(set) static var isSettingPromptCount = 0


	internal func popNavigationItemWithTransition(transition: Int32) -> UINavigationItem {
		return swizzled_popNavigationItemWithTransition(transition)
	}


	internal func pushNavigationItem(item: UINavigationItem, transition: Int32) {
		swizzled_pushNavigationItem(item, transition: transition)
	}


	@objc(JetPack_popNavigationItemWithTransition:)
	private dynamic func swizzled_popNavigationItemWithTransition(transition: Int32) -> UINavigationItem {
		return popNavigationItemWithTransition(transition)
	}


	@objc(JetPack_pushNavigationItem:transition:)
	private dynamic func swizzled_pushNavigationItem(item: UINavigationItem, transition: Int32) {
		pushNavigationItem(item, transition: transition)
	}


	@objc(JetPack_setPrompt:)
	private dynamic func swizzled_setPrompt(prompt: String?) {
		// work around http://stackoverflow.com/questions/22115821/uinavigationitem-prompt-issue

		UINavigationBar.isSettingPromptCount += 1
		defer { UINavigationBar.isSettingPromptCount -= 1 }

		swizzled_setPrompt(prompt)
	}


	@nonobjc
	internal static func UINavigationBar_setUp() {
		// yep, private API necessary :(
		// If the private method is removed/renamed the related feature will cease to work but we won't crash.
		swizzleMethodInType(self, fromSelector: Selector("setPrompt:"), toSelector: #selector(swizzled_setPrompt(_:)))
		swizzleMethodInType(self, fromSelector: obfuscatedSelector("_", "popNavigationItemWithTransition:"), toSelector: #selector(swizzled_popNavigationItemWithTransition(_:)))
		swizzleMethodInType(self, fromSelector: obfuscatedSelector("_", "pushNavigationItem:", "transition:"), toSelector: #selector(swizzled_pushNavigationItem(_:transition:)))
	}
}

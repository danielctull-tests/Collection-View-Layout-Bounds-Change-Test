
import UIKit

public final class Layout: UICollectionViewFlowLayout {

	public override func invalidateLayout() {
		super.invalidateLayout()
		print("invalidateLayout()")
	}

	override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		let shouldInvalidate = super.shouldInvalidateLayout(forBoundsChange: newBounds)
		print("shouldInvalidateLayout() -> \(shouldInvalidate)")
		return shouldInvalidate
	}
}


import UIKit

extension UICollectionViewLayout {

	private var numberOfSections: Int {

		guard let collectionView = collectionView else {
			return 1
		}

		return collectionView.numberOfSections
	}

	private func numberOfItems(in section: Int) -> Int {

		guard let collectionView = collectionView else {
			return 0
		}

		return collectionView.numberOfItems(inSection: section)
	}

	var sections: CountableRange<Int> {
		return 0..<numberOfSections
	}

	func items(in section: Int) -> CountableRange<Int> {
		return 0..<numberOfItems(in: section)
	}
}


import UIKit

final class CollectionViewController: UICollectionViewController {}

// MARK: - UICollectionViewDataSource

extension CollectionViewController {

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 100
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
		cell.indexPath = indexPath
		return cell
	}
}


import UIKit

final class CollectionViewController: UICollectionViewController {

	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

		super.viewWillTransition(to: size, with: coordinator)

		guard let collectionView = collectionView else { fatalError() }

		print("viewWillTransition(to size:with coordinator:) START collection view bounds: \(collectionView.bounds))")
		coordinator.animate(alongsideTransition: nil) { _ in
			print("viewWillTransition(to size:with coordinator:) END collection view bounds: \(collectionView.bounds))")
		}
	}
}

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


import Layouts
import UIKit

final class ViewController: UIViewController {

	@IBOutlet weak var collectionView: UICollectionView?

	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

		super.viewWillTransition(to: size, with: coordinator)

		// Calling to invalidate the layout here works.
		//  This is our current workaround to the problem.

//		coordinator.animate(alongsideTransition: { _ in
//
//			self.collectionView?.collectionViewLayout.invalidateLayout()
//
//		}, completion: nil)
	}
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

		return 100
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell

		cell.indexPath = indexPath
		return cell
	}
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

		guard let layout = collectionViewLayout as? Layouts.GridCollectionViewLayout else {
			return .zero
		}

		let width = layout.widthForItem(at: indexPath)
		let height = CGFloat(100)
		return CGSize(width: width, height: height)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 32
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

		switch traitCollection.horizontalSizeClass {
			case .compact: return 16
			case .regular: return 24
			default: return 0
		}
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

		switch traitCollection.horizontalSizeClass {
			case .compact: return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
			case .regular: return UIEdgeInsets(top: 32, left: 32, bottom: 32, right: 32)
			default: return .zero
		}
	}
}

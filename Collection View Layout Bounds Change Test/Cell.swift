
import UIKit

final class Cell: UICollectionViewCell {

    static let reuseIdentifier = "Cell"

	@IBOutlet private var label: UILabel?
	var indexPath: IndexPath = IndexPath(row: 0, section: 0) {
		didSet { label?.text = "\(indexPath.item)" }
	}
}


import UIKit

public final class GridCollectionViewLayout: UICollectionViewFlowLayout {

	private var supplementaryViewCache = Cache<IndexPath, UICollectionViewLayoutAttributes>()
	private var itemCache = Cache<IndexPath, UICollectionViewLayoutAttributes>()

	public override func invalidateLayout() {
		super.invalidateLayout()
		print("invalidateLayout()")
		supplementaryViewCache = Cache()
		itemCache = Cache()
	}

	override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {

		print("shouldInvalidateLayout()")

		guard let collectionView = collectionView else { return false }

		print("-> \(collectionView.frame.size != newBounds.size)")

		// Only automatically invalidate if the collection view changes size.
		return collectionView.frame.size != newBounds.size
	}

	public override var collectionViewContentSize: CGSize {

		guard
			let collectionView = collectionView,
			let lastSection = sections.last,
			let lastItem = items(in: lastSection).last,
			let attributes = layoutAttributesForItem(at: IndexPath(item: lastItem, section: lastSection))
		else {
			return .zero
		}

		let width = collectionView.bounds.size.width
		let height = attributes.frame.maxY + inset(for: lastSection).bottom

		return CGSize(width: width, height: height)
	}

    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

		return sections.flatMap { section -> [UICollectionViewLayoutAttributes] in

			var attributes: [UICollectionViewLayoutAttributes] = items(in: section).compactMap { item in

				let indexPath = IndexPath(item: item, section: section)
				return self.layoutAttributesForItem(at: indexPath)
			}

			if let header = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: IndexPath(item: 0, section: section)) {
				attributes.append(header)
			}

			return attributes
		}
    }

	public override func layoutAttributesForSupplementaryView(ofKind kind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

		return supplementaryViewCache.value(for: indexPath) {

			guard let collectionView = collectionView else {
				return nil
			}

			let size: CGSize
			switch kind {
			case UICollectionElementKindSectionHeader: size = referenceSizeForHeader(in: indexPath.section)
			case UICollectionElementKindSectionFooter: size = referenceSizeForFooter(in: indexPath.section)
			default: return nil
			}

			let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: indexPath)
			attributes.frame.origin.x = 0
			attributes.frame.origin.y = 0
			attributes.frame.size.width = collectionView.bounds.size.width - collectionView.jl_adjustedContentInset.left - collectionView.jl_adjustedContentInset.right
			attributes.frame.size.height = size.height

			return attributes
		}
	}

    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

		return itemCache.value(for: indexPath) {

			guard
				let superAttributes = super.layoutAttributesForItem(at: indexPath),
				let attributes = superAttributes.copy() as? UICollectionViewLayoutAttributes,
				let row = rowForItem(at: attributes.indexPath),
				let items = indexPathsForitems(in: row)
			else {
				return nil
			}

			// HEIGHT

			let heights = items.map { sizeForItem(at: $0).height }

			let maximum = heights.max() ?? 0
			attributes.frame.size.height = ceil(maximum)

			// WIDTH

			let numberOfColumns = self.numberOfColumns

			let section = attributes.indexPath.section
			let sectionInset = inset(for: section)
			let interitemSpacing = minimumInteritemSpacing(for: section)
			let itemWidth = unroundedWidthForItem(at: indexPath)

			attributes.frame.size.width = ceil(itemWidth)

			// X

			let column = CGFloat(attributes.indexPath.item % numberOfColumns)
			let x = sectionInset.left + column * (itemWidth + interitemSpacing)
			attributes.frame.origin.x = floor(x)

			// Y

			// Work out the y position. If there isn't a previous row, then use the section inset top, otherwise
			// Find the maximum y of the previous row and add the line spacing for this section.
			var y = sectionInset.top + referenceSizeForHeader(in: section).height

			if let previousRow = rowPreviousTo(row),
				let previousIndexPaths = indexPathsForitems(in: previousRow),
				let previousIndexPath = previousIndexPaths.first,
				let previousAttributes = layoutAttributesForItem(at: previousIndexPath) {

				y = previousAttributes.frame.maxY + minimumLineSpacing(for: section)
			}


			attributes.frame.origin.y = floor(y)

			return attributes
		}
    }
}

extension GridCollectionViewLayout {

	public func widthForItem(at indexPath: IndexPath) -> CGFloat {
		return ceil(unroundedWidthForItem(at: indexPath))
	}

	private func unroundedWidthForItem(at indexPath: IndexPath) -> CGFloat {

		guard let collectionView = collectionView else {
			return 0
		}

		let numberOfColumns = self.numberOfColumns

		let section = indexPath.section
		let sectionInset = inset(for: section)
		let interitemSpacing = minimumInteritemSpacing(for: section)

		let margins = sectionInset.left + sectionInset.right + CGFloat(numberOfColumns - 1) * interitemSpacing
		let collectionViewWidth = collectionView.bounds.size.width - collectionView.jl_adjustedContentInset.left - collectionView.jl_adjustedContentInset.right
		return (collectionViewWidth - margins) / CGFloat(numberOfColumns)
	}
}

extension UICollectionView {

	// Remove and use adjustedContentInset when iOS 10 is dropped.
	var jl_adjustedContentInset: UIEdgeInsets {

		if #available(iOS 11.0, *) {
			return adjustedContentInset
		} else {
			return contentInset
		}
	}
}


extension GridCollectionViewLayout {
    
    fileprivate struct Row {
        
        fileprivate let section: Int
        fileprivate let value: Int
        init(section: Int, value: Int) {
            self.section = section
            self.value = value
        }
    }
    
    fileprivate var numberOfColumns: Int {

        guard let collectionView = collectionView else {
            return 0
        }
        
        switch collectionView.bounds.size.width {
        case ...899: return 2
        case 900...1299: return 3
        default: return 4
        }
    }

	fileprivate func rowPreviousTo(_ row: Row) -> Row? {

		guard row.value > 0 else {
			return nil
		}

		return Row(section: row.section, value: row.value - 1)
	}

    fileprivate func rowForItem(at indexPath: IndexPath) -> Row? {
        let row = indexPath.item / numberOfColumns
        return Row(section: indexPath.section, value: row)
    }
    
    fileprivate func indexPathsForitems(in row: Row) -> [IndexPath]? {

        guard let maximum = items(in: row.section).last else {
            return nil
        }

        let first = row.value * numberOfColumns
        let potentialLast = first + numberOfColumns - 1
        let last = min(maximum, potentialLast)
        return (first...last).map { IndexPath(item: $0, section: row.section) }
    }
}

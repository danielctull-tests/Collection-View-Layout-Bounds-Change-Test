
import UIKit

extension UICollectionViewFlowLayout {

    typealias DelegateMethod<Key, Value> = ((UICollectionView, UICollectionViewLayout, Key) -> Value)

    private var delegate: UICollectionViewDelegateFlowLayout? {
        return collectionView?.delegate as? UICollectionViewDelegateFlowLayout
    }

    func retrieve<Key, Value>(
        using delegateMethod: DelegateMethod<Key, Value>?,
        key: Key,
        fallback: @autoclosure () -> Value
    ) -> Value {

        guard
            let collectionView = collectionView,
            let value = delegateMethod?(collectionView, self, key)
        else {
            return fallback()
        }

        return value
    }

    public func inset(for section: Int) -> UIEdgeInsets {

        return retrieve(
            using: delegate?.collectionView(_:layout:insetForSectionAt:),
            key: section,
            fallback: sectionInset)
    }

    public func sizeForItem(at indexPath: IndexPath) -> CGSize {

        return retrieve(
            using: delegate?.collectionView(_:layout:sizeForItemAt:),
            key: indexPath,
            fallback: itemSize)
    }

    public func minimumLineSpacing(for section: Int) -> CGFloat {

        return retrieve(
            using: delegate?.collectionView(_:layout:minimumLineSpacingForSectionAt:),
            key: section,
            fallback: minimumLineSpacing)
    }


    public func minimumInteritemSpacing(for section: Int) -> CGFloat {

        return retrieve(
            using: delegate?.collectionView(_:layout:minimumInteritemSpacingForSectionAt:),
            key: section,
            fallback: minimumInteritemSpacing)
    }

    public func referenceSizeForHeader(in section: Int) -> CGSize {

        return retrieve(
            using: delegate?.collectionView(_:layout:referenceSizeForHeaderInSection:),
            key: section,
            fallback: headerReferenceSize)
    }

    public func referenceSizeForFooter(in section: Int) -> CGSize {

        return retrieve(
            using: delegate?.collectionView(_:layout:referenceSizeForFooterInSection:),
            key: section,
            fallback: footerReferenceSize)
    }
}

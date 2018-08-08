
final class Cache<Key, Value> where Key: Hashable {

	// This needs to be a class because it is used in places which are reentrant
	// which causes issues for a value type. That is calling to
	// value(for:valueProvider:) from within a stack called from a value
	// provider closure.

	private var cache: [Key : Value] = [:]

	func value(for key: Key, valueProvider: () -> (Value?)) -> Value? {

		if let value = cache[key] {
			return value
		}

		guard let value = valueProvider() else {
			return nil
		}

		cache[key] = value
		return value
	}
}

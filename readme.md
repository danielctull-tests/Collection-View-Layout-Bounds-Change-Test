
# Collection View Layout Bounds Change Test


This project shows how collection view layout invalidation is different depending on the setup of the view.

There are four examples in this project:

1. Auto Layout to Superview: The collection view as a subview of the view controller's view, with auto layout to the superview
2. Auto Layout to Safe Area: The collection view as a subview of the view controller's view, with auto layout to the safe area
3. UICollectionViewController: A UICollectionViewController subclass
4. Springs and Struts: The collection view as a subview of the view controller's view, with springs and struts to pin to the edge

The following are the output of showing the view controller from the main screen. 

## Steps to reproduce:

* Clear console output
* Tap on one of the exmaples and wait for the view to show
* Rotate to landscape and wait for the transition to end
* Rotate to portrait and wait for the transition to end
* This is where I took a copy of the output
* Press back and clear the console to load a new example.

## Results

This is tested on an iPhone 7 running iOS 11.4.

These show that transitioning to landscape and portrait in each variation change the bounds of the collection view.

In example 1, shouldInvalidateLayout(forBoundsChange:) and invalidateLayout() are never called.

In example 2, shouldInvalidateLayout(forBoundsChange:) and invalidateLayout() are only called between the size transition starting and finishing when rotating from portrait to landscape.

In examples 3 and 4, the layout methods shouldInvalidateLayout(forBoundsChange:) and invalidateLayout() are called between the size transition starting and finishing.


My understanding is that 3 and 4 are the correct behaviour and 1 and 2 are incorrect.



### Auto Layout to Superview

	invalidateLayout()
	invalidateLayout()
	viewWillTransition(to size:with coordinator:) START collection view bounds: (0.0, -64.0, 375.0, 667.0))
	2018-08-20 12:14:00.362287+0100 Collection View Layout Bounds Change Test[24658:135369] [App] if we're in the real pre-commit handler we can't actually add any new fences due to CA restriction
	2018-08-20 12:14:00.362398+0100 Collection View Layout Bounds Change Test[24658:135369] [App] if we're in the real pre-commit handler we can't actually add any new fences due to CA restriction
	viewWillTransition(to size:with coordinator:) END collection view bounds: (0.0, -32.0, 667.0, 375.0))
	viewWillTransition(to size:with coordinator:) START collection view bounds: (0.0, -32.0, 667.0, 375.0))
	2018-08-20 12:14:03.691486+0100 Collection View Layout Bounds Change Test[24658:135369] [App] if we're in the real pre-commit handler we can't actually add any new fences due to CA restriction
	2018-08-20 12:14:03.691635+0100 Collection View Layout Bounds Change Test[24658:135369] [App] if we're in the real pre-commit handler we can't actually add any new fences due to CA restriction
	viewWillTransition(to size:with coordinator:) END collection view bounds: (0.0, -64.0, 375.0, 667.0))



### Auto Layout to Safe Area

	invalidateLayout()
	invalidateLayout()
	viewWillTransition(to size:with coordinator:) START collection view bounds: (0.0, 0.0, 375.0, 603.0))
	shouldInvalidateLayout() -> true
	invalidateLayout()
	2018-08-20 12:14:41.665209+0100 Collection View Layout Bounds Change Test[24658:135369] [App] if we're in the real pre-commit handler we can't actually add any new fences due to CA restriction
	2018-08-20 12:14:41.665309+0100 Collection View Layout Bounds Change Test[24658:135369] [App] if we're in the real pre-commit handler we can't actually add any new fences due to CA restriction
	viewWillTransition(to size:with coordinator:) END collection view bounds: (0.0, 0.0, 667.0, 343.0))
	viewWillTransition(to size:with coordinator:) START collection view bounds: (0.0, 0.0, 667.0, 343.0))
	2018-08-20 12:14:44.335203+0100 Collection View Layout Bounds Change Test[24658:135369] [App] if we're in the real pre-commit handler we can't actually add any new fences due to CA restriction
	2018-08-20 12:14:44.335306+0100 Collection View Layout Bounds Change Test[24658:135369] [App] if we're in the real pre-commit handler we can't actually add any new fences due to CA restriction
	viewWillTransition(to size:with coordinator:) END collection view bounds: (0.0, 0.0, 375.0, 603.0))



### UICollectionViewController

	invalidateLayout()
	invalidateLayout()
	viewWillTransition(to size:with coordinator:) START collection view bounds: (0.0, -64.0, 375.0, 667.0))
	shouldInvalidateLayout() -> true
	invalidateLayout()
	2018-08-20 12:15:17.713269+0100 Collection View Layout Bounds Change Test[24658:135369] [App] if we're in the real pre-commit handler we can't actually add any new fences due to CA restriction
	2018-08-20 12:15:17.713382+0100 Collection View Layout Bounds Change Test[24658:135369] [App] if we're in the real pre-commit handler we can't actually add any new fences due to CA restriction
	viewWillTransition(to size:with coordinator:) END collection view bounds: (0.0, -32.0, 667.0, 375.0))
	viewWillTransition(to size:with coordinator:) START collection view bounds: (0.0, -32.0, 667.0, 375.0))
	shouldInvalidateLayout() -> true
	invalidateLayout()
	2018-08-20 12:15:19.553633+0100 Collection View Layout Bounds Change Test[24658:135369] [App] if we're in the real pre-commit handler we can't actually add any new fences due to CA restriction
	2018-08-20 12:15:19.553741+0100 Collection View Layout Bounds Change Test[24658:135369] [App] if we're in the real pre-commit handler we can't actually add any new fences due to CA restriction
	viewWillTransition(to size:with coordinator:) END collection view bounds: (0.0, -64.0, 375.0, 667.0))



### Springs and Struts

	invalidateLayout()
	invalidateLayout()
	viewWillTransition(to size:with coordinator:) START collection view bounds: (0.0, -64.0, 375.0, 667.0))
	shouldInvalidateLayout() -> true
	invalidateLayout()
	2018-08-20 12:15:41.903963+0100 Collection View Layout Bounds Change Test[24658:135369] [App] if we're in the real pre-commit handler we can't actually add any new fences due to CA restriction
	2018-08-20 12:15:41.904079+0100 Collection View Layout Bounds Change Test[24658:135369] [App] if we're in the real pre-commit handler we can't actually add any new fences due to CA restriction
	viewWillTransition(to size:with coordinator:) END collection view bounds: (0.0, -32.0, 667.0, 375.0))
	viewWillTransition(to size:with coordinator:) START collection view bounds: (0.0, -32.0, 667.0, 375.0))
	shouldInvalidateLayout() -> true
	invalidateLayout()
	2018-08-20 12:15:43.266513+0100 Collection View Layout Bounds Change Test[24658:135369] [App] if we're in the real pre-commit handler we can't actually add any new fences due to CA restriction
	2018-08-20 12:15:43.266623+0100 Collection View Layout Bounds Change Test[24658:135369] [App] if we're in the real pre-commit handler we can't actually add any new fences due to CA restriction
	viewWillTransition(to size:with coordinator:) END collection view bounds: (0.0, -64.0, 375.0, 667.0))

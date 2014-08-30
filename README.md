GranadaLayout
=============

This is an attempt to implement a layout system for iOS that works similar to Android.
The primary goal is just to implement layout views like ``LinearLayout`` and ``RelativeLayout`` but with simplified options.

The current status is: just played around a few hours, initial implementation of ``LinearLayout`` and some test controllers.
Collaborations and suggestions are very welcome.

TODO:
-----
- Add size calculation for all UIKit base views
- Add size calculation for the layouts, so that they can be embedded in other layouts
- Implement the RelativeLayout
- Test, test, test! -> Unit and snapshot tests
- Create a nicer syntax a la [Masonry](https://github.com/Masonry/Masonry)
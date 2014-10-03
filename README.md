GranadaLayout
=============

[![Build Status](http://img.shields.io/travis/gskbyte/GranadaLayout/master.svg?style=flat)](https://travis-ci.org/gskbyte/GranadaLayout)
[![Coverage Status](http://img.shields.io/coveralls/gskbyte/GranadaLayout/master.svg?style=flat)](https://coveralls.io/r/gskbyte/GranadaLayout)


This is an attempt to implement a layout system for iOS that works similar to the one in Android. The primary goal is just to implement layout views like ``LinearLayout`` and ``RelativeLayout`` but with simplified options.

I know that AutoLayout exists, but I think that it doesn't solve the problem with layouting in iOS. It's too complex and slow, and animating by changing constraints is even more complicated.

Current Status
--------------

- ``RelativeLayout`` is implemented but needs lots of testing and love
- ``LinearLayout`` is still not fully implemented
- There are categories to support size measurement for some views from UIKit
- Some test controllers are implemented
- Size caching is implemented
- An experimental LayoutInflater from JSON is beginning has begun to do something

TODO:
-----
- Add size calculation and tests for all UIKit base views where it's needed
    - UITextField
    - UISegmentedControl
    - UIWebView
    - UISearchBar
    - UISlider
    - UIProgressView
    - UIActivityIndicatorView
    - UIStepper
    - UIDatePicker
    - UIPickerView
    - UIScrollView (needed?)
- Test, test, test! -> Unit and snapshot tests
- Create a nicer syntax a la [Masonry](https://github.com/Masonry/Masonry)
- Develop the view inflation system

Thanks + Acknowledments
-----------------------

- To the developers of the Android Projects, for designing such a simple but powerful layout system

Collaborations
--------------

Collaboration, help and suggestions are very welcome :)

Licensing
---------

This project is licensed under the [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0.html), just like the Android Project

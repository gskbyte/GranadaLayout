GranadaLayout
=============

[![Build Status](http://img.shields.io/travis/gskbyte/GranadaLayout/master.svg?style=flat)](https://travis-ci.org/gskbyte/GranadaLayout)
[![Coverage Status](http://img.shields.io/coveralls/gskbyte/GranadaLayout/master.svg?style=flat)](https://coveralls.io/r/gskbyte/GranadaLayout)

**GranadaLayout** is an alternative layout system for iOS, inspired on the Android layout system. It includes **relative** and a **linear** layout systems, that allow positioning views and reacting to size changes automatically without thinking on view frames.

The goal of this project is to be an alternative to Apple's AutoLayout, which I find not very intuitive under some circumstances and has poor performance on older devices. I think this system allows also easier animations and the provided layout inflater allows not to mix interface and logic code.

What can be done
----------------

- Views can be arranged either horizontally or vertically in a GRXLinearLayout, also by defining weights.
- Views can be arranged relative to each other in a GRXRelativeLayout, or relative to their superview.
- Adding support for custom view types is very easy, you just need to override the method grx_measureForWidthSpec:heightSpec:
- A layout inflater is provided, allowing you to define layouts in a declarative way, separated from code (see example below)
- All needed properties for layouting have been implemented on a thin category of UIView, so all UIKit views are supported out-of-the-box
- Layoting is done with a very high performance, only the views that neeed it will me measured and layouting when the superview changes.

Example
-------

// SOON


Current Status
--------------

- ``RelativeLayout`` is fully implemented
- ``LinearLayout`` is fully implemented
- There are view categories to support size measurement for some views from UIKit
- Some test controllers are implemented
- View sizes are cached depending on the measurement specs to increase performance
- There are some unit and snapshot tests

TODO:
-----
- Integration with NUI
- Further testing
- Add more examples

Thanks + Acknowledments
-----------------------

- To the developers of the Android Projects, for designing such a simple but powerful layout system

Collaboration
-------------

Collaboration, help and suggestions are very welcome :)

Licensing
---------

This project is licensed under the [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0.html), just like the Android Project

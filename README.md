GranadaLayout
=============

![CocoaPods Platform](http://img.shields.io/cocoapods/p/XNGMarkdownParser.svg?style=flat)
![CocoaPods License](http://img.shields.io/cocoapods/l/XNGMarkdownParser.svg?style=flat)


**GranadaLayout** is an alternative layout system for iOS, inspired on the Android layout system. It includes **relative** and **linear** layout systems, that allow positioning views and reacting to size changes automatically without thinking on view frames.

The goal of this project is to be an alternative to Apple's AutoLayout, which I find not very intuitive under some circumstances and has poor performance on older devices. I think this system allows also easier animations and the provided layout inflater allows not to mix interface and logic code.

###master [![Build Status](http://img.shields.io/travis/gskbyte/GranadaLayout/master.svg?style=flat)](https://travis-ci.org/gskbyte/GranadaLayout) [![Coverage Status](http://img.shields.io/coveralls/gskbyte/GranadaLayout/master.svg?style=flat)](https://coveralls.io/r/gskbyte/GranadaLayout)

###0.4.0 [![Build Status](http://img.shields.io/travis/gskbyte/GranadaLayout/0.4.0.svg?style=flat)](https://travis-ci.org/gskbyte/GranadaLayout) [![Coverage Status](http://img.shields.io/coveralls/gskbyte/GranadaLayout/0.4.0.svg?style=flat)](https://coveralls.io/r/gskbyte/GranadaLayout) [![Pod](http://img.shields.io/cocoapods/v/GranadaLayout.svg?style=flat)](http://cocoapods.org/?q=GranadaLayout)

What it can do
--------------

- Views can be arranged either horizontally or vertically in a ``GRXLinearLayout``, also by defining weights.
- Views can be arranged relative to each other in a ``GRXRelativeLayout``, or relative to their superview.
- Adding support for custom view types is very easy, you just need to override the method ``grx_measureForWidthSpec:heightSpec:`` in a subclass, or set a ``grx_measureBlock`` to an object.
- A layout inflater is provided, allowing you to separate layout and logic, defining layouts in a declarative way using simple JSON files (see example below)
- All needed properties for layouting have been implemented on a thin category of ``UIView``, so all UIKit views are supported out of the box
- Layouting is done at a very high speed, only the views that neeed it will be measured and layouted when the superview changes.
- Can be used inside ``UITableViewCell``s and ``UICollectionViewCell``s, also to compute cell size
- Compatible with iOS 6 and above
- It can work together with [NUI](https://github.com/tombenner/nui), a styling system similar to CSS

Please check the [changelog](https://github.com/gskbyte/GranadaLayout/blob/master/CHANGELOG.md) and the [license](https://github.com/gskbyte/GranadaLayout/blob/master/LICENSE).

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
- Further testing
- Add more examples
- Add UILabel, UITextView, UIImage subclasses to avoid calling manually ``-grx_setNeedsLayoutInParent``.

Installation
------------

###CocoaPods

GranadaLayout is most easily installed using [CocoaPods](http://www.cocoapods.org). Its pod name is "GranadaLayout".

###Without CocoaPods

Just copy the folder ``Classes`` to your project. Rename it if needed


Example
-------

This repository contains an Example project showcasing how GranadaLayout can be used. Feel free to have a look at the code there.

### Using a layout file

The recommended way to use GranadaLayout is to declare your layout in a layout file (I like to use the ``.grx`` extension):

```javascript
{
  "version" : "0.1",
  
  /** Space reserved for future attributes */
  
  "layout" : {
    "class" : "GRXRelativeLayout", // The root view can be a GRXLayout, but also any other UIView

    "width" : "300",  // This layout will have a width of exactly 300px
    "height" : "wrap_content",  // This layout will be just tall enough to fit its contents

    "debug_bgColor" : "white",  // To ease debug, you can define the background color. Will not be applied in release builds
    "padding" : "12", // Internal padding of the layout. Applies only to GRXLayout subclasses

    "subviews" : [
      {
        "id" : "top", // You can optionally set an identifier so that other views define their position, and to retrieve it from code
        "class" : "GRXRelativeLayout",  // You can embed layouts in other layouts
        "width" : "match_parent",       // Fill the superview width
        "height" : "wrap_content",      // Fit to content

        "subviews" : [
          {
            "id" : "image",
            "class" : "UIImageView",
            "width" : "96",
            "height" : "128",

            "alignParentLeft" : "true", // properties to set alignment with respect to the parent
            "alignParentTop" : "true",

            "marginRight" : "8",  // views can also define a margin
            "visibility" : "visible", // and their visibility, which can be 'visible', 'hidden' or 'gone'

            "debug_bgColor" : "blue"
          },
          {
            "id" : "title",
            "class" : "GRXTextView", // GRXTextView is a subclass of UITextView which is ready to be layouted, without margins and scroll
            "nuiClass" : "title", // If you use NUI, you can set the nuiClass directly to customize this view
            "width" : "match_parent",
            "height" : "wrap_content",
            
            "toRightOf" : "image",  // set position with respect to other view
            "alignParentTop" : "true",

            "debug_bgColor" : "yellow"
          },
          {
            "id" : "subtitle",
            "class" : "UILabel",
            "width" : "match_parent",
            "height" : "wrap_content",
            
            "alignLeft" : "title",
            "below" : "title",
            "marginTop" : "8",

            "debug_bgColor" : "red"
          },
        ]
      },
      {
        "id" : "message",
        "class" : "GRXTextView",
        "width" : "match_parent",
        "height" : "wrap_content",
        
        "below" : "top",
        "marginTop" : "8",

        "debug_bgColor" : "orange"
      },
    ]
  }  
}
```

And then, to use it inside your ``UIViewController`` or custom view, just load it and change the properties you want:

```objective-c
GRXLayoutInflater *inflater = [[GRXLayoutInflater alloc] initWithBundleFile:@"layout.grx"];

self.view = inflater.rootView;
UIImageView *image = [inflater viewWithIdentifier:@"image"];
image.backgroundColor = [UIColor blueColor];
image.contentMode = UIViewContentModeScaleAspectFit;

GRXTextView * title = [self.view grx_viewWithIdentifier:@"title"]; // alternative way to find a view
title.text = @"Title goes here";
title.textColor = [UIColor darkGrayColor];

UILabel * subtitle = [self.view grx_viewWithIdentifier:@"subtitle"];
subtitle.text = @"Subtitle goes here";
```

If you change any property in a view that could affect its size, just call ``-grx_setNeedsLayoutInParent`` to invalidate its measured size and relayout it.

```objective-c
title.text = @"This text is longer and should occupy more lines";
title.numberOfLines = 2;

[title grx_setNeedsLayoutInParent];
```

Animating is also very easy:

```objective-c
image.grx_visibility = GRXVisibilityGone; // will hide the image and expand the text to the left
[image grx_setNeedsLayoutInParent];

[UIView animateWithDuration:0.5 animations:^{
    [self.view layoutIfNeeded];
}];
```

###Just code

// Please check the test controllers to see how it works, but really, it's much better to use layout files!

Thanks + Acknowledments
-----------------------

- To the developers of the Android Project, for designing such a simple but powerful layout system

Collaboration
-------------

Collaboration, help and suggestions are very welcome :)

Licensing
---------

This project is licensed under the [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0.html), just like the Android Project

Some analytics
---------
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/gskbyte/granadalayout/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

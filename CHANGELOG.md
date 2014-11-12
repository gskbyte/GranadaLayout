# 0.2.3: Fix recursive layout inflation
  - Some values were being overriden when loading an inflated layout from within another one
  - Update snapshot tests according to the fixed inflation

# 0.2.2 and 0.2.1: Fix recursive inflation
  - Using now ``bundleName`` and ``bundleIdentifier`` to refer to other bundles (like the ones coming from Pods)

# 0.2.0: Improved layout inflater
  - Fixed size calculation for root layouts
  - Layout inflater can include external files
    ```json
    {
        "id" : "included1",
        "inflate" : "inflate_contained_1.grx",

        "width" : "100",
        "height" : "100",

        "debug_bgColor" : "green",
        "marginBottom" : "10"
      },

      {
        "id" : "included2",
        "inflate" : {
          "filename" : "inflate_contained_2.grx",
          "bundleIdentifier" : "org.gskbyte.GranadaLayout.Tests"
        },

        "width" : "200",
        "height" : "200",
        
        "gravity" : "end",
        "debug_bgColor" : "blue"
      }
  ```
  - Layout inflater can inflate existing views
  
  ```objc
  - (instancetype)initWithData:(NSData *)data
                      rootView:(UIView *)rootView;
  - (instancetype)initWithBundleFile:(NSString *)filename
                            rootView:(UIView *)rootView;
  - (instancetype)initWithFile:(NSString *)filename
                    fromBundle:(NSBundle *)bundle
                      rootView:(UIView *)rootView;
  ```
  - Improved examples
  - Measurement block in ``UIView+GRXLayout`` allow overriding default ``-grx_measureWithWidthSpec:heightSpec:``
  - Added more tests
  
# 0.1.1: minor bugfixes

# 0.1.0: Initial release
  - Added categories to ``UIView`` to implement measuring methods needed by the layout system
  - Added ``GRXRelativeLayout``, that allows positioning views relative to each other and also relative to the superview.
  - Added ``GRXLinearLayout``, that allows stacking views either vertically or horizontally, also defining weights (for proportional sizes).
  - Added initial version of the ``GRXLinearLayoutInflater``, that allows loading layout definition from JSON files.
  - Added lots of tests and some examples

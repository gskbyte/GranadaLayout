# 0.1.0: Initial release
## 0.1.1: minor bugfixes
# 0.2.0: Improved layout inflater
  - Fixed size calculation for root layouts
  - Layout inflater can include external files
    ```json
    {
        "id" : "included1",
        "inflate" : "inflate_contained_1.grx",

        "width" : "100",
        "height" : "100",
        
        "gravity" : "center",

        "debug_bgColor" : "green",
        "marginBottom" : "10"
      },

      {
        "id" : "included2",
        "inflate" : {
          "filename" : "inflate_contained_2.grx",
          "bundle" : "org.gskbyte.GranadaLayout.Tests"
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

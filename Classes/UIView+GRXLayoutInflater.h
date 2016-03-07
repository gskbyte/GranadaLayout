#import <UIKit/UIKit.h>
#import "UIView+GRXLayout.h"
#import "GRXLayoutInflater.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (GRXLayoutInflater)

// Override this method to parse extended options from the layout file
- (void)grx_configureFromDictionary:(NSDictionary *)dictionary;

// This method is called by the layout inflater on the root view defined in a .grx file when it
// has finished parsing the file.
// Override this method to set loaded views into properties,  the original implementation does nothing by default

// TODO ? could use reflection to initialize properties automatically
- (void)grx_didLoadFromInflater:(GRXLayoutInflater *)inflater;

@end

NS_ASSUME_NONNULL_END

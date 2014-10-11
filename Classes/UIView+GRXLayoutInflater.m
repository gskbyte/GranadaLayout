#import "UIView+GRXLayoutInflater.h"
#import "UIView+GRXLayout.h"

@implementation UIView (GRXLayoutInflater)

- (void)grx_configureFromDictionary:(NSDictionary *)dictionary {
    CGSize minSize;
    minSize.width = [dictionary[@"minWidth"] floatValue];
    minSize.height = [dictionary[@"minHeight"] floatValue];
    if (minSize.width > 0 && minSize.height > 0) {
        self.grx_minSize = minSize;
    }

    NSString *visibilityString = dictionary[@"visibility"];
    if ( [visibilityString isEqualToString:@"hidden"] ) {
        self.grx_visibility = GRXViewVisibilityHidden;
    } else if ( [visibilityString isEqualToString:@"gone"] ) {
        self.grx_visibility = GRXViewVisibilityGone;
    }

#ifdef DEBUG
    NSString *bgColorStr = dictionary[@"debug_bgColor"];
    if (bgColorStr == nil) {
        return;
    }

    // Try UIColor selectors
    NSString *colorSelectorName = [bgColorStr stringByAppendingString:@"Color"];
    SEL selector = NSSelectorFromString(colorSelectorName);
    NSAssert([UIColor.class respondsToSelector:selector], @"Unrecognized color selector: %@", colorSelectorName);
    self.backgroundColor = [UIColor performSelector:selector];

    // TODO ? could parse also hex values
#endif
}

@end

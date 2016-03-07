#import "UIView+GRXLayoutInflater.h"

NS_ASSUME_NONNULL_BEGIN

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
        self.grx_visibility = GRXVisibilityHidden;
    } else if ( [visibilityString isEqualToString:@"gone"] ) {
        self.grx_visibility = GRXVisibilityGone;
    } else if ( [visibilityString isEqualToString:@"visible"] ) {
        self.grx_visibility = GRXVisibilityVisible;
    }

    NSString *nuiClass = dictionary[@"nuiClass"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if (nuiClass != nil && [self respondsToSelector:@selector(setNuiClass:)]) {
        [self performSelector:@selector(setNuiClass:)
                   withObject:nuiClass];
    }
#pragma clang diagnostic pop

    if (NO == [GRXLayoutInflater areDebugOptionsEnabled]) {
        return;
    }

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
}

- (void)grx_didLoadFromInflater:(GRXLayoutInflater *)inflater {
}

@end

NS_ASSUME_NONNULL_END

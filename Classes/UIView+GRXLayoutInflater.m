#import "UIView+GRXLayoutInflater.h"
#import "UIColor+GRXHexParse.h"

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
    if (bgColorStr.length) {
        NSString *colorSelectorName = [bgColorStr stringByAppendingString:@"Color"];
        SEL selector = NSSelectorFromString(colorSelectorName);
        if ([[UIColor class] respondsToSelector:selector]) {
            self.backgroundColor = [UIColor performSelector:selector];
        } else {
            self.backgroundColor = [UIColor grx_colorFromRGBHexString:bgColorStr];
        }
    }
}

- (void)grx_didLoadFromInflater:(GRXLayoutInflater *)inflater {
}

@end

NS_ASSUME_NONNULL_END

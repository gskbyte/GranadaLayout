#import "UIView+GRXLayoutInflater.h"

@implementation UIView (GRXLayoutInflater)

- (void)grx_configureFromDictionary:(NSDictionary *)dictionary {
#ifdef DEBUG
    NSString *bgColorStr = dictionary[@"debug_bgColor"];
    if (bgColorStr == nil) {
        return;
    }

    // Try UIColor selectors
    NSString *colorSelectorName = [bgColorStr stringByAppendingString:@"Color"];
    SEL selector = NSSelectorFromString(colorSelectorName);
    if ([UIColor.class respondsToSelector:selector]) {
        self.backgroundColor = [UIColor performSelector:selector];
    } else {
        NSLog(@"Unrecognized color selector: %@", colorSelectorName);
    }

    // could parse also hex values
#endif
}

@end

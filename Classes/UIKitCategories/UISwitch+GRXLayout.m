#import "UISwitch+GRXLayout.h"
#import "UIDevice+Util.h"

@implementation UISwitch (GRXLayout)

- (CGSize) fixedSize {
    if([UIDevice grx_runningSystemVersion7]) {
        return CGSizeMake(51, 31);
    } else {
        return CGSizeMake(79, 27);
    }
}

- (CGSize) grx_suggestedSizeForSizeSpec:(CGSize)sizeSpec {
    return [self fixedSize];
}

- (CGSize)grx_layoutSize {
    return [self fixedSize];
}

@end

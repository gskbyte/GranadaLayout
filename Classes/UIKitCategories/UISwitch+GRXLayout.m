#import "UISwitch+GRXLayout.h"
#import "UIDevice+Util.h"

@implementation UISwitch (GRXLayout)

- (CGSize) grx_minSize {
    if([UIDevice grx_runningSystemVersion7]) {
        return CGSizeMake(51, 31);
    } else {
        return CGSizeMake(79, 27);
    }
}

- (void) grx_setMinSize:(CGSize)grx_minSize {
    // do nothing
}

// UISwitches always have the same size, and -sizeThatFits: returns the currentSize

- (CGSize)grx_measureForWidthSpec:(GRXMeasureSpec)widthSpec
                       heightSpec:(GRXMeasureSpec)heightSpec {
    CGSize size = [self grx_minSize];
    return size;
}

@end

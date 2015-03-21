#import "UISwitch+GRXLayout.h"
#import "UIDevice+Util.h"

@implementation UISwitch (GRXLayout)

- (CGSize)grx_minSize {
    return [self sizeThatFits:CGSizeZero];
}

// UISwitches always have the same size, and -sizeThatFits: returns the currentSize

- (CGSize)grx_measureForWidthSpec:(GRXMeasureSpec)widthSpec
                       heightSpec:(GRXMeasureSpec)heightSpec {
    CGSize size = [self grx_minSize];
    return size;
}

@end

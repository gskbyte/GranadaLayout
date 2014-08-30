#import "UISwitch+GRXLayout.h"
#import "UIDevice+Util.h"

@implementation UISwitch (GRXLayout)

- (CGSize) grx_suggestedMinimumSize {
    if([UIDevice grx_runningSystemVersion7]) {
        return CGSizeMake(51, 31);
    } else {
        return CGSizeMake(79, 27);
    }
}

- (void) grx_measureWithSpec:(GRXMeasureSpec)spec {
    CGSize size = [self grx_suggestedMinimumSize];
    // I don't give a shit about what the layout says. I'M THIS BIG
    [self grx_setMeasuredSize:size];
}

@end

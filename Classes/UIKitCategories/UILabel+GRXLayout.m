#import "UILabel+GRXLayout.h"

@implementation UILabel (GRXLayout)

- (void)grx_measureWithSpec:(GRXMeasureSpec)spec {
    // 1. Get the width for which we will compute size
    CGSize maxTextSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    switch (spec.widthMode) {
        case GRXMeasureSpecExactly:
        case GRXMeasureSpecAtMost:
            maxTextSize.width = spec.width;
            break;
        default:
        case GRXMeasureSpecUnspecified:
            break;
    }

    // 2. Get the height for the given width
    CGSize measuredSize = [self sizeThatFits:maxTextSize];
    switch (spec.heightMode) {
        case GRXMeasureSpecExactly:
            measuredSize.height = spec.height;
            break;
        case GRXMeasureSpecAtMost:
            measuredSize.height = MIN(measuredSize.height, spec.height);
            break;
        case GRXMeasureSpecUnspecified:
        default:
            break;
    }

    // 3. Override computed width if set to exactly
    if(spec.widthMode == GRXMeasureSpecExactly) {
        measuredSize.width = spec.width;
    }

    [self grx_setMeasuredSize:measuredSize];
}

@end

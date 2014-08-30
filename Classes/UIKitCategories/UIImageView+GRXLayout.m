#import "UIImageView+GRXLayout.h"
#import "UIDevice+Util.h"

@implementation UIImageView (GRXLayout)

// we override this method because -sizeThatFits doesn't consider screen and image scales
- (void)grx_measureWithSpec:(GRXMeasureSpec)spec {
    CGFloat scaleMult = self.image.scale / UIDevice.grx_screenScale;
    CGSize measuredSize = CGSizeMake(self.image.size.width*scaleMult,
                                     self.image.size.height*scaleMult);

    if(spec.widthMode == GRXMeasureSpecExactly) {
        measuredSize.width = spec.width;
    }
    if(spec.heightMode == GRXMeasureSpecExactly) {
        measuredSize.height = spec.height;
    }

    [self grx_setMeasuredSize:measuredSize];
}

@end

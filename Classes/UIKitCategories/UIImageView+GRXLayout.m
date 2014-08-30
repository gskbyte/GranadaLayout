#import "UIImageView+GRXLayout.h"
#import "UIDevice+Util.h"

@implementation UIImageView (GRXLayout)

- (CGSize) grx_suggestedSizeForSizeSpec:(CGSize)sizeSpec {
    CGSize size = sizeSpec;
    CGFloat scaleMult = self.image.scale / UIScreen.mainScreen.scale;
    if(sizeSpec.width == GRXWrapContent) {
        size.width = self.image.size.width*scaleMult;
    }

    if(sizeSpec.height == GRXWrapContent) {
        size.height = self.image.size.height*scaleMult;
    }

    return size;
}

- (void)grx_measureWithSpec:(GRXMeasureSpec)spec {
    CGFloat scaleMult = self.image.scale / UIDevice.grx_screenScale;
    CGSize measuredSize = CGSizeMake(self.image.size.width*scaleMult,
                                     self.image.size.height*scaleMult);

    if(spec.widthMode == GRXMeasureSpecExactly) {
        measuredSize.width = spec.width;
    }
    if(spec.widthMode == GRXMeasureSpecExactly) {
        measuredSize.height = spec.height;
    }

    [self grx_setMeasuredSize:measuredSize];
}

@end

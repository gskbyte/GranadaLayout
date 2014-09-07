#import "UIImageView+GRXLayout.h"
#import "UIDevice+Util.h"

@implementation UIImageView (GRXLayout)

// we override this method because -sizeThatFits doesn't consider screen and image scales
- (CGSize)grx_measureForWidthSpec:(GRXMeasureSpec)widthSpec
                       heightSpec:(GRXMeasureSpec)heightSpec {
    CGFloat scaleMult = self.image.scale / UIDevice.grx_screenScale;
    CGSize measuredSize = CGSizeMake(self.image.size.width*scaleMult,
                                     self.image.size.height*scaleMult);

    if(widthSpec.mode == GRXMeasureSpecExactly) {
        measuredSize.width = widthSpec.value;
    }
    if(heightSpec.mode == GRXMeasureSpecExactly) {
        measuredSize.height = heightSpec.value;
    }
    return measuredSize;
}

@end

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

@end

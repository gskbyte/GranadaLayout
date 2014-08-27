#import "UIImageView+GRXLayout.h"

@implementation UIImageView (GRXLayout)

- (CGSize) grx_suggestedSizeForSizeSpec:(CGSize)sizeSpec {
    CGSize size;
    if(sizeSpec.width == GRXMatchParent) {
        size.width = GRXMatchParent;
    } else {
        size.width = sizeSpec.width==GRXWrapContent ? self.image.size.width*self.image.scale : sizeSpec.width;
    }

    if(sizeSpec.height == GRXMatchParent) {
        size.height = GRXMatchParent;
    } else {
        size.height = sizeSpec.height==GRXWrapContent ? self.image.size.height*self.image.scale : sizeSpec.height;
    }

    return size;
}

@end

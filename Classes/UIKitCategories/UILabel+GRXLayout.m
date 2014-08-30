#import "UILabel+GRXLayout.h"

@implementation UILabel (GRXLayout)

- (CGSize) grx_suggestedSizeForSizeSpec:(CGSize)sizeSpec {
    CGSize size = sizeSpec;
    if(sizeSpec.width == GRXWrapContent) {
        size.width = 0;
    }

    if(sizeSpec.height == GRXWrapContent) {
        size.height = 0;
    }

    return size;
}

@end

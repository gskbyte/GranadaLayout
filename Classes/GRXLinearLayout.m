#import "GRXLinearLayout.h"

@implementation GRXLinearLayout

- (instancetype) init {
    return [self initWithDirection:kGRXLinearLayoutDefaultDirection];
}

- (instancetype) initWithDirection:(GRXLinearLayoutDirection)direction {
    self = [super init];
    if(self) {
        self.direction = direction;
        self.weightSum = kGRXLinearLayoutParamsDefaultWeight;
    }
    return self;
}

#define MIN3(a,b,c) MIN(MIN(a,b),c)

- (CGSize) sizeFromViewSpec:(CGSize)vSpec
                    minSize:(CGSize)minSize
                    maxSize:(CGSize)maxSize {
    NSAssert(vSpec.width != GRXWrapContent && vSpec.height != GRXWrapContent,
             @"Wrap content is not a valid measurement value");

    CGSize size = CGSizeZero;
    if(vSpec.width == GRXMatchParent) {
        size.width = MAX(0, maxSize.width);
    } else {
        size.width = MAX(vSpec.width, minSize.width);
    }

    if(vSpec.height == GRXMatchParent) {
        size.height = MAX(0, maxSize.height);
    } else {
        size.height = MAX(vSpec.height, minSize.height);
    }

    return size;
}

- (void) layoutSubviews {
    [super layoutSubviews];

    CGPoint pos = CGPointZero;
    for(NSUInteger i=0; i<self.subviews.count; ++i) {
        UIView * v = self.subviews[i];
        if(v.grx_drawable) {
            CGSize remainingSize = self.frame.size;
            GRXLinearLayoutParams * p = v.grx_linearLayoutParams;
            if(self.direction == GRXLinearLayoutDirectionHorizontal) {
                pos.x += p.margins.left;
                pos.y = MAX(p.margins.top, 0);

                remainingSize.width -= (pos.x + p.margins.left);
                remainingSize.height -= (p.margins.top+p.margins.bottom);
            } else {
                pos.y += p.margins.top;
                pos.x = MAX(p.margins.left, 0);

                remainingSize.width -= (p.margins.left + p.margins.right);
                remainingSize.height -= (pos.y + p.margins.top);
            }

            CGSize vSpec = [v grx_suggestedSizeForSizeSpec:p.size];
            CGSize viewSize = [self sizeFromViewSpec:vSpec
                                             minSize:p.minSize
                                             maxSize:remainingSize];

            CGRect frame = v.frame;
            frame.origin = pos;
            frame.size = viewSize;
            v.frame = frame;

            if(self.direction == GRXLinearLayoutDirectionHorizontal) {
                pos.x += viewSize.width;
                pos.x += p.margins.right;
                remainingSize.width -= p.margins.right;
            } else {
                pos.y += viewSize.height;
                pos.y += p.margins.bottom;
                remainingSize.height -= p.margins.bottom;
            }
        }
    }
}

@end

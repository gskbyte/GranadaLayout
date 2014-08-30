#import "GRXLinearLayout.h"

@implementation GRXLinearLayout

- (instancetype) init {
    return [self initWithDirection:kGRXLinearLayoutDefaultDirection];
}

- (instancetype) initWithDirection:(GRXLinearLayoutDirection)direction {
    self = [super init];
    if(self) {
        _direction = direction;
    }
    return self;
}

- (void)setDirection:(GRXLinearLayoutDirection)direction {
    self.direction = direction;
    [self setNeedsLayout];
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
    size.width = MIN(size.width, maxSize.width);

    if(vSpec.height == GRXMatchParent) {
        size.height = MAX(0, maxSize.height);
    } else {
        size.height = MAX(vSpec.height, minSize.height);
    }
    size.height = MIN(size.height, maxSize.height);

    return size;
}

- (void) layoutSubviews {
    [super layoutSubviews];

    CGPoint pos = CGPointZero;
    for(NSUInteger i=0; i<self.subviews.count; ++i) {
        UIView * v = self.subviews[i];
        if(v.grx_drawable) {
            CGSize remainingSize = self.frame.size;
            GRXLinearLayoutParams * params = v.grx_linearLayoutParams;
            UIEdgeInsets margins = params.margins;

            // 1. calculate remaining size and origin
            remainingSize.width -= (margins.left + margins.right);
            remainingSize.height -= (margins.top + margins.bottom);

            if(self.direction == GRXLinearLayoutDirectionHorizontal) {
                pos.x += margins.left;
                pos.y = MAX(margins.top, 0);

                remainingSize.width -= pos.x;
            } else {
                pos.y += margins.top;
                pos.x = MAX(margins.left, 0);

                remainingSize.height -= pos.y;
            }

            if(remainingSize.width < 0 || remainingSize.height < 0) {
                v.origin = pos;
                v.size = CGSizeZero;
                continue;
            }

            // 2. calculate view size given its layout params and this container's size
            CGSize viewSpec = [v grx_suggestedSizeForSizeSpec:params.size];
            CGSize minViewSpec = [v grx_suggestedSizeForSizeSpec:params.minSize];

            CGSize viewSize = [self sizeFromViewSpec:viewSpec
                                             minSize:minViewSpec
                                             maxSize:remainingSize];

            v.size = viewSize;

            // 3. Position view on layout depending on gravity
            switch (params.gravity) {
                default:
                case GRXLinearLayoutGravityBegin:
                    v.origin = pos;
                    break;

                case GRXLinearLayoutGravityCenter:
                    if(self.direction == GRXLinearLayoutDirectionHorizontal) {
                        v.origin = CGPointMake(pos.x,
                                               params.margins.top + (self.height-viewSize.height)/2);
                    } else {
                        v.origin = CGPointMake(params.margins.left + (self.width-viewSize.width)/2,
                                               pos.y);
                    }
                    break;
                case GRXLinearLayoutGravityEnd:
                    if(self.direction == GRXLinearLayoutDirectionHorizontal) {
                        v.left = pos.x;
                        v.bottom = remainingSize.height;
                    } else {
                        v.right = remainingSize.width;
                        v.top = pos.y;
                    }
                    break;
            }


            // 4. Advance origin for the next view

            if(self.direction == GRXLinearLayoutDirectionHorizontal) {
                pos.x += viewSize.width;
                pos.x += margins.right;
            } else {
                pos.y += viewSize.height;
                pos.y += margins.bottom;
            }
        }
    }
}

@end

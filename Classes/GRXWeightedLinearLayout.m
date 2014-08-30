#import "GRXWeightedLinearLayout.h"

@implementation GRXWeightedLinearLayout

+ (Class) layoutParamsClass {
    return GRXWeightedLinearLayoutParams.class;
}

- (instancetype)initWithDirection:(GRXLinearLayoutDirection)direction{
    return [self initWithDirection:direction
                         weightSum:kGRXWeightedLinearLayoutDefaultWeightSum];
}

- (instancetype)initWithDirection:(GRXLinearLayoutDirection)direction
                        weightSum:(CGFloat)weightSum {
    self = [super initWithDirection:direction];
    if(self) {
        self.weightSum = kGRXWeightedLinearLayoutDefaultWeightSum;
    }
    return self;
}

- (void)setWeightSum:(CGFloat)weightSum {
    NSAssert(weightSum > 0, @"weightSum must be >0");
    _weightSum = weightSum;
    [self setNeedsLayout];
}


// TODO
// - use remainingSize here also
// - try to isolate similar code in other methods
// - detect when the sum of weights is > weightSum and nslog it
- (void) layoutSubviews {
    [super layoutSubviews];

    CGPoint pos = CGPointZero;
    const CGSize totalSize = self.size;
    for(NSUInteger i=0; i<self.subviews.count; ++i) {
        UIView * v = self.subviews[i];
        if(!v.grx_drawable) {
            continue;
        }

        GRXWeightedLinearLayoutParams * params = v.grx_weightedLinearLayoutParams;
        if(params.weight <= 0) {
            continue;
        }

        CGSize maxSizeWithMargins = totalSize;
        CGFloat weightProportion = params.weight / self.weightSum;
        if(self.direction == GRXLinearLayoutDirectionHorizontal) {
            maxSizeWithMargins.width = totalSize.width * weightProportion;
        } else {
            maxSizeWithMargins.height = totalSize.height * weightProportion;
        }

        UIEdgeInsets margins = params.margins;
        CGSize maxSizeWithoutMargins = CGSizeMake(maxSizeWithMargins.width-margins.left-margins.right,
                                                  maxSizeWithMargins.height-margins.top-margins.bottom);

        CGSize viewSpec = [v grx_suggestedSizeForSizeSpec:params.size];
        CGSize minViewSpec = [v grx_suggestedSizeForSizeSpec:params.minSize];

        CGSize viewSize = [self.class sizeFromViewSpec:viewSpec
                                               minSize:minViewSpec
                                               maxSize:maxSizeWithoutMargins];

        // Override view size in the direction of the layout and update position
        if(self.direction == GRXLinearLayoutDirectionHorizontal) {
            viewSize.width = maxSizeWithoutMargins.width;
        } else {
            viewSize.height = maxSizeWithoutMargins.height;
        }

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
                    v.bottom = totalSize.height-margins.bottom;
                } else {
                    v.right = totalSize.width-margins.right;
                    v.top = pos.y;
                }
                break;
        }

        // 4. Advance origin for the next view
        if(self.direction == GRXLinearLayoutDirectionHorizontal) {
            pos.x += viewSize.width + margins.right;
        } else {
            pos.y += viewSize.height + margins.bottom;
        }
    }
}

@end

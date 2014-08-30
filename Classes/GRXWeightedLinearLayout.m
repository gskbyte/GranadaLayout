#import "GRXWeightedLinearLayout.h"

@implementation GRXWeightedLinearLayout

- (instancetype)initWithDirection:(GRXLinearLayoutDirection)direction{
    return [self initWithDirection:direction
                         weightSum:kGRXWeightedLinearLayoutDefaultWeight];
}

- (instancetype)initWithDirection:(GRXLinearLayoutDirection)direction
                        weightSum:(CGFloat)weightSum {
    self = [super initWithDirection:direction];
    if(self) {
        _weightSum = kGRXLinearLayoutParamsDefaultWeight;
    }
    return self;
}

- (void)setWeightSum:(CGFloat)weightSum {
    _weightSum = weightSum;
    [self setNeedsLayout];
}

@end

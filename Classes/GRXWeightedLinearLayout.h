#import "GRXLinearLayout.h"

const static CGFloat kGRXWeightedLinearLayoutDefaultWeight = 1;


@interface GRXWeightedLinearLayout : GRXLinearLayout

@property(nonatomic) CGFloat weightSum;

- (instancetype) initWithDirection:(GRXLinearLayoutDirection)direction
                         weightSum:(CGFloat)weightSum;


@end

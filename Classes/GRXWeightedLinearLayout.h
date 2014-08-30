#import "GRXLinearLayout.h"
#import "GRXWeightedLinearLayoutParams.h"

const static CGFloat kGRXWeightedLinearLayoutDefaultWeightSum = 1;

@interface GRXWeightedLinearLayout : GRXLinearLayout

@property(nonatomic) CGFloat weightSum;

- (instancetype) initWithDirection:(GRXLinearLayoutDirection)direction
                         weightSum:(CGFloat)weightSum;


@end

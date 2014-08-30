#import "GRXLinearLayoutParams.h"

static const CGFloat kGRXWeightedLinearLayoutParamsDefaultWeight = 0;

@interface GRXWeightedLinearLayoutParams : GRXLinearLayoutParams

@property(nonatomic) CGFloat weight;

- (instancetype) initWithSize:(CGSize)size
                       weight:(CGFloat)weight;
- (instancetype) initWithSize:(CGSize)size
                      gravity:(GRXLinearLayoutGravity)gravity
                       weight:(CGFloat)weight;
@end

@interface UIView  (GRXWeightedLinearLayoutParams)

@property (nonatomic, readonly) GRXWeightedLinearLayoutParams * grx_weightedLinearLayoutParams;

@end
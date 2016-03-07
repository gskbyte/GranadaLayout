#import "GRXLayoutParams.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSUInteger, GRXLinearLayoutGravity) {
    GRXLinearLayoutGravityBegin = 0,
    GRXLinearLayoutGravityCenter,
    GRXLinearLayoutGravityEnd
};

static const NSInteger kGRXLinearLayoutParamsDefaultGravity = 0;
static const CGFloat kGRXLinearLayoutParamsDefaultWeight = 0;

@interface GRXLinearLayoutParams : GRXLayoutParams

@property (nonatomic) NSInteger gravity;
@property (nonatomic) CGFloat weight;

@end

@interface UIView (GRXLinearLayoutParams)

@property (nullable, nonatomic, readonly) GRXLinearLayoutParams *grx_linearLayoutParams;

@end

NS_ASSUME_NONNULL_END
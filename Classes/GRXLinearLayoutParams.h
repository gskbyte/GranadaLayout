#import "GRXLayoutParams.h"

static const CGFloat kGRXLinearLayoutParamsDefaultWeight = 0;

typedef NS_ENUM(NSUInteger, GRXLinearLayoutGravity) {
    GRXLinearLayoutGravityBegin = 0,
    GRXLinearLayoutGravityCenter,
    GRXLinearLayoutGravityEnd
};

static const NSInteger kGRXLinearLayoutParamsDefaultGravity = 0;

@interface GRXLinearLayoutParams : GRXLayoutParams

@property(nonatomic) NSInteger gravity;

- (instancetype) initWithSize:(CGSize)size
                      gravity:(GRXLinearLayoutGravity)gravity;

@end

@interface UIView  (GRXLinearLayoutParams)

@property (nonatomic, readonly) GRXLinearLayoutParams * grx_linearLayoutParams;

@end
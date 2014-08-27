#import "GRXLayoutParams.h"

static const CGFloat kGRXLinearLayoutParamsDefaultWeight = 0;

typedef NS_ENUM(NSUInteger, GRXLinearLayoutGravity) {
    GRXLinearLayoutGravityBegin = 0,
    GRXLinearLayoutGravityCenter,
    GRXLinearLayoutGravityEnd
};

static const NSInteger kGRXLinearLayoutParamsDefaultGravity = 0;

@interface GRXLinearLayoutParams : GRXLayoutParams

@property(nonatomic) CGFloat weight;
@property(nonatomic) NSInteger gravity;

- (instancetype) initWithSize:(CGSize)size
                       weight:(NSInteger)weight;
- (instancetype) initWithSize:(CGSize)size
                      gravity:(NSInteger)gravity;
- (instancetype) initWithSize:(CGSize)size
                       weight:(NSInteger)weight
                      gravity:(NSInteger)gravity;


@end

@interface UIView  (GRXLinearLayoutParams)

@property (nonatomic, readonly) GRXLinearLayoutParams * grx_linearLayoutParams;

@end
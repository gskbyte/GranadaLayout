#import "GRXLinearLayoutParams.h"
#import "UIView+GRXLayout.h"

@implementation GRXLinearLayoutParams

- (instancetype) initWithSize:(CGSize)size {
    return [self initWithSize:size
                      gravity:kGRXLinearLayoutParamsDefaultGravity
                       weight:kGRXLinearLayoutParamsDefaultWeight];
}

- (instancetype) initWithSize:(CGSize)size
                      gravity:(GRXLinearLayoutGravity)gravity {
    return [self initWithSize:size
                      gravity:gravity
                       weight:kGRXLinearLayoutParamsDefaultWeight];
}

- (instancetype) initWithSize:(CGSize)size
                       weight:(CGFloat)weight {
    return [self initWithSize:size
                      gravity:kGRXLinearLayoutParamsDefaultGravity
                       weight:weight];
}

- (instancetype) initWithSize:(CGSize)size
                      gravity:(GRXLinearLayoutGravity)gravity
                       weight:(CGFloat)weight {
    self = [super initWithSize:size];
    if(self) {
        _gravity = gravity;
        _weight = weight;
    }
    return self;
}

- (void)setGravity:(NSInteger)gravity {
    _gravity = gravity;
    [self.view setNeedsLayout];
}

- (void)setWeight:(CGFloat)weight {
    _weight = weight;
    [self.view setNeedsLayout];
}

- (id)copyWithZone:(NSZone *)zone {
    GRXLinearLayoutParams * copy = [super copyWithZone:zone];
    copy.gravity = self.gravity;
    copy.weight = self.weight;
    return copy;
}

@end


@implementation UIView  (GRXLinearLayoutParams)

- (GRXLinearLayoutParams *)grx_linearLayoutParams {
    GRXLayoutParams * params = self.grx_layoutParams;
    if([params isKindOfClass:GRXLinearLayoutParams.class]) {
        return (GRXLinearLayoutParams*) params;
    } else {
        NSAssert(NO, @"Not GRXLinearLayoutParams for view %@", self);
        return nil;
    }
}

@end
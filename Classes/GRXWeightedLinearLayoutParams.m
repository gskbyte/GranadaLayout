#import "GRXWeightedLinearLayoutParams.h"
#import "UIView+GRXLayout.h"

@implementation GRXWeightedLinearLayoutParams

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
    self = [super initWithSize:size gravity:gravity];
    if(self) {
        _weight = weight;
    }
    return self;
}

- (void)setWeight:(CGFloat)weight {
    _weight = weight;
    [self.view setNeedsLayout];
}

- (id)copyWithZone:(NSZone *)zone {
    GRXWeightedLinearLayoutParams * copy = [super copyWithZone:zone];
    copy.weight = self.weight;
    return copy;
}

@end

@implementation UIView  (GRXWeightedLinearLayoutParams)

- (GRXWeightedLinearLayoutParams *)grx_weightedLinearLayoutParams {
    GRXLayoutParams * params = self.grx_layoutParams;
    if([params isKindOfClass:GRXWeightedLinearLayoutParams.class]) {
        return (GRXWeightedLinearLayoutParams*) params;
    } else {
        NSAssert(NO, @"Not GRXWeightedLinearLayoutParams for view %@", self);
        return nil;
    }
}

@end


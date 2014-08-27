#import "GRXLinearLayoutParams.h"
#import "UIView+GRXLayout.h"

@implementation GRXLinearLayoutParams

- (instancetype) initWithSize:(CGSize)size {
    return [self initWithSize:size
                       weight:kGRXLinearLayoutParamsDefaultWeight
                      gravity:kGRXLinearLayoutParamsDefaultGravity];
}

- (instancetype) initWithSize:(CGSize)size
                       weight:(NSInteger)weight;{
    return [self initWithSize:size
                       weight:weight
                      gravity:kGRXLinearLayoutParamsDefaultGravity];
}

- (instancetype) initWithSize:(CGSize)size
                      gravity:(NSInteger)gravity {
    return [self initWithSize:size
                       weight:kGRXLinearLayoutParamsDefaultWeight
                      gravity:gravity];
}
- (instancetype) initWithSize:(CGSize)size
                       weight:(NSInteger)weight
                      gravity:(NSInteger)gravity {
    self = [super initWithSize:size];
    if(self) {
        self.weight = weight;
        self.gravity = gravity;
    }
    return self;

}

- (id)copyWithZone:(NSZone *)zone {
    GRXLinearLayoutParams * copy = [super copyWithZone:zone];
    copy.weight = self.weight;
    copy.gravity = self.gravity;
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
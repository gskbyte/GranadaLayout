#import "GRXLinearLayoutParams.h"
#import "UIView+GRXLayout.h"

@implementation GRXLinearLayoutParams

- (instancetype) initWithSize:(CGSize)size {
    return [self initWithSize:size
                      gravity:kGRXLinearLayoutParamsDefaultGravity];
}

- (instancetype) initWithSize:(CGSize)size
                      gravity:(GRXLinearLayoutGravity)gravity {
    self = [super initWithSize:size];
    if(self) {
        _gravity = gravity;
    }
    return self;
}

- (void)setGravity:(NSInteger)gravity {
    _gravity = gravity;
    [self.view setNeedsLayout];
}

- (id)copyWithZone:(NSZone *)zone {
    GRXLinearLayoutParams * copy = [super copyWithZone:zone];
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
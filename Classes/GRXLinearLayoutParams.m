#import "GRXLinearLayoutParams.h"
#import "UIView+GRXLayout.h"

@implementation GRXLinearLayoutParams

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        _gravity = kGRXLinearLayoutParamsDefaultGravity;
        _weight = kGRXLinearLayoutParamsDefaultWeight;
    }
    return self;
}

- (void)setGravity:(NSInteger)gravity {
    _gravity = gravity;
    [self.view grx_setNeedsLayoutInParent];
}

- (void)setWeight:(CGFloat)weight {
    _weight = weight;
    [self.view grx_setNeedsLayoutInParent];
}

- (id)copyWithZone:(NSZone *)zone {
    GRXLinearLayoutParams *copy = [super copyWithZone:zone];
    copy.gravity = self.gravity;
    copy.weight = self.weight;
    return copy;
}

@end


@implementation UIView (GRXLinearLayoutParams)

- (GRXLinearLayoutParams *)grx_linearLayoutParams {
    GRXLayoutParams *params = self.grx_layoutParams;
    if ([params isKindOfClass:GRXLinearLayoutParams.class]) {
        return (GRXLinearLayoutParams *)params;
    } else {
        NSAssert(NO, @"Not GRXLinearLayoutParams for view %@", self);
        return nil;
    }
}

@end
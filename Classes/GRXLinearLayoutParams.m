#import "GRXLinearLayoutParams.h"
#import "UIView+GRXLayout.h"

@implementation GRXLinearLayoutParams

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        [self setupDefaultGravityAndWeight];
    }
    return self;
}

- (instancetype)initWithLayoutParams:(GRXLayoutParams*)layoutParams {
    self = [super initWithLayoutParams:layoutParams];
    if(self) {
        [self setupDefaultGravityAndWeight];

        if([layoutParams isKindOfClass:GRXLinearLayoutParams.class]) {
            GRXLinearLayoutParams *linParams = (GRXLinearLayoutParams*)layoutParams;
            _gravity = linParams.gravity;
            _weight = linParams.weight;
        }
    }
    return self;
}

- (void) setupDefaultGravityAndWeight {
    _gravity = kGRXLinearLayoutParamsDefaultGravity;
    _weight = kGRXLinearLayoutParamsDefaultWeight;
}

- (void)setGravity:(NSInteger)gravity {
    _gravity = gravity;
    [self.view grx_setNeedsLayoutInParent];
}

- (void)setWeight:(CGFloat)weight {
    _weight = weight;
    [self.view grx_setNeedsLayoutInParent];
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
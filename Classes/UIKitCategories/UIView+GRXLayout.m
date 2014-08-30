#import "UIView+GRXLayout.h"
#import "GRXLayoutParams_Protected.h"
#import <objc/runtime.h>
#import "GRXLayout.h"

const static char * GRXLayoutParamsKey = "grx_layoutParams";
const static char * GRXDrawableKey = "grx_drawable";

@implementation UIView (GRXLayout)

#pragma mark - setup methods

- (instancetype) initWithLayoutParams:(GRXLayoutParams*)layoutParams {
    self = [self initWithFrame:CGRectZero];
    if(self) {
        self.grx_layoutParams = layoutParams;
    }
    return self;
}

- (instancetype) initWithDefaultParamsInLayout:(GRXLayout*)layout {
    GRXLayoutParams * params = [[[layout.class layoutParamsClass] alloc] init];
    self = [self initWithLayoutParams:params];
    if(self) {
        [layout addSubview:self];
    }
    return self;
}

#pragma mark - layout methods

- (GRXLayoutParams *)grx_layoutParams {
    return objc_getAssociatedObject(self, GRXLayoutParamsKey);
}

- (void)grx_setLayoutParams:(GRXLayoutParams *)layoutParams {
    GRXLayoutParams * copy = layoutParams.copy;
    [copy setView:self];
    objc_setAssociatedObject(self, GRXLayoutParamsKey, copy,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize)grx_layoutSize {
    GRXLayoutParams * params = self.grx_layoutParams;
    if(params == nil) {
        return self.frame.size;
    } else {
        return params.size;
    }
}

- (BOOL)grx_drawable {
    NSNumber * n = objc_getAssociatedObject(self, GRXDrawableKey);
    if(n != nil) {
        return n.boolValue;
    } else {
        return YES; // drawable by default
    }
}

- (void)grx_setDrawable:(BOOL)grx_drawable {
    objc_setAssociatedObject(self, GRXLayoutParamsKey, @(grx_drawable),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

- (GRXViewVisibility)grx_visibility {
    if(self.grx_drawable) {
        if(self.hidden) {
            return GRXViewVisibilityHidden;
        } else {
            return GRXViewVisibilityVisible;
        }
    } else {
        return GRXViewVisibilityGone;
    }
}

- (void)grx_setVisibility:(GRXViewVisibility)grx_visibility {
    switch (grx_visibility) {
        case GRXViewVisibilityHidden:
            self.hidden = YES;
            self.grx_drawable = NO;
            break;
        case GRXViewVisibilityGone:
            self.hidden = NO;
            self.grx_drawable = NO;
            break;

        case GRXViewVisibilityVisible:
        default:
            self.hidden = NO;
            self.grx_drawable = YES;
            break;
    }
}

- (CGSize) grx_suggestedSizeForSizeSpec:(CGSize)sizeSpec {
    CGSize size = sizeSpec;
    if(sizeSpec.width == GRXWrapContent) {
        size.width = 0;
    }

    if(sizeSpec.height == GRXWrapContent) {
        size.height = 0;
    }

    return size;
}

@end

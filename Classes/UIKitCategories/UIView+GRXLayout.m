#import "UIView+GRXLayout.h"
#import "GRXLayoutParams_Protected.h"
#import <objc/runtime.h>
#import "GRXLayout.h"

const static char * GRXLayoutParamsKey = "grx_layoutParams";
const static char * GRXDrawableKey = "grx_drawable";

@implementation UIView (GRXLayout)

- (GRXLayoutParams *)grx_layoutParams {
    return objc_getAssociatedObject(self, GRXLayoutParamsKey);
}

- (void)grx_setLayoutParams:(GRXLayoutParams *)layoutParams {
    GRXLayoutParams * copy = layoutParams.copy;
    [copy setView:self];
    objc_setAssociatedObject(self, GRXLayoutParamsKey, copy,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize)grx_sizeSpec {
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
    CGSize size;
    if(sizeSpec.width == GRXMatchParent) {
        size.width = GRXMatchParent;
    } else {
        size.width = sizeSpec.width==GRXWrapContent ? 0 : sizeSpec.width;
    }

    if(sizeSpec.height == GRXMatchParent) {
        size.height = GRXMatchParent;
    } else {
        size.height = sizeSpec.height==GRXWrapContent ? 0 : sizeSpec.height;
    }

    return size;
}

@end

#import "UIView+GRXLayout.h"
#import "GRXLayoutParams_Protected.h"
#import <objc/runtime.h>
#import "GRXLayout.h"

const static char GRXLayoutParamsKey;
const static char GRXDrawableKey;
const static char GRXMeasuredSizeKey;
const static char GRXLayoutIDKey;

static NSUInteger GRXStaticCurrentLayoutID = 0;

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
    return objc_getAssociatedObject(self, &GRXLayoutParamsKey);
}

- (void)grx_setLayoutParams:(GRXLayoutParams *)layoutParams {
    GRXLayoutParams * copy = layoutParams.copy;
    [copy setView:self];
    objc_setAssociatedObject(self, &GRXLayoutParamsKey, copy,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)grx_drawable {
    NSNumber * n = objc_getAssociatedObject(self, &GRXDrawableKey);
    if(n != nil) {
        return n.boolValue;
    } else {
        return YES; // drawable by default
    }
}

- (void)grx_setDrawable:(BOOL)grx_drawable {
    objc_setAssociatedObject(self, &GRXLayoutParamsKey, @(grx_drawable),
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

- (CGSize)grx_measuredSize {
    NSValue * value = objc_getAssociatedObject(self, &GRXMeasuredSizeKey);
    if(value != nil) {
        CGSize size;
        [value getValue:&size];
        return size;
    } else {
        return CGSizeZero;
    }
}

- (void) grx_setMeasuredSize:(CGSize)size {
    NSValue *value = [NSValue value:&size withObjCType:@encode(CGSize)];
    objc_setAssociatedObject(self, &GRXMeasuredSizeKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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

- (CGSize) grx_suggestedMinimumSize {
    GRXLayoutParams * params = self.grx_layoutParams;
    if(params == nil) {
        return CGSizeZero;
    } else {
        return params.minSize;
    }
}

// measurement is done within this method. Subclasses must call grx_setMeasuredSize at the end
// and can not call super

// different implementation for UIView because it -sizeThatFits: returns the current size
- (void) grx_measureWithSpec:(GRXMeasureSpec)spec {
    CGSize measuredSize;
    if([self isMemberOfClass:UIView.class]) {
        CGSize minSize = self.grx_suggestedMinimumSize;
        CGFloat w = GRXDefaultSizeValueForSpec(minSize.width, spec.width, spec.widthMode);
        CGFloat h = GRXDefaultSizeValueForSpec(minSize.height, spec.height, spec.heightMode);
        measuredSize = CGSizeMake(w, h);
    } else {
        measuredSize = [self grx_measureFittingMeasureSpec:spec];
    }

    [self grx_setMeasuredSize:measuredSize];
}

- (CGSize)grx_measureFittingMeasureSpec:(GRXMeasureSpec)spec {
    // 1. Get the maximum width for which we will compute size
    CGSize maxTextSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    switch (spec.widthMode) {
        case GRXMeasureSpecExactly:
        case GRXMeasureSpecAtMost:
            maxTextSize.width = spec.width;
            break;
        default:
        case GRXMeasureSpecUnspecified:
            break;
    }

    // 2. Get the size for the given width
    self.size = CGSizeZero;
    CGSize measuredSize = [self sizeThatFits:maxTextSize];
    switch (spec.heightMode) {
        case GRXMeasureSpecExactly:
            measuredSize.height = spec.height;
            break;
        case GRXMeasureSpecAtMost:
            measuredSize.height = MIN(measuredSize.height, spec.height);
            break;
        case GRXMeasureSpecUnspecified:
        default:
            measuredSize.height = MAX(measuredSize.height, spec.height);
            break;
    }

    // 3. Override computed width if set to exactly or unspecified
    if(spec.widthMode == GRXMeasureSpecExactly) {
        measuredSize.width = spec.width;
    } else if(spec.widthMode == GRXMeasureSpecUnspecified) {
        measuredSize.width = MAX(measuredSize.width, spec.width);
    }

    return measuredSize;
}

- (NSNumber*)grx_layoutId { // initialized only if used, for example, by the relative layout
    NSNumber * layoutIdNumber = objc_getAssociatedObject(self, &GRXLayoutIDKey);
    if(layoutIdNumber == nil) {
        NSUInteger layoutId = (++GRXStaticCurrentLayoutID);
        layoutIdNumber = [NSNumber numberWithUnsignedInteger:layoutId];
        objc_setAssociatedObject(self, &GRXLayoutIDKey, layoutIdNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return layoutIdNumber;
}

- (void) grx_setNeedsLayout {
    [self grx_setNeedsLayout];
    if([self.superview isKindOfClass:GRXLayout.class]) {
        [self.superview setNeedsLayout];
    }
}

@end

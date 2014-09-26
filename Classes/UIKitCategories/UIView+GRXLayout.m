#import "UIView+GRXLayout.h"
#import "GRXLayoutParams_Protected.h"
#import <objc/runtime.h>
#import "GRXLayout.h"

const static char GRXLayoutParamsKey;
const static char GRXLayoutableKey;
const static char GRXMeasuredSizeKey;
const static char GRXMeasuredSizeSpecKey;
const static char GRXLayoutIDKey;

static NSUInteger GRXStaticCurrentLayoutID = 0;

@interface UIView (GRXLayout_Private)

@property (nonatomic, setter = grx_setLayoutable:) BOOL grx_isLayoutable;

@end

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
    [self grx_setNeedsLayoutInParent];
}

- (BOOL)grx_isLayoutable {
    NSNumber * n = objc_getAssociatedObject(self, &GRXLayoutableKey);
    if(n != nil) {
        return n.boolValue;
    } else {
        return YES; // drawable by default
    }
}

- (void)grx_setLayoutable:(BOOL)layoutable {
    objc_setAssociatedObject(self, &GRXLayoutParamsKey, @(layoutable),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

- (GRXViewVisibility)grx_visibility {
    if(self.grx_isLayoutable) {
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
            self.grx_isLayoutable = YES;
            break;
        case GRXViewVisibilityGone:
            self.hidden = YES;
            self.grx_isLayoutable = NO;
            break;
        case GRXViewVisibilityVisible:
        default:
            self.hidden = NO;
            self.grx_isLayoutable = YES;
            break;
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

- (CGSize) grx_suggestedMinimumSize {
    GRXLayoutParams * params = self.grx_layoutParams;
    if(params == nil) {
        return CGSizeZero;
    } else {
        return params.minSize;
    }
}

#pragma mark - measurement methods

- (CGSize) grx_measuredSizeForWidthSpec:(GRXMeasureSpec)widthSpec
                             heightSpec:(GRXMeasureSpec)heightSpec {
    NSValue * measuredSpecValue = objc_getAssociatedObject(self, &GRXMeasuredSizeSpecKey);
    GRXFullMeasureSpec fullMeasuredSpec;
    [measuredSpecValue getValue:&fullMeasuredSpec];

    if(GRXMeasureSpecsEqual(widthSpec, fullMeasuredSpec.width) &&
       GRXMeasureSpecsEqual(heightSpec, fullMeasuredSpec.height)) {
        return [self grx_measuredSize];
    } else {
        CGSize measuredSize = [self grx_measureForWidthSpec:widthSpec
                                                 heightSpec:heightSpec];
        [self grx_setMeasuredSize:measuredSize
                     forWidthSpec:widthSpec
                       heightSpec:heightSpec];
        return measuredSize;
    }
}

- (void) grx_invalidateMeasuredSize {
    objc_setAssociatedObject(self, &GRXMeasuredSizeSpecKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void) grx_setMeasuredSize:(CGSize)measuredSize
                forWidthSpec:(GRXMeasureSpec)widthSpec
                  heightSpec:(GRXMeasureSpec)heightSpec {
    NSValue *sizeValue = [NSValue value:&measuredSize withObjCType:@encode(CGSize)];
    objc_setAssociatedObject(self, &GRXMeasuredSizeKey, sizeValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    GRXFullMeasureSpec spec = GRXFullMeasureSpecMake(widthSpec, heightSpec);
    NSValue *specValue = [NSValue value:&spec withObjCType:@encode(GRXFullMeasureSpec)];
    objc_setAssociatedObject(self, &GRXMeasuredSizeSpecKey, specValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// measurement is done within this method. Subclasses must not call super

// different implementation for UIView because it -sizeThatFits: returns the current size
// subviews won't usually want to call super
- (CGSize) grx_measureForWidthSpec:(GRXMeasureSpec)widthSpec
                        heightSpec:(GRXMeasureSpec)heightSpec {
    CGSize measuredSize;
    if([self isMemberOfClass:UIView.class]) {
        CGSize minSize = self.grx_suggestedMinimumSize;
        CGFloat w = GRXMeasureSpecResolveSizeValue(minSize.width, widthSpec);
        CGFloat h = GRXMeasureSpecResolveSizeValue(minSize.height, heightSpec);
        measuredSize = CGSizeMake(w, h);
    } else {
        measuredSize = [self grx_measureFittingWidthMeasureSpec:widthSpec
                                              heightMeasureSpec:heightSpec];
    }
    return measuredSize;
}

- (CGSize)grx_measureFittingWidthMeasureSpec:(GRXMeasureSpec)widthSpec
                           heightMeasureSpec:(GRXMeasureSpec)heightSpec {
    // 1. Get the maximum width for which we will compute size
    CGSize maxTextSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    switch (widthSpec.mode) {
        case GRXMeasureSpecExactly:
        case GRXMeasureSpecAtMost:
            maxTextSize.width = widthSpec.value;
            break;
        default:
        case GRXMeasureSpecUnspecified:
            break;
    }

    // 2. Get the size for the given width
    self.size = CGSizeZero;
    CGSize measuredSize = [self sizeThatFits:maxTextSize];
    switch (heightSpec.mode) {
        case GRXMeasureSpecExactly:
            measuredSize.height = heightSpec.value;
            break;
        case GRXMeasureSpecAtMost:
            measuredSize.height = MIN(measuredSize.height, heightSpec.value);
            break;
        case GRXMeasureSpecUnspecified:
        default:
            measuredSize.height = MAX(measuredSize.height, heightSpec.value);
            break;
    }

    // 3. Override computed width if set to exactly or unspecified
    if(widthSpec.mode == GRXMeasureSpecExactly) {
        measuredSize.width = widthSpec.value;
    } else if(widthSpec.value == GRXMeasureSpecUnspecified) {
        measuredSize.width = MAX(measuredSize.width, widthSpec.value);
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

- (void) grx_setNeedsLayoutInParent {
    [self grx_invalidateMeasuredSize];
    if([self.superview isKindOfClass:GRXLayout.class]) {
        [self.superview grx_setNeedsLayoutInParent];
    } else {
        [self setNeedsLayout];
    }
}

@end

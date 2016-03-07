#import "UIView+GRXLayout.h"
#import "GRXLayoutParams_Protected.h"
#import <objc/runtime.h>
#import "GRXLayout.h"

NS_ASSUME_NONNULL_BEGIN

const static char GRXLayoutParamsKey;
const static char GRXLayoutableKey;
const static char GRXMeasuredSizeKey;
const static char GRXMeasuredSizeSpecKey;
const static char GRXMinSizeKey;
const static char GRXMeasurementBlockKey;
const static char GRXLayoutIDKey;
const static char GRXIdentifierKey;

static NSUInteger GRXStaticCurrentLayoutID = 0;

@interface UIView (GRXLayout_Private)

@property (nonatomic, setter = grx_setLayoutable :) BOOL grx_isLayoutable;

@end

@implementation UIView (GRXLayout)

#pragma mark - setup methods

- (instancetype)initWithLayoutParams:(GRXLayoutParams *)layoutParams {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.grx_layoutParams = layoutParams;
    }
    return self;
}

- (instancetype)initWithDefaultParamsInLayout:(GRXLayout *)layout {
    GRXLayoutParams *params = [[[layout.class layoutParamsClass] alloc] init];
    self = [self initWithLayoutParams:params];
    if (self) {
        [layout addSubview:self];
    }
    return self;
}

#pragma mark - layout methods

- (CGSize)grx_minSize {
    NSValue *value = objc_getAssociatedObject(self, &GRXMinSizeKey);
    if (value != nil) {
        CGSize size;
        [value getValue:&size];
        return size;
    } else {
        return CGSizeZero;
    }
}

- (void)grx_setMinSize:(CGSize)minSize {
    NSValue *sizeValue = [NSValue value:&minSize withObjCType:@encode(CGSize)];
    objc_setAssociatedObject(self, &GRXMinSizeKey, sizeValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (nullable GRXLayoutParams *)grx_layoutParams {
    return objc_getAssociatedObject(self, &GRXLayoutParamsKey);
}

- (void)grx_setLayoutParams:(nullable GRXLayoutParams *)layoutParams {
    if (layoutParams.view != nil) {
        layoutParams = layoutParams.copy;
    }
    objc_setAssociatedObject(self, &GRXLayoutParamsKey, layoutParams,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [layoutParams setView:self];
    [self grx_setNeedsLayoutInParent];
}

- (BOOL)grx_isLayoutable {
    NSNumber *n = objc_getAssociatedObject(self, &GRXLayoutableKey);
    if (n != nil) {
        return n.boolValue;
    } else {
        return YES; // layoutable by default
    }
}

- (void)grx_setLayoutable:(BOOL)layoutable {
    NSNumber *n = @(layoutable);
    objc_setAssociatedObject(self, &GRXLayoutableKey, n,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (GRXVisibility)grx_visibility {
    if (self.grx_isLayoutable) {
        if (self.hidden) {
            return GRXVisibilityHidden;
        } else {
            return GRXVisibilityVisible;
        }
    } else {
        return GRXVisibilityGone;
    }
}

- (void)grx_setVisibility:(GRXVisibility)grx_visibility {
    switch (grx_visibility) {
        case GRXVisibilityHidden:
            self.hidden = YES;
            self.grx_isLayoutable = YES;
            break;
        case GRXVisibilityGone:
            self.hidden = YES;
            self.grx_isLayoutable = NO;
            break;
        case GRXVisibilityVisible:
        default:
            self.hidden = NO;
            self.grx_isLayoutable = YES;
            break;
    }
}

- (CGSize)grx_measuredSize {
    NSValue *value = objc_getAssociatedObject(self, &GRXMeasuredSizeKey);
    if (value != nil) {
        CGSize size;
        [value getValue:&size];
        return size;
    } else {
        return CGSizeZero;
    }
}

- (nullable CGSize (^)(GRXMeasureSpec, GRXMeasureSpec))grx_measurementBlock {
    return objc_getAssociatedObject(self, &GRXMeasurementBlockKey);
}

- (void)grx_setMeasurementBlock:(nullable CGSize (^)(GRXMeasureSpec, GRXMeasureSpec))grx_measurementBlock {
    objc_setAssociatedObject(self, &GRXMeasurementBlockKey, grx_measurementBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self grx_invalidateMeasuredSize];
}

#pragma mark - measurement methods

- (CGSize)grx_measuredSizeForWidthSpec:(GRXMeasureSpec)widthSpec
                            heightSpec:(GRXMeasureSpec)heightSpec {
    NSValue *measuredSpecValue = objc_getAssociatedObject(self, &GRXMeasuredSizeSpecKey);

    if (measuredSpecValue != nil) {
        GRXFullMeasureSpec fullMeasuredSpec;
        [measuredSpecValue getValue:&fullMeasuredSpec];
        if (GRXMeasureSpecsEqual(widthSpec, fullMeasuredSpec.width) &&
            GRXMeasureSpecsEqual(heightSpec, fullMeasuredSpec.height)) {
            return [self grx_measuredSize];
        }
    }

    CGSize measuredSize = CGSizeZero;
    if (self.grx_measurementBlock != nil) {
        measuredSize = self.grx_measurementBlock(widthSpec, heightSpec);
    } else {
        measuredSize = [self grx_measureForWidthSpec:widthSpec
                                          heightSpec:heightSpec];
    }

    [self grx_setMeasuredSize:measuredSize
                 forWidthSpec:widthSpec
                   heightSpec:heightSpec];
    return measuredSize;
}

- (void)grx_invalidateMeasuredSize {
    objc_setAssociatedObject(self, &GRXMeasuredSizeSpecKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)grx_setMeasuredSize:(CGSize)measuredSize
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
- (CGSize)grx_measureForWidthSpec:(GRXMeasureSpec)widthSpec
                       heightSpec:(GRXMeasureSpec)heightSpec {
    CGSize size;
    if ([self isMemberOfClass:UIView.class]) {
        CGSize minSize = self.grx_minSize;
        CGFloat w = GRXMeasureSpecResolveSizeValue(minSize.width, widthSpec);
        CGFloat h = GRXMeasureSpecResolveSizeValue(minSize.height, heightSpec);
        size = CGSizeMake(w, h);
    } else {
        size = [self grx_measureFittingWidthMeasureSpec:widthSpec
                                      heightMeasureSpec:heightSpec];
    }
    return size;
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
    //self.size = CGSizeZero; // needed for UILabels and UITextViews?
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
    if (widthSpec.mode == GRXMeasureSpecExactly) {
        measuredSize.width = widthSpec.value;
    } else if (widthSpec.value == GRXMeasureSpecUnspecified) {
        measuredSize.width = MAX(measuredSize.width, widthSpec.value);
    }

    return measuredSize;
}

- (NSNumber *)grx_layoutId { // initialized only if used, for example, by the relative layout
    NSNumber *layoutIdNumber = objc_getAssociatedObject(self, &GRXLayoutIDKey);
    if (layoutIdNumber == nil) {
        NSUInteger layoutId = (++GRXStaticCurrentLayoutID);
        layoutIdNumber = [NSNumber numberWithUnsignedInteger:layoutId];
        objc_setAssociatedObject(self, &GRXLayoutIDKey, layoutIdNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return layoutIdNumber;
}

- (void)grx_setNeedsLayoutInParent {
    [self grx_invalidateMeasuredSize];
    if ([self.superview isKindOfClass:GRXLayout.class]) {
        [self.superview grx_setNeedsLayoutInParent];
    } else {
        [self setNeedsLayout];
    }
}

#pragma mark - identifiers

- (nullable NSString *)grx_identifier {
    return objc_getAssociatedObject(self, &GRXIdentifierKey);
}

- (void)grx_setIdentifier:(nullable NSString *)identifier {
    objc_setAssociatedObject(self, &GRXIdentifierKey, identifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (nullable __kindof UIView *)grx_subviewForIdentifier:(NSString *)identifier {
    for (UIView *subview in self.subviews) {
        if ([subview.grx_identifier isEqualToString:identifier]) {
            return subview;
        }
    }
    return nil;
}

- (nullable __kindof UIView *)grx_findViewWithIdentifier:(NSString *)identifier {
    for (UIView *subview in self.subviews) {
        if ([subview.grx_identifier isEqualToString:identifier]) {
            return subview;
        }
        UIView *subSubView = [subview grx_findViewWithIdentifier:identifier];
        if (subSubView != nil) {
            return subSubView;
        }
    }
    return nil;
}

#pragma mark - debug

- (NSString *)grx_debugDescription {
    return [self descriptionWithIndentationLevel:0];
}

- (NSString *)descriptionWithIndentationLevel:(NSUInteger)level {
    NSMutableString *spaces = [NSMutableString stringWithCapacity:level * 2];
    for (NSUInteger i = 0; i < level; ++i) {
        [spaces appendString:@"  "];
    }

    NSMutableString *subviews = [NSMutableString string];
    if ([self isKindOfClass:GRXLayout.class]) {
        for (UIView *v in self.subviews) {
            [subviews appendString:[v descriptionWithIndentationLevel:level + 1]];
        }
    }

    return [NSString stringWithFormat:@"%@"
            "%@%@ '%@'\n"
            "%@(%.2f, %.2f, %.2f, %.2f) (%.2f, %.2f)\n"
            "%@%@\n"
            "%@",
            (level == 0 ? @"\n" : @""),
            spaces, NSStringFromClass(self.class), self.grx_identifier,
            spaces, self.left, self.top, self.width, self.height, self.grx_measuredSize.width, self.grx_measuredSize.height,
            spaces, self.grx_layoutParams.debugDescription,
            subviews
    ];
}

@end

NS_ASSUME_NONNULL_END

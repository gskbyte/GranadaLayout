#import "GRXLinearLayout.h"
#import "GRXLayout+Protected.h"
#import "UIView+Frame.h"

@interface GRXLinearLayout ()

@property (nonatomic) CGFloat totalLength;

@end

@implementation GRXLinearLayout

+ (Class)layoutParamsClass {
    return GRXLinearLayoutParams.class;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.direction = kGRXLinearLayoutDefaultDirection;
        self.weightSum = kGRXLinearLayoutDefaultWeightSum;
    }
    return self;
}

- (void)setDirection:(GRXLinearLayoutDirection)direction {
    _direction = direction;
    [self grx_setNeedsLayoutInParent];
}

- (void)setWeightSum:(CGFloat)weightSum {
    NSAssert(weightSum >= 0, @"weightSum must be >=0");
    _weightSum = weightSum;
    [self grx_setNeedsLayoutInParent];
}

- (CGSize)grx_measureForWidthSpec:(GRXMeasureSpec)widthSpec
                       heightSpec:(GRXMeasureSpec)heightSpec {
    if (self.direction == GRXLinearLayoutDirectionVertical) {
        return [self grx_measureVerticalForWidthSpec:widthSpec
                                          heightSpec:heightSpec];
    } else {
        return [self grx_measureHorizontalForWidthSpec:widthSpec
                                            heightSpec:heightSpec];
    }
}

- (CGSize)grx_measureVerticalForWidthSpec:(GRXMeasureSpec)widthSpec
                               heightSpec:(GRXMeasureSpec)heightSpec {
    self.totalLength = 0;
    CGFloat maxWidth = 0;
    CGFloat alternativeMaxWidth = 0;
    CGFloat weightedMaxWidth = 0;
    BOOL allFillParent = YES;
    float totalWeight = 0;

    BOOL matchWidth = NO;

    // See how tall everyone is. Also remember max width.
    for (UIView *subview in self.subviews) {
        if (subview.grx_visibility == GRXVisibilityGone) {
            continue;
        }

        GRXLinearLayoutParams *lp = subview.grx_linearLayoutParams;
        totalWeight += lp.weight;

        if (heightSpec.mode == GRXMeasureSpecExactly && lp.height == 0 && lp.weight > 0) {
            // Optimization: don't bother measuring subviews who are going to use
            // leftover space. These views will get measured again down below if
            // there is any leftover space.
            self.totalLength += lp.margins.top + lp.margins.bottom;
        } else {
            CGFloat oldHeight = -CGFLOAT_MAX;

            if (lp.height == 0 && lp.weight > 0) {
                // heightMode is either UNSPECIFIED OR AT_MOST, and this subview
                // wanted to stretch to fill available space. Translate that to
                // WRAP_CONTENT so that it does not end up with a height of 0
                oldHeight = 0;
                lp.height = GRXWrapContent;
            }

            // Determine how big this subview would like to.  If this or
            // previous subviews have given a weight, then we allow it to
            // use all available space (and we will shrink things later
            // if needed).
            CGFloat totalHeight = (totalWeight == 0) ? self.totalLength : 0;
            [self measureSubviewBeforeLayout:subview
                                   widthSpec:widthSpec
                                  totalWidth:0
                                  heightSpec:heightSpec
                                 totalHeight:totalHeight];

            if (oldHeight != -CGFLOAT_MAX) {
                lp.height = oldHeight;
            }

            self.totalLength += subview.grx_measuredSize.height + lp.margins.top +
                lp.margins.bottom;
        }

        BOOL matchWidthLocally = NO;
        if (widthSpec.mode != GRXMeasureSpecExactly && lp.width == GRXMatchParent) {
            // The width of the linear layout will scale, and at least one
            // subview said it wanted to match our width. Set a flag
            // indicating that we need to remeasure at least that view when
            // we know our width.
            matchWidth = YES;
            matchWidthLocally = YES;
        }

        CGFloat margin = lp.margins.left + lp.margins.right;
        CGFloat measuredWidth = subview.grx_measuredSize.width + margin;
        maxWidth = MAX(maxWidth, measuredWidth);

        allFillParent = (allFillParent && lp.width == GRXMatchParent);
        if (lp.weight > 0) {
            weightedMaxWidth = MAX(weightedMaxWidth,
                                   matchWidthLocally ? margin : measuredWidth);
        } else {
            alternativeMaxWidth = MAX(alternativeMaxWidth,
                                      matchWidthLocally ? margin : measuredWidth);
        }
    }

    // Add in our padding
    self.totalLength += self.padding.top + self.padding.bottom;

    CGFloat heightSize = self.totalLength;

    // Check against our minimum height
    heightSize = MAX(heightSize, self.grx_minSize.height);

    // Reconcile our calculated size with the heightMeasureSpec
    heightSize = GRXMeasureSpecResolveSizeValue(heightSize, heightSpec);

    // Either expand subviews with weight to take up available space or
    // shrink them if they extend beyond our current bounds
    CGFloat delta = heightSize - self.totalLength;
    if (delta != 0 && totalWeight > 0) {
        float weightSum = self.weightSum > 0 ? self.weightSum : totalWeight;

        self.totalLength = 0;

        for (UIView *subview in self.subviews) {
            if (subview.grx_visibility == GRXVisibilityGone) {
                continue;
            }

            GRXLinearLayoutParams *lp = subview.grx_linearLayoutParams;

            CGFloat subviewExtra = lp.weight;
            CGSize measuredSubviewSize = CGSizeZero;
            if (subviewExtra > 0) {
                // Subview said it could absorb extra space -- give him his share
                CGFloat share = subviewExtra * delta / weightSum;
                weightSum -= subviewExtra;
                delta -= share;

                CGFloat totalSubviewPadding = self.padding.left + self.padding.right + lp.margins.left + lp.margins.right;
                GRXMeasureSpec subviewWidthMeasureSpec = [self subviewSpecWithParentSpec:widthSpec
                                                                                 padding:totalSubviewPadding
                                                                        subviewDimension:lp.width];

                if ((lp.height != 0) || (heightSpec.mode != GRXMeasureSpecExactly)) {
                    // subview was measured once already above...
                    // base new measurement on stored values
                    CGFloat subviewHeight = subview.grx_measuredSize.height + share;
                    if (subviewHeight < 0) {
                        subviewHeight = 0;
                    }
                    measuredSubviewSize = [subview grx_measuredSizeForWidthSpec:subviewWidthMeasureSpec
                                                                     heightSpec:GRXMeasureSpecMake(subviewHeight, GRXMeasureSpecExactly)];
                } else {
                    // subview was skipped in the loop above.
                    // Measure for this first time here

                    measuredSubviewSize = [subview grx_measuredSizeForWidthSpec:subviewWidthMeasureSpec
                                                                     heightSpec:GRXMeasureSpecMake(share > 0 ? share : 0, GRXMeasureSpecExactly)];
                }
            }

            CGFloat margin =  lp.margins.left + lp.margins.right;
            CGFloat subviewWidth = measuredSubviewSize.width + margin;
            maxWidth = MAX(maxWidth, subviewWidth);

            BOOL matchWidthLocally = widthSpec.mode != GRXMeasureSpecExactly &&
                lp.width == GRXMatchParent;

            alternativeMaxWidth = MAX(alternativeMaxWidth,
                                      matchWidthLocally ? margin : subviewWidth);

            allFillParent = allFillParent && lp.width == GRXMatchParent;

            self.totalLength += subview.grx_measuredSize.height + lp.margins.top + lp.margins.bottom;
        }

        // Add in our padding
        self.totalLength += self.padding.top + self.padding.bottom;
    } else {
        alternativeMaxWidth = MAX(alternativeMaxWidth, weightedMaxWidth);
    }

    if (!allFillParent && widthSpec.mode != GRXMeasureSpecExactly) {
        maxWidth = alternativeMaxWidth;
    }

    maxWidth += self.padding.left + self.padding.right;

    // Check against our minimum width
    maxWidth = MAX(maxWidth, self.grx_minSize.width);


    CGSize ownSize = CGSizeMake(GRXMeasureSpecResolveSizeValue(maxWidth, widthSpec), heightSize);

    if (matchWidth) {
        [self forceUniformWidthWithWidth:ownSize.width
                              heigthSpec:heightSpec];
    }
    return ownSize;
}

- (CGSize)grx_measureHorizontalForWidthSpec:(GRXMeasureSpec)widthSpec
                                 heightSpec:(GRXMeasureSpec)heightSpec {
    self.totalLength = 0;
    CGFloat maxHeight = 0;
    CGFloat alternativeMaxHeight = 0;
    CGFloat weightedMaxHeight = 0;
    BOOL allFillParent = YES;
    float totalWeight = 0;

    BOOL matchHeight = NO;

    for (UIView *subview in self.subviews) {
        if (subview.grx_visibility == GRXVisibilityGone) {
            continue;
        }

        GRXLinearLayoutParams *lp = subview.grx_linearLayoutParams;
        totalWeight += lp.weight;

        if (widthSpec.mode == GRXMeasureSpecExactly && lp.width == 0 && lp.weight > 0) {
            self.totalLength += lp.margins.left + lp.margins.right;
        } else {
            CGFloat oldWidth = -CGFLOAT_MAX;

            if (lp.width == 0 && lp.weight > 0) {
                oldWidth = 0;
                lp.width = GRXWrapContent;
            }
            CGFloat totalWidth = (totalWeight == 0) ? self.totalLength : 0;
            CGSize subviewMeasuredSize = [self measureSubviewBeforeLayout:subview
                                                                widthSpec:widthSpec
                                                               totalWidth:totalWidth
                                                               heightSpec:heightSpec
                                                              totalHeight:0];

            if (oldWidth != -CGFLOAT_MAX) {
                lp.width = oldWidth;
            }

            self.totalLength += subviewMeasuredSize.width + lp.margins.left + lp.margins.right;
        }

        BOOL matchHeightLocally = NO;
        if (heightSpec.mode != GRXMeasureSpecExactly && lp.height == GRXMatchParent) {
            matchHeight = YES;
            matchHeightLocally = YES;
        }

        CGFloat margin = lp.margins.top + lp.margins.bottom;
        CGFloat measuredHeight = subview.grx_measuredSize.height + margin;
        maxHeight = MAX(maxHeight, measuredHeight);

        allFillParent = (allFillParent && lp.height == GRXMatchParent);
        if (lp.weight > 0) {
            weightedMaxHeight = MAX(weightedMaxHeight,
                                    matchHeightLocally ? margin : measuredHeight);
        } else {
            alternativeMaxHeight = MAX(alternativeMaxHeight,
                                       matchHeightLocally ? margin : measuredHeight);
        }
    }

    // Add in our padding
    self.totalLength += self.padding.left + self.padding.right;

    CGFloat widthSize = self.totalLength;

    // Check against our minimum width
    widthSize = MAX(widthSize, self.grx_minSize.width);

    // Reconcile our calculated size with the widthMeasureSpec
    widthSize = GRXMeasureSpecResolveSizeValue(widthSize, widthSpec);

    CGFloat delta = widthSize - self.totalLength;
    if (delta != 0 && totalWeight > 0) {
        float weightSum = self.weightSum > 0 ? self.weightSum : totalWeight;

        self.totalLength = 0;

        for (UIView *subview in self.subviews) {
            if (subview.grx_visibility == GRXVisibilityGone) {
                continue;
            }

            GRXLinearLayoutParams *lp = subview.grx_linearLayoutParams;

            CGFloat subviewExtra = lp.weight;
            CGSize measuredSubviewSize = CGSizeZero;
            if (subviewExtra > 0) {
                // Subview said it could absorb extra space -- give him his share
                CGFloat share = subviewExtra * delta / weightSum;
                weightSum -= subviewExtra;
                delta -= share;

                CGFloat totalSubviewPadding = self.padding.top + self.padding.bottom + lp.margins.top + lp.margins.bottom;
                GRXMeasureSpec subviewHeightMeasureSpec = [self subviewSpecWithParentSpec:heightSpec
                                                                                  padding:totalSubviewPadding
                                                                         subviewDimension:lp.height];

                if ((lp.width != 0) || (widthSpec.mode != GRXMeasureSpecExactly)) {
                    // subview was measured once already above...
                    // base new measurement on stored values
                    CGFloat subviewWidth = subview.grx_measuredSize.width + share;
                    if (subviewWidth < 0) {
                        subviewWidth = 0;
                    }
                    measuredSubviewSize = [subview grx_measuredSizeForWidthSpec:GRXMeasureSpecMake(subviewWidth, GRXMeasureSpecExactly)
                                                                     heightSpec:subviewHeightMeasureSpec];
                } else {
                    // subview was skipped in the loop above.
                    // Measure for this first time here

                    measuredSubviewSize = [subview grx_measuredSizeForWidthSpec:GRXMeasureSpecMake(share > 0 ? share : 0, GRXMeasureSpecExactly)
                                                                     heightSpec:subviewHeightMeasureSpec];
                }
            }

            self.totalLength += measuredSubviewSize.width + lp.margins.left + lp.margins.right;
            BOOL matchHeightLocally = heightSpec.mode != GRXMeasureSpecExactly && lp.height == GRXMatchParent;
            CGFloat margin = lp.margins.top + lp.margins.bottom;
            CGFloat subviewHeight = measuredSubviewSize.height + margin;
            maxHeight = MAX(maxHeight, subviewHeight);
            alternativeMaxHeight = MAX(alternativeMaxHeight,
                                       matchHeightLocally ? margin : subviewHeight);
            allFillParent = allFillParent && lp.width == GRXMatchParent;
        }

        // Add in our padding
        self.totalLength += self.padding.top + self.padding.bottom;
    } else {
        alternativeMaxHeight = MAX(alternativeMaxHeight, weightedMaxHeight);
    }

    if (!allFillParent && widthSpec.mode != GRXMeasureSpecExactly) {
        maxHeight = alternativeMaxHeight;
    }

    maxHeight += self.padding.top + self.padding.bottom;

    // Check against our minimum width
    maxHeight = MAX(maxHeight, self.grx_minSize.height);


    CGSize ownSize = CGSizeMake(widthSize,
                                GRXMeasureSpecResolveSizeValue(maxHeight, heightSpec));

    if (matchHeight) {
        [self forceUniformHeightWithHeight:ownSize.height
                                 widthSpec:widthSpec];
    }
    return ownSize;
}

- (CGSize)measureSubviewBeforeLayout:(UIView *)subview
                           widthSpec:(GRXMeasureSpec)widthSpec
                          totalWidth:(CGFloat)totalWidth
                          heightSpec:(GRXMeasureSpec)heightSpec
                         totalHeight:(CGFloat)totalHeight {
    CGSize measuredSize = [self measureSubviewWithMargins:subview
                                          parentWidthSpec:widthSpec
                                                widthUsed:totalWidth
                                         parentHeightSpec:heightSpec
                                               heightUsed:totalHeight];
    return measuredSize;
}

- (void)forceUniformWidthWithWidth:(CGFloat)width
                        heigthSpec:(GRXMeasureSpec)heightSpec {
    // Pretend that the linear layout has an exact size.
    GRXMeasureSpec uniformMeasureSpec = GRXMeasureSpecMake(width,
                                                           GRXMeasureSpecExactly);
    for (UIView *subview in self.subviews) {
        if (subview.grx_visibility == GRXVisibilityGone) {
            continue;
        }

        GRXLinearLayoutParams *lp = subview.grx_linearLayoutParams;
        if (lp.width == GRXMatchParent) {
            // Temporarily force subviews to reuse their old measured height
            int oldHeight = lp.height;
            lp.height = subview.grx_measuredSize.height;

            // Remeasure with new dimensions
            [self measureSubviewWithMargins:subview
                            parentWidthSpec:uniformMeasureSpec
                                  widthUsed:0
                           parentHeightSpec:heightSpec
                                 heightUsed:0];
            lp.height = oldHeight;
        }
    }
}

- (void)forceUniformHeightWithHeight:(CGFloat)height
                           widthSpec:(GRXMeasureSpec)widthSpec {
    // Pretend that the linear layout has an exact size.
    GRXMeasureSpec uniformMeasureSpec = GRXMeasureSpecMake(height,
                                                           GRXMeasureSpecExactly);
    for (UIView *subview in self.subviews) {
        if (subview.grx_visibility == GRXVisibilityGone) {
            continue;
        }
        GRXLinearLayoutParams *lp = subview.grx_linearLayoutParams;
        if (lp.height == GRXMatchParent) {
            // Temporarily force subviews to reuse their old measured height
            int oldWidth = lp.width;
            lp.width = subview.grx_measuredSize.width;

            // Remeasure with new dimensions
            [self measureSubviewWithMargins:subview
                            parentWidthSpec:widthSpec
                                  widthUsed:0
                           parentHeightSpec:uniformMeasureSpec
                                 heightUsed:0];
            lp.width = oldWidth;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.direction == GRXLinearLayoutDirectionVertical) {
        return [self layoutSubviewsVertical];
    } else {
        return [self layoutSubviewsHorizontal];
    }
}

- (void)layoutSubviewsVertical {
    CGPoint subviewPos = CGPointMake(self.padding.left, self.padding.top);

    // Where right end of subview should go
    const CGFloat ownWidth = self.grx_measuredSize.width;

    // Space available for subview
    CGFloat availableWidth = ownWidth - self.padding.left - self.padding.right;

    for (UIView *subview in self.subviews) {
        if (subview.grx_visibility == GRXVisibilityGone) {
            continue;
        }

        CGSize subviewSize = subview.grx_measuredSize;
        subview.size = subviewSize;

        GRXLinearLayoutParams *params = subview.grx_linearLayoutParams;

        switch (params.gravity) {
            default:
            case GRXLinearLayoutGravityBegin:
                subview.left = subviewPos.x + params.margins.left;
                subview.top = subviewPos.y + params.margins.top;
                break;
            case GRXLinearLayoutGravityCenter:
                subview.left = (self.width - subviewSize.width) / 2; // margin already substracted
                subview.top = subviewPos.y + params.margins.top;
                break;
            case GRXLinearLayoutGravityEnd:
                subview.right = availableWidth - params.margins.right;
                subview.top = subviewPos.y + params.margins.top;
                break;
        }
        subviewPos.y += subview.height + params.margins.top + params.margins.bottom;
    }
}

- (void)layoutSubviewsHorizontal {
    CGPoint subviewPos = CGPointMake(self.padding.left, self.padding.top);

    // Where right end of subview should go
    const CGFloat ownHeight = self.grx_measuredSize.height;

    // Space available for subview
    CGFloat availableHeight = ownHeight - self.padding.top - self.padding.bottom;

    for (UIView *subview in self.subviews) {
        if (subview.grx_visibility == GRXVisibilityGone) {
            continue;
        }

        CGSize subviewSize = subview.grx_measuredSize;
        subview.size = subviewSize;

        GRXLinearLayoutParams *params = subview.grx_linearLayoutParams;
        switch (params.gravity) {
            default:
            case GRXLinearLayoutGravityBegin:
                subview.left = subviewPos.x + params.margins.left;
                subview.top = subviewPos.y + params.margins.top;
                break;
            case GRXLinearLayoutGravityCenter:
                subview.left = subviewPos.x + params.margins.left;
                subview.top = (ownHeight - subviewSize.height) / 2; // margin already substracted in size
                break;
            case GRXLinearLayoutGravityEnd:
                subview.left = subviewPos.x + params.margins.left;
                subview.bottom = availableHeight - params.margins.bottom;
                break;
        }
        subviewPos.x += subview.width + params.margins.left + params.margins.right;
    }
}

@end

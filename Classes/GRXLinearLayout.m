#import "GRXLinearLayout.h"
#import "GRXLayout+Protected.h"

@interface GRXLinearLayout ()

@property (nonatomic) CGFloat totalLength;

@end

@implementation GRXLinearLayout

+ (Class)layoutParamsClass {
    return GRXLinearLayoutParams.class;
}

- (instancetype)init {
    return [self initWithDirection:kGRXLinearLayoutDefaultDirection
                         weightSum:kGRXLinearLayoutDefaultWeightSum];
}

- (instancetype)initWithDirection:(GRXLinearLayoutDirection)direction {
    return [self initWithDirection:direction
                         weightSum:kGRXLinearLayoutDefaultWeightSum];
}

- (instancetype)initWithDirection:(GRXLinearLayoutDirection)direction
                        weightSum:(CGFloat)weightSum {
    self = [super init];
    if (self) {
        self.direction = direction;
        self.weightSum = weightSum;
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

    BOOL matchWidth = YES;

    // See how tall everyone is. Also remember max width.
    for (UIView *child in self.subviews) {
        if (child.grx_visibility == GRXViewVisibilityGone) {
            continue;
        }

        GRXLinearLayoutParams *lp = child.grx_linearLayoutParams;
        totalWeight += lp.weight;

        if (heightSpec.mode == GRXMeasureSpecExactly && lp.height == 0 && lp.weight > 0) {
            // Optimization: don't bother measuring children who are going to use
            // leftover space. These views will get measured again down below if
            // there is any leftover space.
            self.totalLength += lp.margins.top + lp.margins.bottom;
        } else {
            CGFloat oldHeight = CGFLOAT_MIN;

            if (lp.height == 0 && lp.weight > 0) {
                // heightMode is either UNSPECIFIED OR AT_MOST, and this child
                // wanted to stretch to fill available space. Translate that to
                // WRAP_CONTENT so that it does not end up with a height of 0
                oldHeight = 0;
                lp.height = GRXWrapContent;
            }

            // Determine how big this child would like to.  If this or
            // previous children have given a weight, then we allow it to
            // use all available space (and we will shrink things later
            // if needed).
            [self measureChildBeforeLayout:child
                                 widthSpec:widthSpec
                                totalWidth:0
                                heightSpec:heightSpec
                               totalHeight:totalWeight == 0 ? self.totalLength:0];

            if (oldHeight != CGFLOAT_MIN) {
                lp.height = oldHeight;
            }

            self.totalLength += child.grx_measuredSize.height + lp.margins.top +
                lp.margins.bottom;
        }

        BOOL matchWidthLocally = NO;
        if (widthSpec.mode != GRXMeasureSpecExactly && lp.width == GRXMatchParent) {
            // The width of the linear layout will scale, and at least one
            // child said it wanted to match our width. Set a flag
            // indicating that we need to remeasure at least that view when
            // we know our width.
            matchWidth = YES;
            matchWidthLocally = YES;
        }

        CGFloat margin = lp.margins.left + lp.margins.right;
        CGFloat measuredWidth = child.grx_measuredSize.width + margin;
        maxWidth = MAX(maxWidth, measuredWidth);

        allFillParent = (allFillParent && lp.width == GRXMatchParent);
        if (lp.weight > 0) {
            /*
             * Widths of weighted Views are bogus if we end up
             * remeasuring, so keep them separate.
             */
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

    // Either expand children with weight to take up available space or
    // shrink them if they extend beyond our current bounds
    CGFloat delta = heightSize - self.totalLength;
    if (delta != 0 && totalWeight > 0) {
        float weightSum = self.weightSum > 0 ? self.weightSum : totalWeight;

        self.totalLength = 0;

        for (UIView *child in self.subviews) {
            if (child.grx_visibility == GRXViewVisibilityGone) {
                continue;
            }

            GRXLinearLayoutParams *lp = child.grx_linearLayoutParams;

            CGFloat childExtra = lp.weight;
            if (childExtra > 0) {
                // Child said it could absorb extra space -- give him his share
                CGFloat share = childExtra * delta / weightSum;
                weightSum -= childExtra;
                delta -= share;

                CGFloat totalChildPadding = self.padding.left + self.padding.right + lp.margins.left + lp.margins.right;
                GRXMeasureSpec childWidthMeasureSpec = [self subviewSpecWithParentSpec:widthSpec
                                                                               padding:totalChildPadding
                                                                      subviewDimension:lp.width];

                // TODO: Use a field like lp.isMeasured to figure out if this
                // child has been previously measured
                if ((lp.height != 0) || (heightSpec.mode != GRXMeasureSpecExactly)) {
                    // child was measured once already above...
                    // base new measurement on stored values
                    int childHeight = child.grx_measuredSize.height + share;
                    if (childHeight < 0) {
                        childHeight = 0;
                    }
                    CGSize childSize = [child grx_measuredSizeForWidthSpec:childWidthMeasureSpec
                                                                heightSpec:GRXMeasureSpecMake(childHeight, GRXMeasureSpecExactly)];
                    #pragma unused(childSize)
                } else {
                    // child was skipped in the loop above.
                    // Measure for this first time here

                    CGSize childSize = [child grx_measuredSizeForWidthSpec:childWidthMeasureSpec
                                                                heightSpec:GRXMeasureSpecMake(share > 0 ? share : 0, GRXMeasureSpecExactly)];
                    #pragma unused(childSize)
                }
            }

            CGFloat margin =  lp.margins.left + lp.margins.right;
            CGFloat measuredWidth = child.grx_measuredSize.width + margin;
            maxWidth = MAX(maxWidth, measuredWidth);

            BOOL matchWidthLocally = widthSpec.mode != GRXMeasureSpecExactly &&
                lp.width == GRXMatchParent;

            alternativeMaxWidth = MAX(alternativeMaxWidth,
                                      matchWidthLocally ? margin : measuredWidth);

            allFillParent = allFillParent && lp.width == GRXMatchParent;

            self.totalLength += child.grx_measuredSize.height + lp.margins.top + lp.margins.bottom;
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
    return CGSizeZero;
}

- (void)measureChildBeforeLayout:(UIView *)child
                       widthSpec:(GRXMeasureSpec)widthSpec
                      totalWidth:(CGFloat)totalWidth
                      heightSpec:(GRXMeasureSpec)heightSpec
                     totalHeight:(CGFloat)totalHeight {
    [self measureSubviewWithMargins:child
                    parentWidthSpec:widthSpec
                          widthUsed:totalWidth
                   parentHeightSpec:heightSpec
                         heightUsed:totalHeight];
}

- (void)forceUniformWidthWithWidth:(CGFloat)width
                        heigthSpec:(GRXMeasureSpec)heightSpec {
    // Pretend that the linear layout has an exact size.
    GRXMeasureSpec uniformMeasureSpec = GRXMeasureSpecMake(width,
                                                           GRXMeasureSpecExactly);
    for (UIView *child in self.subviews) {
        if (child.grx_visibility != GRXViewVisibilityGone) {
            GRXLinearLayoutParams *lp = child.grx_linearLayoutParams;
            if (lp.width == GRXMatchParent) {
                // Temporarily force children to reuse their old measured height
                int oldHeight = lp.height;
                lp.height = child.grx_measuredSize.height;

                // Remeasure with new dimensions
                [self measureSubviewWithMargins:child
                                parentWidthSpec:uniformMeasureSpec
                                      widthUsed:0
                               parentHeightSpec:heightSpec
                                     heightUsed:0];
                lp.height = oldHeight;
            }
        }
    }
}



- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.direction == GRXLinearLayoutDirectionVertical) {
        return [self layoutVertical];
    } else {
        return [self layoutHorizontal];
    }
}

- (void)layoutVertical {
    CGPoint childPos = CGPointMake(self.padding.left, self.padding.top);

    // Where right end of child should go
    const CGFloat width = self.grx_measuredSize.width;
    CGFloat childRight = width - self.padding.right;

    // Space available for child
    CGFloat childSpace = width - self.padding.left - self.padding.right;
/*
    final int majorGravity = mGravity & Gravity.VERTICAL_GRAVITY_MASK;
    final int minorGravity = mGravity & Gravity.HORIZONTAL_GRAVITY_MASK;

    if (majorGravity != Gravity.TOP) {
        switch (majorGravity) {
            case Gravity.BOTTOM:
                // mTotalLength contains the padding already, we add the top
                // padding to compensate
                childTop = mBottom - mTop + mPaddingTop - mTotalLength;
                break;

            case Gravity.CENTER_VERTICAL:
                childTop += ((mBottom - mTop)  - mTotalLength) / 2;
                break;
        }

    }
 */
    /*
       for (UIView *view in self.subviews) {
        if(view.grx_visibility == GRXViewVisibilityGone) {
            continue;
        }

        CGSize childSize = view.grx_measuredSize;
        GRXLinearLayoutParams * lp = view.grx_linearLayoutParams;

        switch (lp.gravity) {
            default:
            case GRXLinearLayoutGravityBegin:
                view.origin = pos;
                break;
            case GRXLinearLayoutGravityCenter:
                if (self.direction == GRXLinearLayoutDirectionHorizontal) {
                    view.origin = CGPointMake(pos.x,
                                              params.margins.top + (self.height - viewSize.height) / 2);
                } else {
                    view.origin = CGPointMake(params.margins.left + (self.width - viewSize.width) / 2,
                                              pos.y);
                }
                break;
            case GRXLinearLayoutGravityEnd:
                if (self.direction == GRXLinearLayoutDirectionHorizontal) {
                    view.left = pos.x;
                    view.bottom = availableSize.height;
                } else {
                    view.right = availableSize.width;
                    view.top = pos.y;
                }
                break;
        }


       /*
            int gravity = lp.gravity;
            if (gravity < 0) {
                gravity = minorGravity;
            }

            switch (gravity & Gravity.HORIZONTAL_GRAVITY_MASK) {
                case Gravity.LEFT:
                    childLeft = paddingLeft + lp.leftMargin;
                    break;

                case Gravity.CENTER_HORIZONTAL:
                    childLeft = paddingLeft + ((childSpace - childWidth) / 2)
     + lp.leftMargin - lp.rightMargin;
                    break;

                case Gravity.RIGHT:
                    childLeft = childRight - childWidth - lp.rightMargin;
                    break;
            }


            childTop += lp.topMargin;
            setChildFrame(child, childLeft, childTop + getLocationOffset(child),
                          childWidth, childHeight);
            childTop += childHeight + lp.bottomMargin + getNextLocationOffset(child);

            i += getChildrenSkipCount(child, i);
        }
       }
     */
}

- (void)layoutHorizontal {
}

@end

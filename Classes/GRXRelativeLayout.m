#import "GRXRelativeLayout.h"
#import "GRXDependencyGraph.h"
#import "GRXLayout+Protected.h"

NS_ASSUME_NONNULL_BEGIN

@interface GRXRelativeLayout ()

@property (nonatomic, retain) NSArray *sortedSubviewsVertical, *sortedSubviewsHorizontal;
@property (nonatomic) GRXDependencyGraph *dependencyGraph;

@end

@implementation GRXRelativeLayout

+ (Class)layoutParamsClass {
    return GRXRelativeLayoutParams.class;
}

- (void)setDirtyHierarchy:(BOOL)dirtyHierarchy {
    _dirtyHierarchy = dirtyHierarchy;
    if (dirtyHierarchy) {
        [self grx_invalidateMeasuredSize];
    }
}

#pragma mark - Initializiation

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _sortedSubviewsVertical = [NSMutableArray array];
        _sortedSubviewsHorizontal = [NSMutableArray array];
        _dependencyGraph = [[GRXDependencyGraph alloc] init];
    }
    return self;
}

#pragma mark - Overriden methods

// Adding and removes subviews may change the view hierarchy, views might need to be resorted again
- (void)addSubview:(UIView *)view {
    [super addSubview:view];
    self.dirtyHierarchy = YES;
}

- (void)willRemoveSubview:(UIView *)subview {
    [super willRemoveSubview:subview];
    self.dirtyHierarchy = YES;
}

- (CGSize)grx_measureForWidthSpec:(GRXMeasureSpec)widthSpec
                       heightSpec:(GRXMeasureSpec)heightSpec {
    // Sort views both vertically and horizontally
    if (self.isHierarchyDirty) {
        [self sortSubviews];
        self.dirtyHierarchy = NO;
    }

    // ownWidth and ownHeight refer to the maximum size that the view will have
    CGSize maxSize = CGSizeMake(-1, -1);
    // Measured size will be the computed size for this layout, and what will be returned
    CGSize measuredSize = CGSizeZero;

    // set own dimensions if they are known
    if (widthSpec.mode != GRXMeasureSpecUnspecified) {
        maxSize.width = widthSpec.value;
    }
    if (heightSpec.mode != GRXMeasureSpecUnspecified) {
        maxSize.height = heightSpec.value;
    }
    if (widthSpec.mode == GRXMeasureSpecExactly) {
        measuredSize.width = maxSize.width;
    }
    if (heightSpec.mode == GRXMeasureSpecExactly) {
        measuredSize.height = maxSize.height;
    }

    // These variables indicate if we have to move the axis. This will happen only if
    // we have views positioned to the center, either vertically or horizontally
    BOOL offsetHorizontalAxis = NO;
    BOOL offsetVerticalAxis = NO;

    const BOOL isWrapContentWidth = widthSpec.mode != GRXMeasureSpecExactly;
    const BOOL isWrapContentHeight = heightSpec.mode != GRXMeasureSpecExactly;

    // Iterate over views horizontally and vertically and measure them
    for (UIView *subview in self.sortedSubviewsHorizontal) {
        if (subview.grx_visibility == GRXVisibilityGone) {
            continue;
        }

        GRXRelativeLayoutParams *subviewParams = subview.grx_relativeLayoutParams;

        [self applyHorizontalSizeRulesToSubview:subview params:subviewParams maxOwnWidth:maxSize.width];
        CGSize subviewSize = [self measureSubviewHorizontal:subview
                                                     params:subviewParams
                                                 maxOwnSize:maxSize];
#pragma unused(subviewSize)
        if ( [self positionSubviewHorizontal:subview params:subviewParams maxOwnWidth:maxSize.width wrapContent:isWrapContentWidth] ) {
            offsetHorizontalAxis = YES;
        }
    }

    for (UIView *subview in self.sortedSubviewsVertical) {
        if (subview.grx_visibility == GRXVisibilityGone) {
            continue;
        }

        GRXRelativeLayoutParams *subviewParams = subview.grx_relativeLayoutParams;

        [self applyVerticalSizeRulesToSubview:subview params:subviewParams maxOwnHeight:maxSize.height];
        CGSize subviewSize = [self measureSubview:subview
                                           params:subviewParams
                                       maxOwnSize:maxSize];
#pragma unused(subviewSize)
        if ( [self positionSubviewVertical:subview params:subviewParams maxOwnHeight:maxSize.height wrapContent:isWrapContentHeight] ) {
            offsetVerticalAxis = YES;
        }

        if (isWrapContentWidth) {
            measuredSize.width = MAX(measuredSize.width, subviewParams.right);
        }

        if (isWrapContentHeight) {
            measuredSize.height = MAX(measuredSize.height, subviewParams.bottom);
        }
    }

    GRXLayoutParams *ownParams = self.grx_layoutParams;
    CGSize ownMinSize = self.grx_minSize;

    if (isWrapContentWidth) {
        // Width already has left padding in it since it was calculated by looking at
        // the right of each subview
        measuredSize.width += self.padding.right;

        if (ownParams.width >= 0) {
            measuredSize.width = MAX(measuredSize.width, ownParams.width);
        }

        measuredSize.width = MAX(measuredSize.width, ownMinSize.width);
        measuredSize.width = GRXMeasureSpecResolveSizeValue(measuredSize.width, widthSpec);

        if (offsetHorizontalAxis) {
            for (UIView *subview in self.subviews) {
                if (subview.grx_visibility == GRXVisibilityGone) {
                    continue;
                }

                GRXRelativeLayoutParams *params = subview.grx_relativeLayoutParams;
                if ([params hasParentRule:GRXRelativeLayoutParentRuleCenter] ||
                    [params hasParentRule:GRXRelativeLayoutParentRuleCenterHorizontal]) {
                    centerHorizontal(params, subview.grx_measuredSize.width, measuredSize.width);
                }
            }
        }
    }

    if (isWrapContentHeight) {
        // Height already has top padding in it since it was calculated by looking at
        // the bottom of each subview
        measuredSize.height += self.padding.bottom;

        if (ownParams.height >= 0) {
            measuredSize.height = MAX(measuredSize.height, ownParams.height);
        }

        measuredSize.height = MAX(measuredSize.height, ownMinSize.height);
        measuredSize.height = GRXMeasureSpecResolveSizeValue(measuredSize.height, heightSpec);

        if (offsetVerticalAxis) {
            for (UIView *view in self.subviews) {
                if (view.grx_visibility == GRXVisibilityGone) {
                    continue;
                }
                GRXRelativeLayoutParams *params = view.grx_relativeLayoutParams;
                if ([params hasParentRule:GRXRelativeLayoutParentRuleCenter] ||
                    [params hasParentRule:GRXRelativeLayoutParentRuleCenterVertical]) {
                    centerVertical(params, view.grx_measuredSize.height, measuredSize.height);
                }
            }
        }
    }

    // Final step: set calculated frames to subviews
    for (UIView *view in self.subviews) {
        GRXRelativeLayoutParams *params = view.grx_relativeLayoutParams;
        if (view.grx_visibility != GRXVisibilityGone && NO == CGRectEqualToRect(view.frame, params.rect)) {
            view.frame = params.rect;
        }
    }

    return measuredSize;
}

- (void)sortSubviews {
    [self.dependencyGraph clear];
    for (UIView *view in self.subviews) {
        [self.dependencyGraph add:view];
    }

    self.sortedSubviewsHorizontal = [self.dependencyGraph sortedViewsWithRules:[GRXRelativeLayoutParams horizontalRules]];
    self.sortedSubviewsVertical = [self.dependencyGraph sortedViewsWithRules:[GRXRelativeLayoutParams verticalRules]];
}

- (GRXRelativeLayoutParams *)relatedSubviewParamsForSubviewParams:(GRXRelativeLayoutParams *)layoutParams
                                                         relation:(GRXRelativeLayoutRule)relation {
    UIView *view = [layoutParams viewForRule:relation];
    if (view) {
        GRXDependencyNode *node = self.dependencyGraph.nodes[view.grx_layoutId];
        if (node == nil) {
            return nil;
        }

        // find the first non-gone view up the chain
        while (view.grx_visibility == GRXVisibilityGone) {
            layoutParams = view.grx_relativeLayoutParams;
            view = [layoutParams viewForRule:relation];
            node = self.dependencyGraph.nodes[view.grx_layoutId];
            if (node == nil) {
                return nil;
            }
        }
    }

    return view.grx_relativeLayoutParams;
}

- (void)applyHorizontalSizeRulesToSubview:(UIView *)subview
                                   params:(GRXRelativeLayoutParams *)subviewParams
                              maxOwnWidth:(CGFloat)ownWidth {
    // -1 indicates a "soft requirement" in that direction. For example:
    // left=10, right=-1 means the view must start at 10, but can go as far as it wants to the right
    // left =-1, right=10 means the view must end at 10, but can go as far as it wants to the left
    // left=10, right=20 means the left and right ends are both fixed
    subviewParams.left = -1;
    subviewParams.right = -1;

    // Adjust rules relative to other views
    GRXRelativeLayoutParams *anchorParams = [self relatedSubviewParamsForSubviewParams:subviewParams
                                                                              relation:GRXRelativeLayoutRuleLeftOf];
    if (anchorParams != nil) {
        subviewParams.right = anchorParams.left - (anchorParams.margins.left + subviewParams.margins.right);
    }

    anchorParams = [self relatedSubviewParamsForSubviewParams:subviewParams
                                                     relation:GRXRelativeLayoutRuleRightOf];
    if (anchorParams != nil) {
        subviewParams.left = anchorParams.right + (anchorParams.margins.right + subviewParams.margins.left);
    }

    anchorParams = [self relatedSubviewParamsForSubviewParams:subviewParams
                                                     relation:GRXRelativeLayoutRuleAlignLeft];
    if (anchorParams != nil) {
        subviewParams.left = anchorParams.left + subviewParams.margins.left;
    }

    anchorParams = [self relatedSubviewParamsForSubviewParams:subviewParams
                                                     relation:GRXRelativeLayoutRuleAlignRight];
    if (anchorParams != nil) {
        subviewParams.right = anchorParams.right - subviewParams.margins.right;
    }

    // Adjust parent rules
    if ([subviewParams hasParentRule:GRXRelativeLayoutParentRuleAlignLeft]) {
        subviewParams.left = self.padding.left + subviewParams.margins.left;
    }

    if ([subviewParams hasParentRule:GRXRelativeLayoutParentRuleAlignRight]) {
        subviewParams.right = ownWidth - self.padding.right - subviewParams.margins.right;
    }
}

- (void)applyVerticalSizeRulesToSubview:(UIView *)subview
                                 params:(GRXRelativeLayoutParams *)subviewParams
                           maxOwnHeight:(CGFloat)ownHeight {
    subviewParams.top = -1;
    subviewParams.bottom = -1;

    // Adjust rules relative to other views
    GRXRelativeLayoutParams *anchorParams = [self relatedSubviewParamsForSubviewParams:subviewParams
                                                                              relation:GRXRelativeLayoutRuleAbove];
    if (anchorParams != nil) {
        subviewParams.bottom = anchorParams.top - (anchorParams.margins.top + subviewParams.margins.bottom);
    }

    anchorParams = [self relatedSubviewParamsForSubviewParams:subviewParams
                                                     relation:GRXRelativeLayoutRuleBelow];
    if (anchorParams != nil) {
        subviewParams.top = anchorParams.bottom + (anchorParams.margins.bottom + subviewParams.margins.top);
    }

    anchorParams = [self relatedSubviewParamsForSubviewParams:subviewParams
                                                     relation:GRXRelativeLayoutRuleAlignTop];
    if (anchorParams != nil) {
        subviewParams.top = anchorParams.top + subviewParams.margins.top;
    }

    anchorParams = [self relatedSubviewParamsForSubviewParams:subviewParams
                                                     relation:GRXRelativeLayoutRuleAlignBottom];
    if (anchorParams != nil) {
        subviewParams.bottom = anchorParams.bottom - subviewParams.margins.bottom;
    }

    // Adjust parent rules
    if ([subviewParams hasParentRule:GRXRelativeLayoutParentRuleAlignTop]) {
        subviewParams.top = self.padding.top + subviewParams.margins.top;
    }

    if ([subviewParams hasParentRule:GRXRelativeLayoutParentRuleAlignBottom]) {
        subviewParams.bottom = ownHeight - self.padding.bottom - subviewParams.margins.bottom;
    }
}

- (CGSize)measureSubview:(UIView *)subview
                  params:(GRXRelativeLayoutParams *)params
              maxOwnSize:(CGSize)maxOwnSize {
    GRXMeasureSpec widthSpec = [self subviewSpecWithStart:params.left
                                                      end:params.right
                                              subviewSize:params.width
                                              startMargin:params.margins.left
                                                endMargin:params.margins.right
                                             startPadding:self.padding.left
                                               endPadding:self.padding.right
                                                  ownSize:maxOwnSize.width];

    GRXMeasureSpec heightSpec = [self subviewSpecWithStart:params.top
                                                       end:params.bottom
                                               subviewSize:params.height
                                               startMargin:params.margins.top
                                                 endMargin:params.margins.bottom
                                              startPadding:self.padding.top
                                                endPadding:self.padding.bottom
                                                   ownSize:maxOwnSize.height];

    CGSize subviewSize = [subview grx_measuredSizeForWidthSpec:widthSpec
                                                    heightSpec:heightSpec];
    return subviewSize;
}

- (CGSize)measureSubviewHorizontal:(UIView *)subview
                            params:(GRXRelativeLayoutParams *)subviewParams
                        maxOwnSize:(CGSize)maxOwnSize {
    GRXMeasureSpec widthSpec = [self subviewSpecWithStart:subviewParams.left
                                                      end:subviewParams.right
                                              subviewSize:subviewParams.width
                                              startMargin:subviewParams.margins.left
                                                endMargin:subviewParams.margins.right
                                             startPadding:self.padding.left
                                               endPadding:self.padding.right
                                                  ownSize:maxOwnSize.width];
    GRXMeasureSpec heightSpec;
    if (subviewParams.width == GRXMatchParent) {
        heightSpec = GRXMeasureSpecMake(maxOwnSize.height, GRXMeasureSpecExactly);
    } else {
        heightSpec = GRXMeasureSpecMake(maxOwnSize.height, GRXMeasureSpecAtMost);
    }
    // stores already measured size for these specs in subview
    CGSize subviewSize = [subview grx_measuredSizeForWidthSpec:widthSpec
                                                    heightSpec:heightSpec];
    return subviewSize;
}

- (BOOL)positionSubviewHorizontal:(UIView *)subview
                           params:(GRXRelativeLayoutParams *)subviewParams
                      maxOwnWidth:(CGFloat)ownWidth
                      wrapContent:(BOOL)wrapContent {
    CGSize measuredSize = subview.grx_measuredSize;

    if (subviewParams.left < 0 && subviewParams.right >= 0) {
        // Right is fixed, but left varies
        subviewParams.left = subviewParams.right - measuredSize.width;
    } else if (subviewParams.left >= 0 && subviewParams.right < 0) {
        // Left is fixed, but right varies
        subviewParams.right = subviewParams.left + measuredSize.width;
    } else if (subviewParams.left < 0 && subviewParams.right < 0) {
        // Both left and right vary
        if ([subviewParams hasParentRule:GRXRelativeLayoutParentRuleCenter] ||
            [subviewParams hasParentRule:GRXRelativeLayoutParentRuleCenterHorizontal]) {
            if (!wrapContent) {
                centerHorizontal(subviewParams, measuredSize.width, ownWidth);
            } else {
                subviewParams.left = self.padding.left + subviewParams.margins.left;
                subviewParams.right = subviewParams.left + measuredSize.width;
            }
            return YES;
        } else {
            subviewParams.left = self.padding.left + subviewParams.margins.left;
            subviewParams.right = subviewParams.left + measuredSize.width;
        }
    }
    return NO;
}

- (BOOL)positionSubviewVertical:(UIView *)subview
                         params:(GRXRelativeLayoutParams *)subviewParams
                   maxOwnHeight:(CGFloat)ownHeight
                    wrapContent:(BOOL)wrapContent {
    CGSize measuredSize = subview.grx_measuredSize;

    if (subviewParams.top < 0 && subviewParams.bottom >= 0) {
        // Bottom is fixed, but top varies
        subviewParams.top = subviewParams.bottom - measuredSize.height;
    } else if (subviewParams.top >= 0 && subviewParams.bottom < 0) {
        // Top is fixed, but bottom varies
        subviewParams.bottom = subviewParams.top + measuredSize.height;
    } else if (subviewParams.top < 0 && subviewParams.bottom < 0) {
        // Both top and bottom vary
        if ([subviewParams hasParentRule:GRXRelativeLayoutParentRuleCenter] ||
            [subviewParams hasParentRule:GRXRelativeLayoutParentRuleCenterVertical]) {
            if (!wrapContent) {
                centerVertical(subviewParams, measuredSize.height, ownHeight);
            } else {
                subviewParams.top = self.padding.top + subviewParams.margins.top;
                subviewParams.bottom = subviewParams.top + measuredSize.height;
            }
            return YES;
        } else {
            subviewParams.top = self.padding.top + subviewParams.margins.top;
            subviewParams.bottom = subviewParams.top + measuredSize.height;
        }
    }
    return NO;
}

CG_INLINE void centerHorizontal(GRXRelativeLayoutParams *viewParams, CGFloat viewWidth, CGFloat ownWidth) {
    CGFloat left = (ownWidth - viewWidth) / 2;

    viewParams.left = left;
    viewParams.right = left + viewWidth;
}

CG_INLINE void centerVertical(GRXRelativeLayoutParams *viewParams, CGFloat viewHeight, CGFloat ownHeight) {
    CGFloat top = (ownHeight - viewHeight) / 2;

    viewParams.top = top;
    viewParams.bottom = top + viewHeight;
}
@end

NS_ASSUME_NONNULL_END
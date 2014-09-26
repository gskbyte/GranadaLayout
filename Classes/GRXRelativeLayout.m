#import "GRXRelativeLayout.h"
#import "GRXDependencyGraph.h"
#import "GRXLayout+Protected.h"

@interface GRXRelativeLayout ()

@property (nonatomic) BOOL dirtyHierarchy;
@property (nonatomic, retain) NSArray *sortedViewsVertical, *sortedViewsHorizontal;
@property (nonatomic) GRXDependencyGraph *dependencyGraph;

@end

@implementation GRXRelativeLayout

+ (Class)layoutParamsClass {
    return GRXRelativeLayoutParams.class;
}

#pragma mark - Initializiation

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupPrivate];
    }
    return self;
}

- (void)setupPrivate {
    _sortedViewsVertical = [NSMutableArray array];
    _sortedViewsHorizontal = [NSMutableArray array];
    _dependencyGraph = [[GRXDependencyGraph alloc] init];
}

#pragma mark - Overriden methods

- (void)addSubview:(UIView *)view {
    [super addSubview:view];
    _dirtyHierarchy = YES;
}

- (void)setNeedsLayout {
    [super setNeedsLayout];
    _dirtyHierarchy = YES; // should be called somewhere else, doesn't always need to be called
}

- (void)sortChildren {
    [self.dependencyGraph clear];
    for (UIView *view in self.subviews) {
        [self.dependencyGraph add:view];
    }

    self.sortedViewsVertical = [self.dependencyGraph sortedViewsWithRules:[GRXRelativeLayoutParams verticalRules]];
    self.sortedViewsHorizontal = [self.dependencyGraph sortedViewsWithRules:[GRXRelativeLayoutParams horizontalRules]];
}

- (CGSize)grx_measureForWidthSpec:(GRXMeasureSpec)widthSpec
                       heightSpec:(GRXMeasureSpec)heightSpec {
    if (_dirtyHierarchy) {
        [self sortChildren];
        _dirtyHierarchy = NO;
    }

    CGFloat ownWidth = -1, ownHeight = -1;
    CGSize measuredSize;

    // set own dimensions if they are known
    if (widthSpec.mode != GRXMeasureSpecUnspecified) {
        ownWidth = widthSpec.value;
    }
    if (heightSpec.mode != GRXMeasureSpecUnspecified) {
        ownHeight = heightSpec.value;
    }
    if (widthSpec.mode == GRXMeasureSpecExactly) {
        measuredSize.width = ownWidth;
    }
    if (heightSpec.mode == GRXMeasureSpecExactly) {
        measuredSize.height = ownHeight;
    }

    BOOL offsetHorizontalAxis = NO;
    BOOL offsetVerticalAxis = NO;

    const BOOL isWrapContentWidth = widthSpec.mode != GRXMeasureSpecExactly;
    const BOOL isWrapContentHeight = heightSpec.mode != GRXMeasureSpecExactly;

    for (UIView *view in self.sortedViewsHorizontal) {
        if (view.grx_visibility == GRXViewVisibilityGone) {
            continue;
        }

        [self applyHorizontalSizeRulesToChildView:view ownWidth:ownWidth];
        [self measureChildHorizontal:view ownWidth:ownWidth ownHeight:ownHeight];

        if ( [self positionChildHorizontal:view ownWidth:ownWidth wrapContent:isWrapContentWidth] ) {
            offsetHorizontalAxis = YES;
        }
    }

    for (UIView *view in self.sortedViewsVertical) {
        if (view.grx_visibility == GRXViewVisibilityGone) {
            continue;
        }

        [self applyVerticalSizeRulesToChildView:view ownHeight:ownHeight];
        [self measureChild:view ownWidth:ownWidth ownHeight:ownHeight];
        if ( [self positionChildVertical:view ownHeight:ownHeight wrapContent:isWrapContentHeight] ) {
            offsetVerticalAxis = YES;
        }

        GRXRelativeLayoutParams *params = view.grx_relativeLayoutParams;
        if (isWrapContentWidth) {
            measuredSize.width = MAX(measuredSize.width, params.right);
        }

        if (isWrapContentHeight) {
            measuredSize.height = MAX(measuredSize.width, params.bottom);
        }
    }

    GRXLayoutParams *ownParams = self.grx_layoutParams;
    CGSize ownSuggestedMinSize = [self grx_suggestedMinimumSize];

    if (isWrapContentWidth) {
        // Width already has left padding in it since it was calculated by looking at
        // the right of each child view
        measuredSize.width += self.padding.right;

        if (ownParams.width >= 0) {
            measuredSize.width = MAX(measuredSize.width, ownParams.width);
        }

        measuredSize.width = MAX(measuredSize.width, ownSuggestedMinSize.width);
        measuredSize.width = GRXMeasureSpecResolveSizeValue(measuredSize.width, widthSpec);

        if (offsetHorizontalAxis) {
            for (UIView *view in self.subviews) {
                if (view.grx_visibility == GRXViewVisibilityGone) {
                    continue;
                }

                GRXRelativeLayoutParams *params = view.grx_relativeLayoutParams;
                if ([params hasParentRule:GRXRelativeLayoutParentRuleCenter] ||
                    [params hasParentRule:GRXRelativeLayoutParentRuleCenterHorizontal]) {
                    centerHorizontal(params, view.grx_measuredSize.width, ownWidth);
                }
            }
        }
    }

    if (isWrapContentHeight) {
        // Height already has top padding in it since it was calculated by looking at
        // the bottom of each child view
        measuredSize.height += self.padding.bottom;

        if (ownParams.height >= 0) {
            measuredSize.height = MAX(measuredSize.height, ownParams.height);
        }

        measuredSize.height = MAX(measuredSize.height, ownSuggestedMinSize.height);
        measuredSize.height = GRXMeasureSpecResolveSizeValue(measuredSize.height, heightSpec);

        if (offsetVerticalAxis) {
            for (UIView *view in self.subviews) {
                if (view.grx_visibility == GRXViewVisibilityGone) {
                    continue;
                }
                GRXRelativeLayoutParams *params = view.grx_relativeLayoutParams;
                if ([params hasParentRule:GRXRelativeLayoutParentRuleCenter] ||
                    [params hasParentRule:GRXRelativeLayoutParentRuleCenterVertical]) {
                    centerVertical(params, view.grx_measuredSize.height, ownHeight);
                }
            }
        }
    }

    for (UIView *view in self.subviews) {
        GRXRelativeLayoutParams *params = view.grx_relativeLayoutParams;
        view.frame = params.rect;
    }

    return measuredSize;
}

- (GRXRelativeLayoutParams *)relatedViewParamsForViewParams:(GRXRelativeLayoutParams *)layoutParams
                                                   relation:(GRXRelativeLayoutRule)relation {
    UIView *relatedView = [self relatedViewForViewParams:layoutParams
                                                relation:relation];
    return relatedView.grx_relativeLayoutParams;
}

- (UIView *)relatedViewForViewParams:(GRXRelativeLayoutParams *)layoutParams
                            relation:(GRXRelativeLayoutRule)relation {
    UIView *view = [layoutParams viewForRule:relation];
    if (view) {
        GRXDependencyNode *node = self.dependencyGraph.nodes[view.grx_layoutId];
        if (node == nil) {
            return nil;
        }

        // find the first non-gone view up the chain
        while (view.grx_visibility == GRXViewVisibilityGone) {
            layoutParams = view.grx_relativeLayoutParams;
            view = [layoutParams viewForRule:relation];
            node = self.dependencyGraph.nodes[view.grx_layoutId];
            if (node == nil) {
                return nil;
            }
        }

        return view;
    }

    return nil;
}

- (void)applyHorizontalSizeRulesToChildView:(UIView *)view
                                   ownWidth:(CGFloat)ownWidth {
    GRXRelativeLayoutParams *childParams = view.grx_relativeLayoutParams;
    // -1 indicates a "soft requirement" in that direction. For example:
    // left=10, right=-1 means the view must start at 10, but can go as far as it wants to the right
    // left =-1, right=10 means the view must end at 10, but can go as far as it wants to the left
    // left=10, right=20 means the left and right ends are both fixed
    childParams.left = -1;
    childParams.right = -1;

    // Adjust rules relative to other views
    GRXRelativeLayoutParams *anchorParams = [self relatedViewParamsForViewParams:childParams
                                                                        relation:GRXRelativeLayoutRuleLeftOf];
    if (anchorParams != nil) {
        childParams.right = anchorParams.left - (anchorParams.margins.left + childParams.margins.right);
    }

    anchorParams = [self relatedViewParamsForViewParams:childParams
                                               relation:GRXRelativeLayoutRuleRightOf];
    if (anchorParams != nil) {
        childParams.left = anchorParams.right + (anchorParams.margins.right + childParams.margins.left);
    }

    anchorParams = [self relatedViewParamsForViewParams:childParams
                                               relation:GRXRelativeLayoutRuleAlignLeft];
    if (anchorParams != nil) {
        childParams.left = anchorParams.left + childParams.margins.left;
    }

    anchorParams = [self relatedViewParamsForViewParams:childParams
                                               relation:GRXRelativeLayoutRuleAlignRight];
    if (anchorParams != nil) {
        childParams.right = anchorParams.right - childParams.margins.right;
    }

    // Adjust parent rules
    if ([childParams hasParentRule:GRXRelativeLayoutParentRuleAlignLeft]) {
        childParams.left = self.padding.left + childParams.margins.left;
    }

    if ([childParams hasParentRule:GRXRelativeLayoutParentRuleAlignRight]) {
        childParams.right = ownWidth - self.padding.right - childParams.margins.right;
    }
}

- (void)applyVerticalSizeRulesToChildView:(UIView *)view
                                ownHeight:(CGFloat)ownHeight {
    GRXRelativeLayoutParams *childParams = view.grx_relativeLayoutParams;
    childParams.top = -1;
    childParams.bottom = -1;

    // Adjust rules relative to other views
    GRXRelativeLayoutParams *anchorParams = [self relatedViewParamsForViewParams:childParams
                                                                        relation:GRXRelativeLayoutRuleAbove];
    if (anchorParams != nil) {
        childParams.bottom = anchorParams.top - (anchorParams.margins.top + childParams.margins.bottom);
    }

    anchorParams = [self relatedViewParamsForViewParams:childParams
                                               relation:GRXRelativeLayoutRuleBelow];
    if (anchorParams != nil) {
        childParams.top = anchorParams.bottom + (anchorParams.margins.bottom + childParams.margins.top);
    }

    anchorParams = [self relatedViewParamsForViewParams:childParams
                                               relation:GRXRelativeLayoutRuleAlignTop];
    if (anchorParams != nil) {
        childParams.top = anchorParams.top + childParams.margins.top;
    }

    anchorParams = [self relatedViewParamsForViewParams:childParams
                                               relation:GRXRelativeLayoutRuleAlignBottom];
    if (anchorParams != nil) {
        childParams.bottom = anchorParams.bottom - childParams.margins.bottom;
    }

    // Adjust parent rules
    if ([childParams hasParentRule:GRXRelativeLayoutParentRuleAlignTop]) {
        childParams.top = self.padding.top + childParams.margins.top;
    }

    if ([childParams hasParentRule:GRXRelativeLayoutParentRuleAlignBottom]) {
        childParams.bottom = ownHeight - self.padding.bottom - childParams.margins.bottom;
    }
}

- (CGSize)measureChild:(UIView *)child
              ownWidth:(CGFloat)ownWidth
             ownHeight:(CGFloat)ownHeight {
    GRXRelativeLayoutParams *params = child.grx_relativeLayoutParams;
    GRXMeasureSpec widthSpec = [self childSpecWithStart:params.left
                                                       end:params.right
                                                 childSize:params.width
                                               startMargin:params.margins.left
                                                 endMargin:params.margins.right
                                              startPadding:self.padding.left
                                                endPadding:self.padding.right
                                                   ownSize:ownWidth];

    GRXMeasureSpec heightSpec = [self childSpecWithStart:params.top
                                                        end:params.bottom
                                                  childSize:params.height
                                                startMargin:params.margins.top
                                                  endMargin:params.margins.bottom
                                               startPadding:self.padding.top
                                                 endPadding:self.padding.bottom
                                                    ownSize:ownHeight];

    CGSize childSize = [child grx_measuredSizeForWidthSpec:widthSpec
                                                heightSpec:heightSpec];
    return childSize;
}

- (CGSize)measureChildHorizontal:(UIView *)child
                        ownWidth:(CGFloat)ownWidth
                       ownHeight:(CGFloat)ownHeight {
    GRXRelativeLayoutParams *params = child.grx_relativeLayoutParams;
    GRXMeasureSpec widthSpec = [self childSpecWithStart:params.left
                                                       end:params.right
                                                 childSize:params.width
                                               startMargin:params.margins.left
                                                 endMargin:params.margins.right
                                              startPadding:self.padding.left
                                                endPadding:self.padding.right
                                                   ownSize:ownWidth];
    GRXMeasureSpec heightSpec;
    if (params.width == GRXMatchParent) {
        heightSpec = GRXMeasureSpecMake(ownHeight, GRXMeasureSpecExactly);
    } else {
        heightSpec = GRXMeasureSpecMake(ownHeight, GRXMeasureSpecAtMost);
    }
    CGSize childSize = [child grx_measuredSizeForWidthSpec:widthSpec
                                                heightSpec:heightSpec];
    return childSize;
}

- (BOOL)positionChildHorizontal:(UIView *)view
                       ownWidth:(CGFloat)ownWidth
                    wrapContent:(BOOL)wrapContent {
    GRXRelativeLayoutParams *params = view.grx_relativeLayoutParams;
    CGSize measuredSize = view.grx_measuredSize;

    if (params.left < 0 && params.right >= 0) {
        // Right is fixed, but left varies
        params.left = params.right - measuredSize.width;
    } else if (params.left >= 0 && params.right < 0) {
        // Left is fixed, but right varies
        params.right = params.left + measuredSize.width;
    } else if (params.left < 0 && params.right < 0) {
        // Both left and right vary
        if ([params hasParentRule:GRXRelativeLayoutParentRuleCenter] ||
            [params hasParentRule:GRXRelativeLayoutParentRuleCenterHorizontal]) {
            if (!wrapContent) {
                centerHorizontal(params, measuredSize.width, ownWidth);
            } else {
                params.left = self.padding.left + params.margins.left;
                params.right = params.left + measuredSize.width;
            }
            return YES;
        } else {
            params.left = self.padding.left + params.margins.left;
            params.right = params.left + measuredSize.width;
        }
    }
    return NO;
}

- (BOOL)positionChildVertical:(UIView *)view
                    ownHeight:(CGFloat)ownHeight
                  wrapContent:(BOOL)wrapContent {
    GRXRelativeLayoutParams *params = view.grx_relativeLayoutParams;
    CGSize measuredSize = view.grx_measuredSize;

    if (params.top < 0 && params.bottom >= 0) {
        // Bottom is fixed, but top varies
        params.top = params.bottom - measuredSize.height;
    } else if (params.top >= 0 && params.bottom < 0) {
        // Top is fixed, but bottom varies
        params.bottom = params.top + measuredSize.height;
    } else if (params.top < 0 && params.bottom < 0) {
        // Both top and bottom vary
        if ([params hasParentRule:GRXRelativeLayoutParentRuleCenter] ||
            [params hasParentRule:GRXRelativeLayoutParentRuleCenterVertical]) {
            if (!wrapContent) {
                centerVertical(params, measuredSize.height, ownHeight);
            } else {
                params.top = self.padding.top + params.margins.top;
                params.bottom = params.top + measuredSize.height;
            }
            return YES;
        } else {
            params.top = self.padding.top + params.margins.top;
            params.bottom = params.top + measuredSize.height;
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

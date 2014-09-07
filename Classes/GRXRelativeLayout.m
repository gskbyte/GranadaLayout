#import "GRXRelativeLayout.h"
#import "GRXDependencyGraph.h"
#import "GRXRelativeLayoutParams_Protected.h"

@interface GRXRelativeLayout ()

@property (nonatomic) BOOL dirtyHierarchy;
@property (nonatomic, retain) NSArray * sortedViewsVertical, *sortedViewsHorizontal;
@property (nonatomic) GRXDependencyGraph * dependencyGraph;

@end

@implementation GRXRelativeLayout

+ (Class) layoutParamsClass {
    return GRXRelativeLayoutParams.class;
}

#pragma mark - Initializiation

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self setupPrivate];
    }
    return self;
}

- (void) setupPrivate {
    _sortedViewsVertical = [NSMutableArray array];
    _sortedViewsHorizontal = [NSMutableArray array];
    _dependencyGraph = [[GRXDependencyGraph alloc] init];
}

#pragma mark - Overriden methods

- (void)addSubview:(UIView *)view {
    [super addSubview:view];
    _dirtyHierarchy = YES;
}

// TODO optimize this
+ (void) centerHorizontalView:(UIView *)view
                       params:(GRXRelativeLayoutParams *)params
                      myWidth:(CGFloat)myWidth {
    CGFloat childWidth = view.grx_measuredSize.width;
    CGFloat left = (myWidth - childWidth) / 2;

    params.left = left;
    params.right = left + childWidth;
}

+ (void) centerVerticalView:(UIView *)child
                     params:(GRXRelativeLayoutParams *)params
                   myHeight:(CGFloat)myHeight {
    CGFloat childHeight = child.grx_measuredSize.height;
    CGFloat top = (myHeight - childHeight) / 2;

    params.top = top;
    params.bottom = top + childHeight;
}

- (void) sortChildren {
    [self.dependencyGraph clear];
    for(UIView * view in self.subviews) {
        [self.dependencyGraph add:view];
    }

    self.sortedViewsVertical = [self.dependencyGraph sortedViewsWithRules:[GRXRelativeLayoutParams verticalRules]];
    //[self.class debugViewArray:self.sortedViewsVertical title:@"Vertical"];

    self.sortedViewsHorizontal = [self.dependencyGraph sortedViewsWithRules:[GRXRelativeLayoutParams horizontalRules]];
    //[self.class debugViewArray:self.sortedViewsHorizontal title:@"Horizontal"];
}


+ (void) debugViewArray:(NSArray*)array title:(NSString*)title {
    NSLog(@"%@", title);
    [self.class debugViewArray:array];
}

+ (void) debugViewArray:(NSArray*)array {
    for(UIView *view in array) {
        NSString * viewName = view.accessibilityLabel ? view.accessibilityLabel : @"Unnamed";
        NSLog(@"  %@ : %@", viewName, view.description);
    }
    NSLog(@"");
}

- (void) layoutSubviews {
    [super layoutSubviews];

}

- (CGSize) grx_measureWithSpec:(GRXMeasureSpec)spec {
    if(_dirtyHierarchy) {
        [self sortChildren];
        _dirtyHierarchy = NO;
    }

    CGFloat myWidth = -1, myHeight = -1;
    CGSize measuredSize;

    // Record our dimensions if they are known:
    if (spec.widthMode != GRXMeasureSpecUnspecified) {
        myWidth = spec.width;
    }
    if (spec.heightMode != GRXMeasureSpecUnspecified) {
        myHeight = spec.height;
    }
    if (spec.widthMode == GRXMeasureSpecExactly) {
        measuredSize.width = myWidth;
    }
    if (spec.heightMode == GRXMeasureSpecExactly) {
        measuredSize.height = myHeight;
    }

    BOOL offsetHorizontalAxis = NO;
    BOOL offsetVerticalAxis = NO;

    const BOOL isWrapContentWidth = spec.widthMode != GRXMeasureSpecExactly;
    const BOOL isWrapContentHeight = spec.heightMode != GRXMeasureSpecExactly;

    for(UIView * view in self.sortedViewsHorizontal) {
        if(view.grx_visibility == GRXViewVisibilityGone) {
            continue;
        }

        [self applyHorizontalSizeRulesToChildView:view ownWidth:myWidth];
        [self measureChildHorizontal:view ownWidth:myWidth ownHeight:myHeight];
        [self positionChildHorizontal:view ownWidth:myWidth wrapContent:isWrapContentWidth];

        offsetHorizontalAxis = [self positionChildHorizontal:view ownWidth:myWidth wrapContent:isWrapContentWidth];
    }

    for(UIView * view in self.sortedViewsVertical) {
        if(view.grx_visibility == GRXViewVisibilityGone) {
            continue;
        }

        [self applyVerticalSizeRulesToChildView:view ownHeight:myHeight];
        [self measureChild:view ownWidth:myWidth ownHeight:myHeight];
        offsetVerticalAxis = [self positionChildVertical:view ownHeight:myHeight wrapContent:isWrapContentHeight];

        GRXRelativeLayoutParams * params = view.grx_relativeLayoutParams;
        if (isWrapContentWidth) {
            measuredSize.width = MAX(measuredSize.width, params.right);
        }

        if (isWrapContentHeight) {
            measuredSize.height = MAX(measuredSize.width, params.bottom);
        }
//
//        if (child != ignore || verticalGravity) {
//            left = Math.min(left, params.left - params.leftMargin);
//            top = Math.min(top, params.top - params.topMargin);
//        }
//
//        if (child != ignore || horizontalGravity) {
//            right = Math.max(right, params.right + params.rightMargin);
//            bottom = Math.max(bottom, params.bottom + params.bottomMargin);
//        }
    }

    GRXRelativeLayoutParams * ownParams = self.grx_relativeLayoutParams;
    CGSize ownSuggestedMinSize = [self grx_suggestedMinimumSize];

    if (isWrapContentWidth) {
        // Width already has left padding in it since it was calculated by looking at
        // the right of each child view
        measuredSize.width += self.padding.right;
/*
        if (ownParams.width >= 0) {
            measuredSize.width = MAX(measuredSize.width, ownParams.width);
        }

        measuredSize.width = MAX(measuredSize.width, ownSuggestedMinSize.width);
        measuredSize.width = resolveSize(measuredSize.width, widthMeasureSpec);

        if (offsetHorizontalAxis) {
            for (int i = 0; i < count; i++) {
                View child = getChildAt(i);
                if (child.getVisibility() != GONE) {
                    LayoutParams params = (LayoutParams) child.getLayoutParams();
                    final int[] rules = params.getRules();
                    if (rules[CENTER_IN_PARENT] != 0 || rules[CENTER_HORIZONTAL] != 0) {
                        centerHorizontal(child, params, width);
                    }
                }
            }
        }*/
    }

    if (isWrapContentHeight) {
//        // Height already has top padding in it since it was calculated by looking at
//        // the bottom of each child view
//        height += mPaddingBottom;
//
//        if (mLayoutParams.height >= 0) {
//            height = Math.max(height, mLayoutParams.height);
//        }
//
//        height = Math.max(height, getSuggestedMinimumHeight());
//        height = resolveSize(height, heightMeasureSpec);
//
//        if (offsetVerticalAxis) {
//            for (int i = 0; i < count; i++) {
//                View child = getChildAt(i);
//                if (child.getVisibility() != GONE) {
//                    LayoutParams params = (LayoutParams) child.getLayoutParams();
//                    final int[] rules = params.getRules();
//                    if (rules[CENTER_IN_PARENT] != 0 || rules[CENTER_VERTICAL] != 0) {
//                        centerVertical(child, params, height);
//                    }
//                }
//            }
//        }
    }


    return measuredSize;
}

- (GRXRelativeLayoutParams *)relatedViewParamsForRules:(NSArray*)rules
                                              relation:(GRXRelativeLayoutRule)relation {
    UIView * relatedView = [self relatedViewForRules:rules relation:relation];
    return relatedView.grx_relativeLayoutParams;
}

- (UIView *)relatedViewForRules:(NSArray*)rules
                       relation:(GRXRelativeLayoutRule)relation {
    UIView * view = rules[relation];
    if(view) {
        GRXDependencyNode *node = self.dependencyGraph.nodes[view.grx_layoutId];
        if(node == nil) {
            return nil;
        }

        // find the first non-gone view up the chain
        while (view.grx_visibility == GRXViewVisibilityGone) {
            rules = view.grx_relativeLayoutParams.rules;
            view = rules[relation];
            node = self.dependencyGraph.nodes[view.grx_layoutId];
            if(node == nil) {
                return nil;
            }
        }

        return view;
    }

    return nil;
}

- (void)applyHorizontalSizeRulesToChildView:(UIView*)view
                                   ownWidth:(CGFloat)ownWidth {
    GRXRelativeLayoutParams * childParams = view.grx_relativeLayoutParams;
    // -1 indicates a "soft requirement" in that direction. For example:
    // left=10, right=-1 means the view must start at 10, but can go as far as it wants to the right
    // left =-1, right=10 means the view must end at 10, but can go as far as it wants to the left
    // left=10, right=20 means the left and right ends are both fixed
    childParams.left = -1;
    childParams.right = -1;

    // Adjust rules relative to other views
    GRXRelativeLayoutParams *anchorParams = [self relatedViewParamsForRules:childParams.rules
                                                                   relation:GRXRelativeLayoutRuleLeftOf];
    if(anchorParams != nil) {
        childParams.right = anchorParams.left - (anchorParams.margins.left + childParams.margins.right);
    }

    anchorParams = [self relatedViewParamsForRules:childParams.rules
                                          relation:GRXRelativeLayoutRuleRightOf];
    if(anchorParams != nil) {
        childParams.left = anchorParams.right + (anchorParams.margins.right + childParams.margins.left);
    }

    anchorParams = [self relatedViewParamsForRules:childParams.rules
                                          relation:GRXRelativeLayoutRuleAlignLeft];
    if(anchorParams != nil) {
        childParams.left = anchorParams.left + childParams.margins.left;
    }

    anchorParams = [self relatedViewParamsForRules:childParams.rules
                                          relation:GRXRelativeLayoutRuleAlignRight];
    if(anchorParams != nil) {
        childParams.right = anchorParams.right - childParams.margins.right;
    }

    // Adjust parent rules
    if([childParams hasParentRule:GRXRelativeLayoutParentRuleAlignLeft]) {
        childParams.left = self.padding.left + childParams.margins.left;
    }

    if([childParams hasParentRule:GRXRelativeLayoutParentRuleAlignRight]) {
        childParams.right = ownWidth - self.padding.right - childParams.margins.right;
    }
}

- (void)applyVerticalSizeRulesToChildView:(UIView*)view
                                ownHeight:(CGFloat)ownHeight {
    GRXRelativeLayoutParams * childParams = view.grx_relativeLayoutParams;
    childParams.top = -1;
    childParams.bottom = -1;

    // Adjust rules relative to other views
    GRXRelativeLayoutParams * anchorParams = [self relatedViewParamsForRules:childParams.rules
                                                                    relation:GRXRelativeLayoutRuleAbove];
    if(anchorParams != nil) {
        childParams.bottom = anchorParams.top - (anchorParams.margins.top + childParams.margins.bottom);
    }

    anchorParams = [self relatedViewParamsForRules:childParams.rules
                                          relation:GRXRelativeLayoutRuleBelow];
    if(anchorParams != nil) {
        childParams.top = anchorParams.bottom + (anchorParams.margins.bottom + childParams.margins.top);
    }

    anchorParams = [self relatedViewParamsForRules:childParams.rules
                                          relation:GRXRelativeLayoutRuleAlignTop];
    if(anchorParams != nil) {
        childParams.top = anchorParams.top + childParams.margins.top;
    }

    anchorParams = [self relatedViewParamsForRules:childParams.rules
                                          relation:GRXRelativeLayoutRuleAlignBottom];
    if(anchorParams != nil) {
        childParams.bottom = anchorParams.bottom - childParams.margins.bottom;
    }

    // Adjust parent rules
    if([childParams hasParentRule:GRXRelativeLayoutParentRuleAlignTop]) {
        childParams.top = self.padding.top + childParams.margins.top;
    }

    if([childParams hasParentRule:GRXRelativeLayoutParentRuleAlignBottom]) {
        childParams.bottom = ownHeight - self.padding.bottom - childParams.margins.bottom;
    }
}

- (void)measureChild:(UIView*)child
            ownWidth:(CGFloat)ownWidth
           ownHeight:(CGFloat)ownHeight {
    GRXRelativeLayoutParams * params = child.grx_relativeLayoutParams;
    GRXPartialMeasureSpec widthSpec = getChildMeasureSpec(params.left, params.right, params.width,
                                                          params.margins.left, params.margins.right,
                                                          self.padding.left, self.padding.right,
                                                          ownWidth);
    GRXPartialMeasureSpec heightSpec = getChildMeasureSpec(params.top, params.bottom, params.height,
                                                           params.margins.top, params.margins.bottom,
                                                           self.padding.top, self.padding.bottom,
                                                           ownHeight);
    CGSize childSize = [child grx_measuredSizeForSpec:GRXMeasureSpecMakeFromPartial(widthSpec, heightSpec)];
    #pragma unused(childSize)
}

- (void) measureChildHorizontal:(UIView*)child
                       ownWidth:(CGFloat)ownWidth
                      ownHeight:(CGFloat)ownHeight {
    GRXRelativeLayoutParams * params = child.grx_relativeLayoutParams;
    GRXPartialMeasureSpec widthSpec = getChildMeasureSpec(params.left, params.right, params.width,
                                                          params.margins.left, params.margins.right,
                                                          self.padding.left, self.padding.right,
                                                          ownWidth);
    GRXPartialMeasureSpec heightSpec;
    if(params.width == GRXMatchParent) {
        heightSpec = GRXPartialMeasureSpecMake(ownHeight, GRXMeasureSpecExactly);
    } else {
        heightSpec = GRXPartialMeasureSpecMake(ownHeight, GRXMeasureSpecAtMost);
    }
    CGSize childSize = [child grx_measuredSizeForSpec:GRXMeasureSpecMakeFromPartial(widthSpec, heightSpec)];
    #pragma unused(childSize)
}

- (BOOL) positionChildHorizontal:(UIView *)view
                        ownWidth:(CGFloat)ownWidth
                     wrapContent:(BOOL)wrapContent {
    GRXRelativeLayoutParams * params = view.grx_relativeLayoutParams;
    CGSize measuredSize = view.grx_measuredSize;

    if (params.left < 0 && params.right >= 0) {
        // Right is fixed, but left varies
        params.left = params.right - measuredSize.width;
    } else if (params.left >= 0 && params.right < 0) {
        // Left is fixed, but right varies
        params.right = params.left + measuredSize.width;
    } else if (params.left < 0 && params.right < 0) {
        // Both left and right vary
        if([params hasParentRule:GRXRelativeLayoutParentRuleCenter] ||
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

- (BOOL) positionChildVertical:(UIView *)view
                     ownHeight:(CGFloat)ownHeight
                   wrapContent:(BOOL)wrapContent {
    GRXRelativeLayoutParams * params = view.grx_relativeLayoutParams;
    CGSize measuredSize = view.grx_measuredSize;

    if (params.top < 0 && params.bottom >= 0) {
        // Bottom is fixed, but top varies
        params.top = params.bottom - measuredSize.height;
    } else if (params.top >= 0 && params.bottom < 0) {
        // Top is fixed, but bottom varies
        params.bottom = params.top + measuredSize.height;
    } else if (params.top < 0 && params.bottom < 0) {
        // Both top and bottom vary
        if([params hasParentRule:GRXRelativeLayoutParentRuleCenter] ||
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


GRXPartialMeasureSpec getChildMeasureSpec(CGFloat childStart, CGFloat childEnd,
                        CGFloat childSize, CGFloat startMargin, CGFloat endMargin, CGFloat startPadding,
                        CGFloat endPadding, CGFloat mySize) {
    GRXPartialMeasureSpec partialSpec;
    partialSpec.value = 0;
    partialSpec.mode = GRXMeasureSpecUnspecified;

    CGFloat tempStart = childStart;
    CGFloat tempEnd = childEnd;

    // If the view did not express a layout constraint for an edge, use
    // view's margins and our padding
    if(tempStart < 0) {
        tempStart = startPadding + startMargin;
    }
    if (tempEnd < 0) {
        tempEnd = mySize - endPadding - endMargin;
    }

    // Figure out maximum size available to this view
    CGFloat maxAvailable = tempEnd - tempStart;

    if (childStart >= 0 && childEnd >= 0) {
        // Constraints fixed both edges, so child must be an exact size
        partialSpec.mode = GRXMeasureSpecExactly;
        partialSpec.value = maxAvailable;
    } else {
        if (childSize >= 0) {
            // Child wanted an exact size. Give as much as possible
            partialSpec.mode = GRXMeasureSpecExactly;

            if (maxAvailable >= 0) {
                // We have a maxmum size in this dimension.
                partialSpec.value = MIN(maxAvailable, childSize);
            } else {
                // We can grow in this dimension.
                partialSpec.value = childSize;
            }
        } else if (childSize == GRXMatchParent) {
            // Child wanted to be as big as possible. Give all availble
            // space
            partialSpec.mode = GRXMeasureSpecExactly;
            partialSpec.value = maxAvailable;
        } else if (childSize == GRXWrapContent) {
            // Child wants to wrap content. Use AT_MOST
            // to communicate available space if we know
            // our max size
            if (maxAvailable >= 0) {
                // We have a maxmum size in this dimension.
                partialSpec.mode = GRXMeasureSpecAtMost;
                partialSpec.value = maxAvailable;
            } else {
                // We can grow in this dimension. Child can be as big as it
                // wants
                partialSpec.mode = GRXMeasureSpecUnspecified;
                partialSpec.value = 0;
            }
        }
    }

    return partialSpec;
}

@end

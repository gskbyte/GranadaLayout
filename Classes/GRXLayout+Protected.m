#import "GRXLayout+Protected.h"

@implementation GRXLayout (Protected)


- (GRXMeasureSpec)childSpecWithParentSpec:(GRXMeasureSpec)spec
                                  padding:(CGFloat)padding
                           childDimension:(CGFloat)childDimension {
    CGFloat size = MAX(0, spec.value - padding);

    CGFloat resultSize = 0;
    GRXMeasureSpecMode resultMode = 0;

    switch (spec.mode) {
        // Parent has imposed an exact size on us
        case GRXMeasureSpecExactly:
            if (childDimension >= 0) {
                resultSize = childDimension;
                resultMode = GRXMeasureSpecExactly;
            } else if (childDimension == GRXMatchParent) {
                // Child wants to be our size. So be it.
                resultSize = size;
                resultMode = GRXMeasureSpecExactly;
            } else if (childDimension == GRXWrapContent) {
                // Child wants to determine its own size. It can't be
                // bigger than us.
                resultSize = size;
                resultMode = GRXMeasureSpecAtMost;
            }
            break;

        // Parent has imposed a maximum size on us
        case GRXMeasureSpecAtMost:
            if (childDimension >= 0) {
                // Child wants a specific size... so be it
                resultSize = childDimension;
                resultMode = GRXMeasureSpecExactly;
            } else if (childDimension == GRXMatchParent) {
                // Child wants to be our size, but our size is not fixed.
                // Constrain child to not be bigger than us.
                resultSize = size;
                resultMode = GRXMeasureSpecAtMost;
            } else if (childDimension == GRXWrapContent) {
                // Child wants to determine its own size. It can't be
                // bigger than us.
                resultSize = size;
                resultMode = GRXMeasureSpecAtMost;
            }
            break;

        // Parent asked to see how big we want to be
        default:
        case GRXMeasureSpecUnspecified:
            if (childDimension >= 0) {
                // Child wants a specific size... let him have it
                resultSize = childDimension;
                resultMode = GRXMeasureSpecExactly;
            } else if (childDimension == GRXMatchParent) {
                // Child wants to be our size... find out how big it should
                // be
                resultSize = 0;
                resultMode = GRXMeasureSpecUnspecified;
            } else if (childDimension == GRXWrapContent) {
                // Child wants to determine its own size.... find out how
                // big it should be
                resultSize = 0;
                resultMode = GRXMeasureSpecUnspecified;
            }
            break;
    }
    return GRXMeasureSpecMake(resultSize, resultMode);
}

- (GRXMeasureSpec)childSpecWithStart:(CGFloat)childStart
                                 end:(CGFloat)childEnd
                           childSize:(CGFloat)childSize
                         startMargin:(CGFloat)startMargin
                           endMargin:(CGFloat)endMargin
                        startPadding:(CGFloat)startPadding
                          endPadding:(CGFloat)endPadding
                             ownSize:(CGFloat)ownSize {
    GRXMeasureSpec partialSpec;
    partialSpec.value = 0;
    partialSpec.mode = GRXMeasureSpecUnspecified;

    CGFloat tempStart = childStart;
    CGFloat tempEnd = childEnd;

    // If the view did not express a layout constraint for an edge, use
    // view's margins and our padding
    if (tempStart < 0) {
        tempStart = startPadding + startMargin;
    }
    if (tempEnd < 0) {
        tempEnd = ownSize - endPadding - endMargin;
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

- (void)measureChildWithMargins:(UIView *)child
                parentWidthSpec:(GRXMeasureSpec)parentWidthSpec
                      widthUsed:(CGFloat)widthUsed
               parentHeightSpec:(GRXMeasureSpec)parentHeightSpec
                     heightUsed:(CGFloat)heightUsed {
    GRXLayoutParams *lp = child.grx_layoutParams;

    CGFloat horizontalPadding = self.padding.left + self.padding.right + lp.margins.left + lp.margins.right;
    GRXMeasureSpec childWidthSpec = [self childSpecWithParentSpec:parentWidthSpec padding:horizontalPadding childDimension:lp.width];

    CGFloat verticalPadding = self.padding.top + self.padding.bottom + lp.margins.top + lp.margins.bottom;
    GRXMeasureSpec childHeightSpec = [self childSpecWithParentSpec:parentHeightSpec padding:verticalPadding childDimension:lp.height];

    CGSize childSize = [child grx_measuredSizeForWidthSpec:childWidthSpec heightSpec:childHeightSpec];
    #pragma unused(childSize)
}


@end

#import "GRXLayout+Protected.h"

@implementation GRXLayout (Protected)


- (GRXMeasureSpec)subviewSpecWithParentSpec:(GRXMeasureSpec)spec
                                    padding:(CGFloat)padding
                           subviewDimension:(CGFloat)subviewDimension {
    CGFloat size = MAX(0, spec.value - padding);

    CGFloat resultSize = 0;
    GRXMeasureSpecMode resultMode = 0;

    switch (spec.mode) {
        // Parent has imposed an exact size on us
        case GRXMeasureSpecExactly:
            if (subviewDimension >= 0) {
                resultSize = subviewDimension;
                resultMode = GRXMeasureSpecExactly;
            } else if (subviewDimension == GRXMatchParent) {
                // Subview wants to be our size. So be it.
                resultSize = size;
                resultMode = GRXMeasureSpecExactly;
            } else if (subviewDimension == GRXWrapContent) {
                // Subview wants to determine its own size. It can't be
                // bigger than us.
                resultSize = size;
                resultMode = GRXMeasureSpecAtMost;
            }
            break;

        // Parent has imposed a maximum size on us
        case GRXMeasureSpecAtMost:
            if (subviewDimension >= 0) {
                // Subview wants a specific size... so be it
                resultSize = subviewDimension;
                resultMode = GRXMeasureSpecExactly;
            } else if (subviewDimension == GRXMatchParent) {
                // Subview wants to be our size, but our size is not fixed.
                // Constrain subview to not be bigger than us.
                resultSize = size;
                resultMode = GRXMeasureSpecAtMost;
            } else if (subviewDimension == GRXWrapContent) {
                // Subview wants to determine its own size. It can't be
                // bigger than us.
                resultSize = size;
                resultMode = GRXMeasureSpecAtMost;
            }
            break;

        // Parent asked to see how big we want to be
        default:
        case GRXMeasureSpecUnspecified:
            if (subviewDimension >= 0) {
                // Subview wants a specific size... let it have it
                resultSize = subviewDimension;
                resultMode = GRXMeasureSpecExactly;
            } else if (subviewDimension == GRXMatchParent) {
                // Subview wants to be our size... find out how big it should be
                resultSize = 0;
                resultMode = GRXMeasureSpecUnspecified;
            } else if (subviewDimension == GRXWrapContent) {
                // Subview wants to determine its own size.... find out how big it should be
                resultSize = 0;
                resultMode = GRXMeasureSpecUnspecified;
            }
            break;
    }
    return GRXMeasureSpecMake(resultSize, resultMode);
}

- (GRXMeasureSpec)subviewSpecWithStart:(CGFloat)subviewStart
                                   end:(CGFloat)subviewEnd
                           subviewSize:(CGFloat)subviewSize
                           startMargin:(CGFloat)startMargin
                             endMargin:(CGFloat)endMargin
                          startPadding:(CGFloat)startPadding
                            endPadding:(CGFloat)endPadding
                               ownSize:(CGFloat)ownSize {
    GRXMeasureSpec partialSpec;
    partialSpec.value = 0;
    partialSpec.mode = GRXMeasureSpecUnspecified;

    CGFloat tempStart = subviewStart;
    CGFloat tempEnd = subviewEnd;

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

    if (subviewStart >= 0 && subviewEnd >= 0) {
        // Constraints fixed both edges, so subview must be an exact size
        partialSpec.mode = GRXMeasureSpecExactly;
        partialSpec.value = maxAvailable;
    } else {
        if (subviewSize >= 0) {
            // Subview wanted an exact size. Give as much as possible
            partialSpec.mode = GRXMeasureSpecExactly;

            if (maxAvailable >= 0) {
                // We have a maxmum size in this dimension.
                partialSpec.value = MIN(maxAvailable, subviewSize);
            } else {
                // We can grow in this dimension.
                partialSpec.value = subviewSize;
            }
        } else if (subviewSize == GRXMatchParent) {
            // Subview wanted to be as big as possible. Give all availble space
            partialSpec.mode = GRXMeasureSpecExactly;
            partialSpec.value = maxAvailable;
        } else if (subviewSize == GRXWrapContent) {
            // Subview wants to wrap content. Use AT_MOST to communicate available space if we know
            // our max size
            if (maxAvailable >= 0) {
                // We have a maxmum size in this dimension.
                partialSpec.mode = GRXMeasureSpecAtMost;
                partialSpec.value = maxAvailable;
            } else {
                // We can grow in this dimension. Subview can be as big as it wants
                partialSpec.mode = GRXMeasureSpecUnspecified;
                partialSpec.value = 0;
            }
        }
    }

    return partialSpec;
}

- (CGSize)measureSubviewWithMargins:(UIView *)subview
                    parentWidthSpec:(GRXMeasureSpec)parentWidthSpec
                          widthUsed:(CGFloat)widthUsed
                   parentHeightSpec:(GRXMeasureSpec)parentHeightSpec
                         heightUsed:(CGFloat)heightUsed {
    GRXLayoutParams *lp = subview.grx_layoutParams;

    CGFloat horizontalPadding = self.padding.left + self.padding.right + lp.margins.left + lp.margins.right;
    GRXMeasureSpec subviewWidthSpec = [self subviewSpecWithParentSpec:parentWidthSpec padding:horizontalPadding subviewDimension:lp.width];

    CGFloat verticalPadding = self.padding.top + self.padding.bottom + lp.margins.top + lp.margins.bottom;
    GRXMeasureSpec subviewHeightSpec = [self subviewSpecWithParentSpec:parentHeightSpec padding:verticalPadding subviewDimension:lp.height];

    CGSize subviewSize = [subview grx_measuredSizeForWidthSpec:subviewWidthSpec heightSpec:subviewHeightSpec];
    return subviewSize;
}


@end

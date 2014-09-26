#import "GRXLayout.h"

@interface GRXLayout (Protected)

- (GRXMeasureSpec) childSpecWithParentSpec:(GRXMeasureSpec)spec
                                padding:(CGFloat)padding
                         childDimension:(CGFloat)childDimension;
- (GRXMeasureSpec) childSpecWithStart:(CGFloat)childStart
                                     end:(CGFloat)childEnd
                               childSize:(CGFloat)childSize
                             startMargin:(CGFloat)startMargin
                               endMargin:(CGFloat)endMargin
                            startPadding:(CGFloat)startPadding
                              endPadding:(CGFloat)endPadding
                                 ownSize:(CGFloat)ownSize;

- (void) measureChildWithMargins:(UIView*)child
                 parentWidthSpec:(GRXMeasureSpec)parentWidthSpec
                       widthUsed:(CGFloat)widthUsed
                parentHeightSpec:(GRXMeasureSpec)parentHeightSpec
                      heightUsed:(CGFloat)heightUsed;

@end

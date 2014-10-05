#import "GRXLayout.h"

@interface GRXLayout (Protected)

- (GRXMeasureSpec)subviewSpecWithParentSpec:(GRXMeasureSpec)spec
                                    padding:(CGFloat)padding
                           subviewDimension:(CGFloat)subviewDimension;
- (GRXMeasureSpec)subviewSpecWithStart:(CGFloat)subviewStart
                                   end:(CGFloat)subviewEnd
                           subviewSize:(CGFloat)subviewSize
                           startMargin:(CGFloat)startMargin
                             endMargin:(CGFloat)endMargin
                          startPadding:(CGFloat)startPadding
                            endPadding:(CGFloat)endPadding
                               ownSize:(CGFloat)ownSize;

- (void)measureSubviewWithMargins:(UIView *)subview
                  parentWidthSpec:(GRXMeasureSpec)parentWidthSpec
                        widthUsed:(CGFloat)widthUsed
                 parentHeightSpec:(GRXMeasureSpec)parentHeightSpec
                       heightUsed:(CGFloat)heightUsed;

@end

#import <UIKit/UIKit.h>

@interface UIView (ExtendedLayout)

#pragma mark - Layout methods respect to another view in the same level

- (void)positionAboveView:(UIView *)view;
- (void)positionBelowView:(UIView *)view;
- (void)positionLeftToView:(UIView *)view;
- (void)positionRightToView:(UIView *)view;

- (void)alignCenter:(UIView *)view;
- (void)alignCenterVertical:(UIView *)view;
- (void)alignCenterHorizontal:(UIView *)view;
- (void)alignCenterVertical:(UIView *)view
                     margin:(CGFloat)margin;
- (void)alignCenterHorizontal:(UIView *)view
                       margin:(CGFloat)margin;

- (void)alignTop:(UIView *)view;
- (void)alignBottom:(UIView *)view;
- (void)alignLeft:(UIView *)view;
- (void)alignRight:(UIView *)view;

- (void)positionAboveView:(UIView *)view
                   margin:(CGFloat)margin;
- (void)positionBelowView:(UIView *)view
                   margin:(CGFloat)margin;
- (void)positionLeftToView:(UIView *)view
                    margin:(CGFloat)margin;
- (void)positionRightToView:(UIView *)view
                     margin:(CGFloat)margin;

- (void)alignTop:(UIView *)view
          margin:(CGFloat)margin;
- (void)alignBottom:(UIView *)view
             margin:(CGFloat)margin;
- (void)alignLeft:(UIView *)view
           margin:(CGFloat)margin;
- (void)alignRight:(UIView *)view
            margin:(CGFloat)margin;

#pragma mark - Layout methods respect to parent

- (void)alignParentCenterVertical;
- (void)alignParentCenterHorizontal;
- (void)alignParentTop;
- (void)alignParentBottom;
- (void)alignParentLeft;
- (void)alignParentRight;

- (void)alignParentTopWithMargin:(CGFloat)margin;
- (void)alignParentBottomWithMargin:(CGFloat)margin;
- (void)alignParentLeftWithMargin:(CGFloat)margin;
- (void)alignParentRightWithMargin:(CGFloat)margin;

- (void)setPositionAndSizeFromView:(UIView *)view;
- (void)setPositionAndSizeFromView:(UIView *)view
                             inset:(CGFloat)inset;
- (void)setPositionAndSizeFromView:(UIView *)view
                            insets:(UIEdgeInsets)insets;
- (void)fillParent;
- (void)fillParentWithInset:(CGFloat)inset;
- (void)fillParentWithInsets:(UIEdgeInsets)insets;

@end

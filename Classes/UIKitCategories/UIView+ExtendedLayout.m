#import "UIView+ExtendedLayout.h"

@implementation UIView (ExtendedLayout)

#pragma mark - Layout methods respect to another view in the same level

- (void)positionAboveView:(UIView *)view {
    [self positionAboveView:view margin:0];
}

- (void)positionBelowView:(UIView *)view {
    [self positionBelowView:view margin:0];
}

- (void)positionLeftToView:(UIView *)view {
    [self positionLeftToView:view margin:0];
}

- (void)positionRightToView:(UIView *)view {
    [self positionRightToView:view margin:0];
}

- (void)alignCenter:(UIView *)view {
    CGRect frame = self.frame;
    CGRect otherFrame = view.frame;
    frame.origin.x = otherFrame.origin.x + (otherFrame.size.width - frame.size.width) / 2;
    frame.origin.y = otherFrame.origin.y + (otherFrame.size.height - frame.size.height) / 2;
    self.frame = frame;
}

- (void)alignCenterHorizontal:(UIView *)view {
    [self alignCenterHorizontal:view
                         margin:0];
}

- (void)alignCenterVertical:(UIView *)view {
    [self alignCenterVertical:view
                       margin:0];
}

- (void)alignCenterVertical:(UIView *)view
                     margin:(CGFloat)margin {
    CGRect frame = self.frame;
    CGRect otherFrame = view.frame;
    frame.origin.y = otherFrame.origin.y + (otherFrame.size.height - frame.size.height) / 2 + margin;
    self.frame = frame;
}

- (void)alignCenterHorizontal:(UIView *)view
                       margin:(CGFloat)margin {
    CGRect frame = self.frame;
    CGRect otherFrame = view.frame;
    frame.origin.x = otherFrame.origin.x + (otherFrame.size.width - frame.size.width) / 2 + margin;
    self.frame = frame;
}

- (void)alignTop:(UIView *)view {
    [self alignTop:view margin:0];
}

- (void)alignBottom:(UIView *)view {
    [self alignBottom:view margin:0];
}

- (void)alignLeft:(UIView *)view {
    [self alignLeft:view margin:0];
}

- (void)alignRight:(UIView *)view {
    [self alignRight:view margin:0];
}

#pragma mark - Layout methods respect to another view in the same level

- (void)positionAboveView:(UIView *)view
                   margin:(CGFloat)margin {
    CGRect frame = self.frame;
    frame.origin.y = view.frame.origin.y - frame.size.height - margin;
    self.frame = frame;
}

- (void)positionBelowView:(UIView *)view
                   margin:(CGFloat)margin {
    CGRect frame = self.frame;
    frame.origin.y = view.frame.origin.y + view.frame.size.height + margin;
    self.frame = frame;
}

- (void)positionLeftToView:(UIView *)view
                    margin:(CGFloat)margin {
    CGRect frame = self.frame;
    frame.origin.x = view.frame.origin.x - frame.size.width - margin;
    self.frame = frame;
}

- (void)positionRightToView:(UIView *)view
                     margin:(CGFloat)margin {
    CGRect frame = self.frame;
    frame.origin.x = view.frame.origin.x + view.frame.size.width + margin;
    self.frame = frame;
}

- (void)alignTop:(UIView *)view
          margin:(CGFloat)margin {
    CGRect frame = self.frame;
    frame.origin.y = view.frame.origin.y + margin;
    self.frame = frame;
}

- (void)alignBottom:(UIView *)view
             margin:(CGFloat)margin {
    CGRect frame = self.frame;
    CGRect otherFrame = view.frame;
    frame.origin.y = otherFrame.origin.y + otherFrame.size.height - frame.size.height - margin;
    self.frame = frame;
}

- (void)alignLeft:(UIView *)view
           margin:(CGFloat)margin {
    CGRect frame = self.frame;
    frame.origin.x = view.frame.origin.x + margin;
    self.frame = frame;
}

- (void)alignRight:(UIView *)view
            margin:(CGFloat)margin {
    CGRect frame = self.frame;
    CGRect otherFrame = view.frame;
    frame.origin.x = otherFrame.origin.x + otherFrame.size.width - frame.size.width - margin;
    self.frame = frame;
}

#pragma mark - Layout methods respect to parent

- (void)alignParentCenterHorizontal {
    CGRect frame = self.frame;
    CGRect parentFrame = self.superview.frame;
    frame.origin.x = (parentFrame.size.width - frame.size.width) / 2;
    self.frame = frame;
}

- (void)alignParentCenterVertical {
    CGRect frame = self.frame;
    CGRect parentFrame = self.superview.frame;
    frame.origin.y = (parentFrame.size.height - frame.size.height) / 2;
    self.frame = frame;
}

- (void)alignParentTop {
    [self alignParentTopWithMargin:0];
}

- (void)alignParentBottom {
    [self alignParentBottomWithMargin:0];
}

- (void)alignParentLeft {
    [self alignParentLeftWithMargin:0];
}

- (void)alignParentRight {
    [self alignParentRightWithMargin:0];
}

- (void)alignParentTopWithMargin:(CGFloat)margin {
    CGRect frame = self.frame;
    frame.origin.y = margin;
    self.frame = frame;
}

- (void)alignParentBottomWithMargin:(CGFloat)margin {
    CGRect frame = self.frame;
    frame.origin.y = self.superview.frame.size.height - frame.size.height - margin;
    self.frame = frame;
}

- (void)alignParentLeftWithMargin:(CGFloat)margin {
    CGRect frame = self.frame;
    frame.origin.x = margin;
    self.frame = frame;
}

- (void)alignParentRightWithMargin:(CGFloat)margin {
    CGRect frame = self.frame;
    frame.origin.x = self.superview.frame.size.width - frame.size.width - margin;
    self.frame = frame;
}

- (void)setPositionAndSizeFromView:(UIView *)view {
    [self setPositionAndSizeFromView:view
                              insets:UIEdgeInsetsZero];
}

- (void)setPositionAndSizeFromView:(UIView *)view
                             inset:(CGFloat)inset {
    [self setPositionAndSizeFromView:view
                              insets:UIEdgeInsetsMake(inset, inset, inset, inset)];
}

- (void)setPositionAndSizeFromView:(UIView *)view
                            insets:(UIEdgeInsets)insets {
    CGRect frame = view.frame;

    frame.origin.x += insets.left;
    frame.origin.y += insets.top;
    frame.size.width -= (insets.left + insets.right);
    frame.size.height -= (insets.top + insets.bottom);

    self.frame = frame;
}

- (void)fillParent {
    [self fillParentWithInsets:UIEdgeInsetsZero];
}


- (void)fillParentWithInset:(CGFloat)inset {
    [self fillParentWithInsets:UIEdgeInsetsMake(inset, inset, inset, inset)];
}

- (void)fillParentWithInsets:(UIEdgeInsets)insets {
    CGRect frame = self.superview.bounds;

    frame.origin.x = insets.left;
    frame.origin.y = insets.top;
    frame.size.width -= (insets.left + insets.right);
    frame.size.height -= (insets.top + insets.bottom);

    self.frame = frame;
}

@end

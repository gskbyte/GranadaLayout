#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (FrameU)

#pragma mark - Shorthand properties for frame

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;

@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat right;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

#pragma mark - Shortcuts for relative positioning

@property (nonatomic, readonly) CGPoint relativeOrigin;

@property (nonatomic, readonly) CGFloat ttScreenX;
@property (nonatomic, readonly) CGFloat ttScreenY;
@property (nonatomic, readonly) CGFloat screenViewX;
@property (nonatomic, readonly) CGFloat screenViewY;
@property (nonatomic, readonly) CGRect screenFrame;

#pragma mark - z index methods

- (void)bringToFront;
- (void)sendToBack;

#pragma mark - Other methods

- (CGPoint)offsetFromView:(UIView*)otherView;

@end

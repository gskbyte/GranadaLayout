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

#pragma mark - z index methods

- (void)bringToFront;
- (void)sendToBack;

@end

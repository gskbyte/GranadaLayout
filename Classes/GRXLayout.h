#import <UIKit/UIKit.h>
#import "GRXLayoutParams.h"
#import "UIView+GRXLayout.h"

@interface GRXLayout : UIView

+ (CGSize) sizeFromViewSpec:(CGSize)vSpec
                    minSize:(CGSize)minSize
                    maxSize:(CGSize)maxSize;

+ (Class) layoutParamsClass;

- (instancetype) init;

- (void)addSubview:(UIView *)view;
- (void)addSubview:(UIView *)view
      layoutParams:(GRXLayoutParams*)layoutParams;

- (void)addSubviews:(NSArray *)views;
- (void)addSubviews:(NSArray *)views
       layoutParams:(GRXLayoutParams*)layoutParams;

@end

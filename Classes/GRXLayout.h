#import <UIKit/UIKit.h>
#import "GRXLayoutParams.h"
#import "UIView+GRXLayout.h"

@interface GRXLayout : UIView

- (instancetype) init;

- (void)addSubview:(UIView *)view;
- (void)addSubview:(UIView *)view
      layoutParams:(GRXLayoutParams*)layoutParams;

- (void)addSubviews:(NSArray *)views;
- (void)addSubviews:(NSArray *)views
       layoutParams:(GRXLayoutParams*)layoutParams;

@end

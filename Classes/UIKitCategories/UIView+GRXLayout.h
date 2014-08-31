#import <UIKit/UIKit.h>
#import "UIView+Frame.h"
#import "GRXLayoutParams.h"
#import "GRXMeasureSpec.h"

@class GRXLayout;

typedef NS_ENUM(NSUInteger, GRXViewVisibility) {
    GRXViewVisibilityVisible = 0,
    GRXViewVisibilityHidden = 1,
    GRXViewVisibilityGone = 2
};

@interface UIView (GRXLayout)

@property (nonatomic, copy, setter = grx_setLayoutParams:) GRXLayoutParams * grx_layoutParams;

@property (nonatomic, setter = grx_setDrawable:) BOOL grx_drawable;
// synthetized property with -hidden and -drawable
@property (nonatomic, setter = grx_setVisibility:) GRXViewVisibility grx_visibility;
@property (nonatomic, setter = grx_setMeasuredSize:) CGSize grx_measuredSize;
@property (nonatomic, readonly) CGSize grx_suggestedMinimumSize;

- (instancetype) initWithLayoutParams:(GRXLayoutParams*)layoutParams;
- (instancetype) initWithDefaultParamsInLayout:(GRXLayout*)layout;

// measurement is done within this method. Subclasses must call grx_setMeasuredSize at the end
- (void) grx_measureWithSpec:(GRXMeasureSpec)spec;

- (void) grx_setNeedsLayout;

@end

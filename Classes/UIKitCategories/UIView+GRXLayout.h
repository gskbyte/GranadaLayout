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

static const NSUInteger GRXLayoutIdNull = 0;

@interface UIView (GRXLayout)

@property (nonatomic, copy, setter = grx_setLayoutParams:) GRXLayoutParams * grx_layoutParams;

@property (nonatomic, setter = grx_setDrawable:) BOOL grx_drawable;
// synthetized property with -hidden and -drawable
@property (nonatomic, setter = grx_setVisibility:) GRXViewVisibility grx_visibility;
@property (nonatomic, readonly) CGSize grx_measuredSize;
@property (nonatomic, readonly) CGSize grx_suggestedMinimumSize;

// does never return null, the number is always > 0
// we could also use tag for this but this would be dangerous
@property (nonatomic, readonly) NSNumber * grx_layoutId;

- (instancetype) initWithLayoutParams:(GRXLayoutParams*)layoutParams;
- (instancetype) initWithDefaultParamsInLayout:(GRXLayout*)layout;

// this method must NOT be overriden and is called by layouts
// implements a caching mechanism so measureForWidthSpec:heightSpec: is not called for same specs
- (CGSize) grx_measuredSizeForWidthSpec:(GRXMeasureSpec)widthSpec
                             heightSpec:(GRXMeasureSpec)heightSpec;

// measurement is done within this method
- (CGSize) grx_measureForWidthSpec:(GRXMeasureSpec)widthSpec
                        heightSpec:(GRXMeasureSpec)heightSpec;

- (void) grx_setNeedsLayout;

@end

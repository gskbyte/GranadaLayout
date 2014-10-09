#import <UIKit/UIKit.h>
#import "UIView+Frame.h"
#import "GRXLayoutParams.h"
#import "GRXMeasureSpec.h"

@class GRXLayout;

typedef NS_ENUM(NSUInteger, GRXViewVisibility) {
    GRXViewVisibilityVisible = 0,   // the view is visible and will be layouted
    GRXViewVisibilityHidden = 1,    // the view is not visible but keeps its size and will be layouted
    GRXViewVisibilityGone = 2       // the view is not visible, its size is zero and won't be layouted
};

static const NSUInteger GRXLayoutIdNull = 0;

@interface UIView (GRXLayout)

@property (nonatomic, setter=grx_setMinSize:) CGSize grx_minSize;
@property (nonatomic, setter = grx_setLayoutParams:) GRXLayoutParams * grx_layoutParams;
@property (nonatomic, setter = grx_setVisibility:) GRXViewVisibility grx_visibility;

@property (nonatomic, readonly) CGSize grx_measuredSize;

// does never return null, the number is always > 0
// we could also use tag for this but this would be dangerous
@property (nonatomic, readonly) NSNumber * grx_layoutId;
@property (nonatomic, setter=grx_setDebugIdentifier:) NSString *grx_debugIdentifier;

// this method must NOT be overriden and is called by layouts
// implements a caching mechanism so measureForWidthSpec:heightSpec: is not called for same specs
- (CGSize) grx_measuredSizeForWidthSpec:(GRXMeasureSpec)widthSpec
                             heightSpec:(GRXMeasureSpec)heightSpec;
- (void) grx_invalidateMeasuredSize;

// measurement is done within this method
- (CGSize) grx_measureForWidthSpec:(GRXMeasureSpec)widthSpec
                        heightSpec:(GRXMeasureSpec)heightSpec;

// this method must be called when the size of this view may change, and requests the top
// layout to relayout its subviews
- (void) grx_setNeedsLayoutInParent;

@end

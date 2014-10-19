#import <UIKit/UIKit.h>
#import "UIView+Frame.h"
#import "GRXLayoutParams.h"
#import "GRXMeasureSpec.h"

@class GRXLayout;

typedef CGSize (^GRXMeasurementBlock)(GRXMeasureSpec widthSpec, GRXMeasureSpec heightSpec);

typedef NS_ENUM (NSUInteger, GRXVisibility) {
    GRXVisibilityVisible = 0,   // the view is visible and will be layouted
    GRXVisibilityHidden = 1,    // the view is not visible but keeps its size and will be layouted
    GRXVisibilityGone = 2       // the view is not visible, its size is zero and won't be layouted
};

static const NSUInteger GRXLayoutIdNull = 0;

@interface UIView (GRXLayout)

@property (nonatomic, setter = grx_setMinSize :) CGSize grx_minSize;
@property (nonatomic, setter = grx_setLayoutParams :) GRXLayoutParams *grx_layoutParams;
@property (nonatomic, setter = grx_setVisibility :) GRXVisibility grx_visibility;

@property (nonatomic, readonly) CGSize grx_measuredSize;

// set an implementation of a measurement method in order to override the default one
// without needing to subclass
@property (nonatomic, copy, setter = grx_setMeasurementBlock:) CGSize (^grx_measurementBlock)(GRXMeasureSpec widthSpec, GRXMeasureSpec heightSpec);


// does never return null, the number is always > 0
// we could also use tag for this but this would be dangerous
@property (nonatomic, readonly) NSNumber *grx_layoutId;
@property (nonatomic, setter = grx_setDebugIdentifier :) NSString *grx_debugIdentifier;


- (instancetype)initWithLayoutParams:(GRXLayoutParams *)layoutParams;
- (instancetype)initWithDefaultParamsInLayout:(GRXLayout *)layout;

// this method must NOT be overriden and is called by layouts
// implements a caching mechanism so measureForWidthSpec:heightSpec: is not called for same specs
- (CGSize)grx_measuredSizeForWidthSpec:(GRXMeasureSpec)widthSpec
                            heightSpec:(GRXMeasureSpec)heightSpec;
- (void)grx_invalidateMeasuredSize;

// measurement is done within this method
- (CGSize)grx_measureForWidthSpec:(GRXMeasureSpec)widthSpec
                       heightSpec:(GRXMeasureSpec)heightSpec;

// this method must be called when the size of this view may change, and requests the top
// layout to relayout its subviews
- (void)grx_setNeedsLayoutInParent;
- (NSString *)grx_debugDescription;

@end

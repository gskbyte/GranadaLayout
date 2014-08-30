#import <UIKit/UIKit.h>
#import "UIView+Frame.h"
#import "GRXLayoutParams.h"

@class GRXLayout;

typedef NS_ENUM(NSUInteger, GRXViewVisibility) {
    GRXViewVisibilityVisible = 0,
    GRXViewVisibilityHidden = 1,
    GRXViewVisibilityGone = 2
};

@interface UIView (GRXLayout)

@property (nonatomic, copy, setter = grx_setLayoutParams:) GRXLayoutParams * grx_layoutParams;
@property (nonatomic, readonly) CGSize grx_layoutSize;

@property (nonatomic, setter = grx_setDrawable:) BOOL grx_drawable;
// synthetized property with -hidden and -drawable
@property (nonatomic, setter = grx_setVisibility:) GRXViewVisibility grx_visibility;

// this class provides just a basic implementation, must be overriden in children classes
- (CGSize) grx_suggestedSizeForSizeSpec:(CGSize)sizeSpec;

@end

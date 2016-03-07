#import <UIKit/UIKit.h>
#import "GRXLayoutParams.h"
#import "UIView+GRXLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface GRXLayout : UIView

@property (nonatomic) UIEdgeInsets padding;

// This property specifies if this layout must take into account the parent's size
// when it is going to be measured ONLY IF the parent is not an instance of GRXLayout
// By default, views will grow to the bottom but not horizontally
@property (nonatomic) BOOL limitToNonLayoutParentWidth; // YES by default
@property (nonatomic) BOOL limitToNonLayoutParentHeight; // YES by default

+ (Class)layoutParamsClass;

- (instancetype)initWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
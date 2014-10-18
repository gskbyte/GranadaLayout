#import "GRXLayout.h"
#import "GRXLayoutParams.h"
#import <objc/runtime.h>

@implementation GRXLayout

#pragma mark - static class methods

+ (Class)layoutParamsClass {
    return GRXLayoutParams.class;
}

#pragma mark - setup methods

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _limitToNonLayoutParentWidth = YES;
        _limitToNonLayoutParentHeight = YES;
    }
    return self;
}

- (void)addSubview:(UIView *)view {
    if (view.grx_layoutParams != nil) {
        NSAssert([view.grx_layoutParams isKindOfClass:self.class.layoutParamsClass],
                 @"Layout class %@ needs layoutParams to be instances of %@", self.class, self.class.layoutParamsClass);
    } else {
        view.grx_layoutParams = [[self.class.layoutParamsClass alloc] init];
    }
    [super addSubview:view];
    [self grx_setNeedsLayoutInParent];
}

- (void)setNeedsLayout {
    [super setNeedsLayout];
    [self grx_invalidateMeasuredSize];
}

// This is how the whole layout system works
// By default, layout views don't do anything when -layoutSubviews is called
// Except if they are inside a non-GRXLayout view, then they take the initiative and measure their subviews
// And set their frame size. Position is left equal, must be changed manually outside.

- (void)layoutSubviews {
    if (NO == [self.superview isKindOfClass:GRXLayout.class]) {
        GRXMeasureSpec wspec, hspec;
        GRXLayoutParams *ownParams = self.grx_layoutParams;

        CGSize maxSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
        CGSize screenSize = UIScreen.mainScreen.bounds.size;

        // Take parent size to see how big I can be, if I'm root, take the whole display
        // If a dimension is set to match parent, limit to the display size
        if (self.limitToNonLayoutParentWidth && self.superview.width > 0) {
            maxSize.width = self.superview.width;
        } else if(ownParams.width == GRXMatchParent) {
            maxSize.width = screenSize.width;
        }

        if(self.limitToNonLayoutParentHeight && self.superview.height > 0) {
            maxSize.height = self.superview.height;
        } else if(ownParams.height == GRXMatchParent) {
            maxSize.height = screenSize.height;
        }


        if (ownParams.width == 0 || ownParams.width == GRXWrapContent) {
            wspec = GRXMeasureSpecMake(maxSize.width, GRXMeasureSpecAtMost);
        } else if (ownParams.width == GRXMatchParent) {
            wspec = GRXMeasureSpecMake(maxSize.width, GRXMeasureSpecExactly);
        } else { // exact size
            wspec = GRXMeasureSpecMake(ownParams.width, GRXMeasureSpecExactly);
        }

        if (ownParams.height == 0 || ownParams.height == GRXWrapContent) {
            hspec = GRXMeasureSpecMake(maxSize.height, GRXMeasureSpecAtMost);
        } else if (ownParams.height == GRXMatchParent) {
            hspec = GRXMeasureSpecMake(maxSize.height, GRXMeasureSpecExactly);
        } else { // exact size
            hspec = GRXMeasureSpecMake(ownParams.height, GRXMeasureSpecExactly);
        }

        self.size = [self grx_measuredSizeForWidthSpec:wspec
                                            heightSpec:hspec];
    }

    [super layoutSubviews];
}

@end

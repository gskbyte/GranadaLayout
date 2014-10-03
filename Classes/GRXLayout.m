#import "GRXLayout_Protected.h"
#import "GRXLayoutParams.h"
#import <objc/runtime.h>

@implementation GRXLayout

#pragma mark - static class methods

+ (Class)layoutParamsClass {
    return GRXLayoutParams.class;
}

#pragma mark - setup methods

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)addSubview:(UIView *)view {
    if (view.grx_layoutParams == nil) {
        view.grx_layoutParams = [[self.class.layoutParamsClass alloc] init];
    }
    _dirtyHierarchy = YES;
    [super addSubview:view];
}

- (void)addSubview:(UIView *)view
      layoutParams:(GRXLayoutParams *)layoutParams {
    NSAssert([view.grx_layoutParams isKindOfClass:self.class.layoutParamsClass],
             @"Layout class %@ needs layoutParams to be instances of %@", self.class, self.class.layoutParamsClass);
    view.grx_layoutParams = layoutParams;
    _dirtyHierarchy = YES;
    [self addSubview:view];
}

- (void)addSubviews:(NSArray *)views {
    for (UIView *view in views) {
        [self addSubview:view];
    }
}

- (void)addSubviews:(NSArray *)views
       layoutParams:(GRXLayoutParams *)layoutParams {
    for (UIView *view in views) {
        [self addSubview:view
            layoutParams:layoutParams];
    }
}

- (void)setNeedsLayout {
    [super setNeedsLayout];
    _dirtyHierarchy = YES;
}


// This is how the whole layout system works
// By default, layout views don't do anything when -layoutSubviews is called
// Except if they are inside a non-GRXLayout view, then they take the initiative and measure their children
// And set their frame size. Position is left equal, must be changed manually outside.

- (void)layoutSubviews {
    if (NO == [self.superview isKindOfClass:GRXLayout.class]) {
        // Take parent size to see how big I can be, if I'm root, take the whole display
        CGSize parentSize;
        if(self.superview != nil) {
            parentSize = self.superview.size;
            // TODO case for UIScrollView ? (would be infinite size?)
        } else {
            parentSize = UIScreen.mainScreen.bounds.size;
        }

        GRXMeasureSpec wspec, hspec;
        GRXLayoutParams * ownParams = self.grx_layoutParams;

        if(ownParams.width == 0 || ownParams.width == GRXWrapContent) {
            wspec = GRXMeasureSpecMake(parentSize.width, GRXMeasureSpecAtMost);
        } else { // match_parent or exact size
            wspec = GRXMeasureSpecMake(ownParams.width, GRXMeasureSpecExactly);
        }

        if(ownParams.height == 0 || ownParams.height == GRXWrapContent) {
            hspec = GRXMeasureSpecMake(parentSize.height, GRXMeasureSpecAtMost);
        } else {
            hspec = GRXMeasureSpecMake(ownParams.width, GRXMeasureSpecExactly);
        }

        self.size = [self grx_measuredSizeForWidthSpec:wspec
                                            heightSpec:hspec];
    }

    [super layoutSubviews];
}

- (CGSize)grx_measureForWidthSpec:(GRXMeasureSpec)widthSpec
                       heightSpec:(GRXMeasureSpec)heightSpec {
    // TODO implement me!
    NSAssert(NO, @"Having layouts inside layouts is not yet supported");
    return CGSizeZero;
}

- (void) setHierarchyDirty {
    _dirtyHierarchy = YES;
}

- (void)setHierarchyClean {
    _dirtyHierarchy = NO;
}

@end

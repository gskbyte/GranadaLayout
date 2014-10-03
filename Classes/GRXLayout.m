#import "GRXLayout.h"
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
    NSAssert([view.grx_layoutParams isKindOfClass:self.class.layoutParamsClass],
             @"Layout class %@ needs layoutParams to be instances of %@", self.class, self.class.layoutParamsClass);
    [super addSubview:view];
}

- (void)addSubview:(UIView *)view
      layoutParams:(GRXLayoutParams *)layoutParams {
    view.grx_layoutParams = layoutParams;
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

- (void)layoutSubviews {
    [super layoutSubviews];
    // measure myself and my subviews only if I don't have anyone who requests it
    if (NO == [self.superview isKindOfClass:GRXLayout.class]) {
        GRXMeasureSpec wspec, hspec;
        CGSize ownSize = self.size;
        if (ownSize.width != 0 && ownSize.height != 0) {
            wspec = GRXMeasureSpecMake(ownSize.width, GRXMeasureSpecExactly);
            hspec = GRXMeasureSpecMake(ownSize.height, GRXMeasureSpecExactly);
        } else {
            CGSize parentSize;
            if(self.superview == nil) {
                parentSize = UIScreen.mainScreen.bounds.size;
            } else {
                parentSize = self.superview.size;
            }
            if (self.grx_layoutParams == nil) {
                self.grx_layoutParams = [[GRXLayoutParams alloc] initWithSize:CGSizeMake(GRXWrapContent, GRXWrapContent)];
            }
            wspec = GRXMeasureSpecMake(parentSize.width, GRXMeasureSpecAtMost);
            hspec = GRXMeasureSpecMake(parentSize.height, GRXMeasureSpecAtMost);
        }
        [self grx_measuredSizeForWidthSpec:wspec
                                heightSpec:hspec];
    }
}

- (CGSize)grx_measureForWidthSpec:(GRXMeasureSpec)widthSpec
                       heightSpec:(GRXMeasureSpec)heightSpec {
    // TODO implement me!
    NSAssert(NO, @"Having layouts inside layouts is not yet supported");
    return CGSizeZero;
}

@end

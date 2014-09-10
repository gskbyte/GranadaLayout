#import "GRXLayout.h"
#import <objc/runtime.h>

@implementation GRXLayout

#pragma mark - static class methods

+ (Class)layoutParamsClass {
    NSAssert(NO, @"Implement +layoutParamsClass in class %@", self.class);
    return nil;
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
    NSAssert(view.grx_layoutParams != nil, @"Set layout params before adding the view %@", view);
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
        CGSize parentSize = self.superview.size;
        if (parentSize.width > 0 && parentSize.height > 0) {
            if(self.grx_layoutParams == nil) {
                self.grx_layoutParams = [[GRXLayoutParams alloc] initWithSize:CGSizeMake(GRXWrapContent, GRXWrapContent)];
            }
            [self grx_measuredSizeForWidthSpec:GRXMeasureSpecMake(parentSize.width, GRXMeasureSpecAtMost)
                                    heightSpec:GRXMeasureSpecMake(parentSize.height, GRXMeasureSpecAtMost)];
        }
    }
}

- (CGSize)grx_measureForWidthSpec:(GRXMeasureSpec)widthSpec
                       heightSpec:(GRXMeasureSpec)heightSpec {
    // TODO implement me!
    NSAssert(NO, @"Having layouts inside layouts is not yet supported");
    return CGSizeZero;
}

@end

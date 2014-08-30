#import "GRXLayout.h"

@implementation GRXLayout

#pragma mark - static class methods

+ (Class) layoutParamsClass {
    NSAssert(NO, @"Implement +layoutParamsClass in class %@", self.class);
    return nil;
}

#pragma mark - setup methods

- (instancetype) init {
    return [self initWithFrame:CGRectZero];
}

- (void)addSubview:(UIView *)view {
    NSAssert(view.grx_layoutParams != nil, @"Set layout params before adding the view %@", view);
    NSAssert([view.grx_layoutParams isKindOfClass:self.class.layoutParamsClass],
             @"Layout class %@ needs layoutParams to be instances of %@", self.class, self.class.layoutParamsClass);
    [super addSubview:view];
}

- (void)addSubview:(UIView *)view
      layoutParams:(GRXLayoutParams*)layoutParams {
    NSAssert([layoutParams isKindOfClass:self.class.layoutParamsClass],
             @"Layout class %@ needs layoutParams to be instances of %@", self.class, self.class.layoutParamsClass);
    view.grx_layoutParams = layoutParams;
    [super addSubview:view];
}


- (void)addSubviews:(NSArray *)views {
    for(UIView * view in views) {
        [self addSubview:view];
    }
}

- (void)addSubviews:(NSArray *)views
       layoutParams:(GRXLayoutParams*)layoutParams {
    for(UIView * view in views) {
        [self addSubview:view
            layoutParams:layoutParams];
    }
}

- (void) layoutSubviews {
    [super layoutSubviews];
    NSAssert(self.class != GRXLayout.class, @"Override -layoutSubviews");
}

- (CGSize)grx_suggestedSizeForSizeSpec:(CGSize)sizeSpec {
    CGSize size;
    // TODO implement me!
    NSAssert(NO, @"Having layouts inside layouts is not yet supported");
    return size;
}

@end

#import "GRXLayout.h"

@implementation GRXLayout

- (instancetype) init {
    return [self initWithFrame:CGRectZero];
}

- (void)addSubview:(UIView *)view {
    NSAssert(view.grx_layoutParams != nil, @"Set layout params before adding the view %@", view);
    [super addSubview:view];
}

- (void)addSubview:(UIView *)view
      layoutParams:(GRXLayoutParams*)layoutParams {
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
        [self addSubview:view layoutParams:layoutParams];
    }
}

- (void) layoutSubviews {
    [super layoutSubviews];
}

- (CGSize)grx_suggestedSizeForSizeSpec:(CGSize)sizeSpec {
    CGSize size;

    return size;
}

@end

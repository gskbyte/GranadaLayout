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
    NSAssert(self.class != GRXLayout.class, @"Override -layoutSubviews");
}

- (CGSize)grx_suggestedSizeForSizeSpec:(CGSize)sizeSpec {
    CGSize size;
    // TODO implement me!
    NSAssert(NO, @"Having layouts inside layouts is not yet supported");
    return size;
}

+ (CGSize) sizeFromViewSpec:(CGSize)vSpec
                    minSize:(CGSize)minSize
                    maxSize:(CGSize)maxSize {
    NSAssert(vSpec.width != GRXWrapContent && vSpec.height != GRXWrapContent,
             @"Wrap content is not a valid measurement value");

    CGSize size = CGSizeZero;
    if(vSpec.width == GRXMatchParent) {
        size.width = MAX(0, maxSize.width);
    } else {
        size.width = MAX(vSpec.width, minSize.width);
    }
    size.width = MIN(size.width, maxSize.width);

    if(vSpec.height == GRXMatchParent) {
        size.height = MAX(0, maxSize.height);
    } else {
        size.height = MAX(vSpec.height, minSize.height);
    }
    size.height = MIN(size.height, maxSize.height);

    return size;
}

@end

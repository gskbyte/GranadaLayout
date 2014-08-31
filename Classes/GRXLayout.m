#import "GRXLayout.h"
#import <objc/runtime.h>

@implementation GRXLayout

#pragma mark - static class methods

+ (void) replaceSetNeedsLayout {
    Class class = UIView.class;

    SEL originalSelector = @selector(setNeedsLayout);
    SEL swizzledSelector = @selector(grx_setNeedsLayout);

    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));

    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (Class) layoutParamsClass {
    NSAssert(NO, @"Implement +layoutParamsClass in class %@", self.class);
    return nil;
}

#pragma mark - setup methods

- (instancetype) init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [GRXLayout replaceSetNeedsLayout];
        });
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

- (void) grx_measureWithSpec:(GRXMeasureSpec)spec {
    // TODO implement me!
    NSAssert(NO, @"Having layouts inside layouts is not yet supported");
}

@end

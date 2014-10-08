#import "GRXLayoutParams.h"
#import "GRXLayoutParams_Protected.h"
#import "UIView+GRXLayout.h"

@implementation GRXLayoutParams

- (instancetype)init {
    return [self initWithSize:kGRXLayoutParamsDefaultSize];
}

- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        _size = size;
    }
    return self;
}

#pragma mark - Instance methods

- (void)setMinSize:(CGSize)minSize {
    NSAssert(minSize.width >= 0 && minSize.height >= 0, @"minSize must have positive values");

    _minSize = minSize;
    [_view grx_setNeedsLayoutInParent];
}

- (void)setSize:(CGSize)size {
    _size = size;
    [_view grx_setNeedsLayoutInParent];
}

- (CGFloat)width {
    return _size.width;
}

- (void)setWidth:(CGFloat)width {
    _size.width = width;
}

- (CGFloat)height {
    return _size.height;
}

- (void)setHeight:(CGFloat)height {
    _size.height = height;
}

- (void)setMargins:(UIEdgeInsets)margins {
    _margins = margins;
    [_view grx_setNeedsLayoutInParent];
}

- (BOOL)hasMargins {
    return _margins.top == _margins.left == _margins.bottom == _margins.right == 0;
}

#pragma mark - Copy method

- (id)copyWithZone:(NSZone *)zone {
    GRXLayoutParams *copy = [[self.class alloc] initWithSize:self.size];
    copy.margins = self.margins;
    copy.minSize = self.minSize;
    return copy;
}

#pragma mark - Protected methods

- (void)setView:(UIView *)view {
    _view = view;
}


- (NSString *)debugDescription {
    return [NSString stringWithFormat:@""
            "%@",
            NSStringFromClass(self.class)
    ];
}

- (NSString *)description {
    return [NSString stringWithFormat:@""
            "%@[%.0f,%.0f]",
            NSStringFromClass(self.class), self.width, self.height
    ];
}


@end

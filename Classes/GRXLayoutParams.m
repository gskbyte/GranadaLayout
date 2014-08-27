#import "GRXLayoutParams.h"
#import "GRXLayoutParams_Protected.h"

@implementation GRXLayoutParams

- (instancetype) init {
    return [self initWithSize:kGRXLayoutParamsDefaultSize];
}

- (instancetype) initWithSize:(CGSize)size {
    self = [super init];
    if(self) {
        self.size = size;
    }
    return self;
}

#pragma mark - Instance methods

- (void) setMinSize:(CGSize)minSize {
    NSAssert(minSize.width>=0 && minSize.height>=0, @"minSize must have positive values");

    _minSize = minSize;
}

- (BOOL)hasMargins {
    return _margins.top == _margins.left == _margins.bottom == _margins.right == 0;
}

#pragma mark - Copy method

- (id)copyWithZone:(NSZone *)zone {
    GRXLayoutParams * copy = [[self.class alloc] initWithSize:self.size];
    copy.margins = self.margins;
    copy.minSize = self.minSize;
    return copy;
}

#pragma mark - Protected methods

- (void)setView:(UIView *)view {
    _view = view;
}

@end

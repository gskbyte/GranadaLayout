#import "GRXRelativeLayoutParams.h"
#import "GRXRelativeLayoutParams_Protected.h"
#import "UIView+GRXLayout.h"

static NSNumber * NoNumber = nil;

@interface GRXRelativeLayoutParams ()

@property (nonatomic) NSMutableArray * mutableRules;
@property (nonatomic) NSMutableArray * mutableParentRules;

@end

@implementation GRXRelativeLayoutParams

// TODO initialize one-time
+ (NSArray *)verticalRules {
    return @[
             @(GRXRelativeLayoutRuleAbove),
             @(GRXRelativeLayoutRuleBelow),
             @(GRXRelativeLayoutRuleAlignTop),
             @(GRXRelativeLayoutRuleAlignBottom),
             ];
}

+ (NSArray *)horizontalRules {
    return @[
             @(GRXRelativeLayoutRuleLeftOf),
             @(GRXRelativeLayoutRuleRightOf),
             @(GRXRelativeLayoutRuleAlignLeft),
             @(GRXRelativeLayoutRuleAlignRight),
             ];
}

#pragma mark - initialization methods



- (instancetype) initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if(self) {
        [self setupNoNumber];
        [self setupRules];
    }
    return self;
}

- (void) setupNoNumber {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NoNumber = @NO;
    });
}

- (void) setupRules {
    _mutableRules = [NSMutableArray arrayWithCapacity:GRXRelativeLayoutRuleCount];
    for(NSUInteger i=0; i<GRXRelativeLayoutRuleCount; ++i) {
        [_mutableRules addObject:@(NO)];
    }

    _mutableParentRules = [NSMutableArray arrayWithCapacity:GRXRelativeLayoutParentRuleCount];
    for(NSUInteger i=0; i<GRXRelativeLayoutParentRuleCount; ++i) {
        [_mutableParentRules addObject:@(NO)];
    }
}

- (NSArray *)rules {
    return _mutableRules;
}

- (NSArray *)parentRules {
    return _mutableParentRules;
}

#pragma mark - instance methods

- (BOOL) hasRule:(GRXRelativeLayoutRule)rule {
    return _mutableRules[rule] != NoNumber;
}

- (UIView *)viewForRule:(GRXRelativeLayoutRule)rule {
    id ret = _mutableRules[rule];
    if(ret == NoNumber) {
        return nil;
    } else {
        return ret;
    }
}

- (void) setRule:(GRXRelativeLayoutRule)rule
         forView:(UIView*)view {
    if(view == nil) {
        _mutableRules[rule] = NoNumber;
    } else {
        _mutableRules[rule] = view;
    }
}

- (BOOL)hasParentRule:(GRXRelativeLayoutParentRule)parentRule {
    NSNumber * n = _mutableParentRules[parentRule];
    return n.boolValue;
}

- (void)setParentRule:(GRXRelativeLayoutParentRule)parentRule
               active:(BOOL)active {
    _mutableParentRules[parentRule] = @(active);
}

- (id)copyWithZone:(NSZone *)zone {
    GRXRelativeLayoutParams * copy = [super copyWithZone:zone];
    [copy->_mutableRules setArray:_mutableRules];
    [copy->_mutableParentRules setArray:_mutableParentRules];
    return copy;
}

+ (void) grx_debugPointerArray:(NSPointerArray*)pa {
    NSMutableString * desc = [NSMutableString stringWithString:@""];
    for(id pointer in pa) {
        if(pointer == nil) {
            [desc appendString:@"NULL, "];
        } else {
            [desc appendFormat:@"%@, ", [pointer description]];
        }
    }
    NSLog(@"Pointer array(%d): %@", pa.count, desc);
}

#pragma mark - protected methods

- (CGFloat)top {
    return _rect.origin.y;
}

- (void)setTop:(CGFloat)top {
    _rect.origin.y = top;
}

- (CGFloat)left {
    return _rect.origin.x;
}

- (void)setLeft:(CGFloat)x {
    _rect.origin.x = x;
}

- (CGFloat)bottom {
    return _rect.origin.y + _rect.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    _rect.origin.y = bottom - _rect.size.height;
}

- (CGFloat)right {
    return _rect.origin.x + _rect.size.width;
}

- (void)setRight:(CGFloat)right {
    _rect.origin.x = right - _rect.size.width;
}

- (CGFloat)width {
    return _rect.size.width;
}

- (void)setWidth:(CGFloat)width {
    _rect.size.width = width;
}

- (CGFloat)height {
    return _rect.size.height;
}

- (void)setHeight:(CGFloat)height {
    _rect.size.height = height;
}

@end

@implementation UIView (GRXRelativeLayoutParams)

- (GRXRelativeLayoutParams *)grx_relativeLayoutParams {
    GRXLayoutParams * params = self.grx_layoutParams;
    if([params isKindOfClass:GRXRelativeLayoutParams.class]) {
        return (GRXRelativeLayoutParams*) params;
    } else {
        NSAssert(NO, @"Not GRXLinearLayoutParams for view %@", self);
        return nil;
    }
}

@end

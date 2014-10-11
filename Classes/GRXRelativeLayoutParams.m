#import "GRXRelativeLayoutParams.h"
#import "UIView+GRXLayout.h"

static NSNumber *NoNumber = nil;

@interface GRXRelativeLayoutParams () {
    NSMutableArray *_mutableRules, *_mutableParentRules;
}

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

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        [self setupNoNumber];
        [self setupRules];
    }
    return self;
}

- (void)setupNoNumber {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NoNumber = @0;
    });
}

- (void)setupRules {
    _mutableRules = [NSMutableArray arrayWithCapacity:GRXRelativeLayoutRuleCount];
    for (NSUInteger i = 0; i < GRXRelativeLayoutRuleCount; ++i) {
        [_mutableRules addObject:NoNumber];
    }

    _mutableParentRules = [NSMutableArray arrayWithCapacity:GRXRelativeLayoutParentRuleCount];
    for (NSUInteger i = 0; i < GRXRelativeLayoutParentRuleCount; ++i) {
        [_mutableParentRules addObject:NoNumber];
    }
}

#pragma mark - instance methods

- (BOOL)hasRule:(GRXRelativeLayoutRule)rule {
    return _mutableRules[rule] != NoNumber;
}

- (UIView *)viewForRule:(GRXRelativeLayoutRule)rule {
    id ret = _mutableRules[rule];
    if (ret == NoNumber) {
        return nil;
    } else {
        NSValue * value = ret;
        return value.nonretainedObjectValue;
    }
}

- (void)setRule:(GRXRelativeLayoutRule)rule
        forView:(UIView *)view {
    if (view == nil) {
        _mutableRules[rule] = NoNumber;
    } else {
        _mutableRules[rule] = [NSValue valueWithNonretainedObject:view];
    }
}

- (BOOL)hasParentRule:(GRXRelativeLayoutParentRule)parentRule {
    NSNumber *n = _mutableParentRules[parentRule];
    return n.boolValue;
}

- (void)setParentRule:(GRXRelativeLayoutParentRule)parentRule {
    [self setParentRule:parentRule active:YES];
}

- (void)setParentRule:(GRXRelativeLayoutParentRule)parentRule
               active:(BOOL)active {
    NSUInteger index = (NSUInteger)parentRule;
    _mutableParentRules[index] = @((NSUInteger)active);
}

- (id)copyWithZone:(NSZone *)zone {
    GRXRelativeLayoutParams *copy = [super copyWithZone:zone];
    [copy->_mutableRules setArray:_mutableRules];
    [copy->_mutableParentRules setArray:_mutableParentRules];
    copy->_top = _top;
    copy->_left = _left;
    copy->_bottom = _bottom;
    copy->_right = _right;
    return copy;
}

- (NSString *)debugDescription {
    NSString * description = [super debugDescription];
    description = [description stringByAppendingFormat:@"[%.0f,%.0f,%.0f,%.0f]",_left,_top,_right,_bottom];
    return description;
}

#pragma mark - protected methods

- (CGRect)rect {
    CGRect rect;
    rect.origin.x = _left;
    rect.origin.y = _top;
    rect.size.width = _right - _left;
    rect.size.height = _bottom - _top;
    return rect;
}

@end

@implementation UIView (GRXRelativeLayoutParams)

- (GRXRelativeLayoutParams *)grx_relativeLayoutParams {
    GRXLayoutParams *params = self.grx_layoutParams;
    if ([params isKindOfClass:GRXRelativeLayoutParams.class]) {
        return (GRXRelativeLayoutParams *)params;
    } else {
        NSAssert(NO, @"Not GRXLinearLayoutParams for view %@", self);
        return nil;
    }
}

@end

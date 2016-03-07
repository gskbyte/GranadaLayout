#import "GRXRelativeLayoutParams.h"
#import "UIView+GRXLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface GRXRelativeLayoutParams ()
@property(nonatomic) NSMapTable<NSNumber *, UIView *> *mutableRules;
@property(nonatomic) NSMutableSet<NSNumber *> *mutableParentRules;
@end

@implementation GRXRelativeLayoutParams

+ (NSArray<NSNumber *> *)verticalRules {
    static NSArray<NSNumber *> *GRXRelativeVerticalRules;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        GRXRelativeVerticalRules = @[
            @(GRXRelativeLayoutRuleAbove),
            @(GRXRelativeLayoutRuleBelow),
            @(GRXRelativeLayoutRuleAlignTop),
            @(GRXRelativeLayoutRuleAlignBottom),
        ];
    });
    return GRXRelativeVerticalRules;
}

+ (NSArray<NSNumber *> *)horizontalRules {
    static NSArray<NSNumber *> *GRXRelativeHorizontalRules;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        GRXRelativeHorizontalRules =@[
            @(GRXRelativeLayoutRuleLeftOf),
            @(GRXRelativeLayoutRuleRightOf),
            @(GRXRelativeLayoutRuleAlignLeft),
            @(GRXRelativeLayoutRuleAlignRight),
        ];
    });
    return GRXRelativeHorizontalRules;
}

#pragma mark - initialization methods

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        [self setupRules];
    }
    return self;
}

- (instancetype)initWithLayoutParams:(GRXLayoutParams *)layoutParams {
    self = [super initWithLayoutParams:layoutParams];
    if (self) {
        [self setupRules];
        if ([layoutParams isKindOfClass:GRXRelativeLayoutParams.class]) {
            GRXRelativeLayoutParams *relParams = (GRXRelativeLayoutParams *)layoutParams;
            _mutableRules = relParams.mutableRules;
            _mutableParentRules = relParams.mutableParentRules;
            _top = relParams.top;
            _left = relParams.left;
            _bottom = relParams.bottom;
            _right = relParams.right;
        }
    }
    return self;
}

- (void)setupRules {
    _mutableRules = [NSMapTable strongToWeakObjectsMapTable];
    _mutableParentRules = [NSMutableSet setWithCapacity:GRXRelativeLayoutParentRuleCount];
}

#pragma mark - instance methods

- (BOOL)hasRule:(GRXRelativeLayoutRule)rule {
    return [self.mutableRules objectForKey:@(rule)] != nil;
}

- (nullable __kindof UIView *)viewForRule:(GRXRelativeLayoutRule)rule {
    return [self.mutableRules objectForKey:@(rule)];
}

- (void)setRule:(GRXRelativeLayoutRule)rule
        forView:(nullable __kindof UIView *)view {
    [self.mutableRules setObject:view forKey:@(rule)];
}

- (BOOL)hasParentRule:(GRXRelativeLayoutParentRule)parentRule {
    return [self.mutableParentRules containsObject:@(parentRule)];
}

- (void)setParentRule:(GRXRelativeLayoutParentRule)parentRule {
    [self setParentRule:parentRule active:YES];
}

- (void)setParentRule:(GRXRelativeLayoutParentRule)parentRule
               active:(BOOL)active {
    if (active) {
        [self.mutableParentRules addObject:@(parentRule)];
    } else {
        [self.mutableParentRules removeObject:@(parentRule)];
    }
}

- (NSString *)debugDescription {
    NSString *description = [super debugDescription];
    description = [description stringByAppendingFormat:@"[%.0f, %.0f, %.0f, %.0f]", _left, _top, _right, _bottom];
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

- (nullable GRXRelativeLayoutParams *)grx_relativeLayoutParams {
    GRXLayoutParams *params = self.grx_layoutParams;
    if ([params isKindOfClass:GRXRelativeLayoutParams.class]) {
        return (GRXRelativeLayoutParams *)params;
    } else {
        NSAssert(NO, @"Not GRXLinearLayoutParams for view %@", self);
        return nil;
    }
}

@end

NS_ASSUME_NONNULL_END

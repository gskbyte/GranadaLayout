#import "GRXLayoutParams.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSUInteger, GRXRelativeLayoutRule) {
    GRXRelativeLayoutRuleLeftOf = 0,
    GRXRelativeLayoutRuleRightOf,
    GRXRelativeLayoutRuleAbove,
    GRXRelativeLayoutRuleBelow,

    GRXRelativeLayoutRuleAlignLeft,
    GRXRelativeLayoutRuleAlignTop,
    GRXRelativeLayoutRuleAlignRight,
    GRXRelativeLayoutRuleAlignBottom,

    GRXRelativeLayoutRuleCount,
};

typedef NS_ENUM (NSUInteger, GRXRelativeLayoutParentRule) {
    GRXRelativeLayoutParentRuleAlignLeft = 0,
    GRXRelativeLayoutParentRuleAlignRight,
    GRXRelativeLayoutParentRuleAlignTop,
    GRXRelativeLayoutParentRuleAlignBottom,

    GRXRelativeLayoutParentRuleCenter,
    GRXRelativeLayoutParentRuleCenterHorizontal,
    GRXRelativeLayoutParentRuleCenterVertical,

    GRXRelativeLayoutParentRuleCount,
};


@interface GRXRelativeLayoutParams : GRXLayoutParams

// TODO use custom class / structure?
+ (NSArray<NSNumber *> *)verticalRules;
+ (NSArray<NSNumber *>  *)horizontalRules;

@property (nonatomic) CGFloat top, left, bottom, right;
@property (nonatomic, readonly) CGRect rect;

- (BOOL)hasRule:(GRXRelativeLayoutRule)rule;
- (UIView *)viewForRule:(GRXRelativeLayoutRule)rule;
- (void)setRule:(GRXRelativeLayoutRule)rule
        forView:(nullable __kindof UIView *)view;

- (BOOL)hasParentRule:(GRXRelativeLayoutParentRule)parentRule;
- (void)setParentRule:(GRXRelativeLayoutParentRule)parentRule;
- (void)setParentRule:(GRXRelativeLayoutParentRule)parentRule
               active:(BOOL)active;

@end

@interface UIView (GRXRelativeLayoutParams)

@property (nullable, nonatomic, readonly) GRXRelativeLayoutParams *grx_relativeLayoutParams;

@end

NS_ASSUME_NONNULL_END
#import "GRXLayoutParams.h"

typedef NS_ENUM(NSUInteger, GRXRelativeLayoutRule) {
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

typedef NS_ENUM(NSUInteger, GRXRelativeLayoutParentRule) {
    GRXRelativeLayoutParentRuleAlignLeft,
    GRXRelativeLayoutParentRuleAlignRight,
    GRXRelativeLayoutParentRuleAlignTop,
    GRXRelativeLayoutParentRuleAlignBottom,

    GRXRelativeLayoutParentRuleCenter,
    GRXRelativeLayoutParentRuleCenterHorizontal,
    GRXRelativeLayoutParentRuleCenterVertical,

    GRXRelativeLayoutParentRuleCount,
};



@interface GRXRelativeLayoutParams : GRXLayoutParams

@property (nonatomic) NSArray * rules;          // size GRXRelativeLayoutRuleCount
@property (nonatomic) NSArray * parentRules;    // sGRXRelativeLayoutParentRuleCount

- (BOOL) hasRule:(GRXRelativeLayoutRule)rule;
- (UIView*) viewForRule:(GRXRelativeLayoutRule)rule;
- (void) setView:(UIView*)view
         forRule:(GRXRelativeLayoutRule)rule;

- (BOOL) hasParentRule:(GRXRelativeLayoutParentRule)parentRule;
- (void) setParentRule:(GRXRelativeLayoutRule)parentRule
                active:(BOOL)active;

@end

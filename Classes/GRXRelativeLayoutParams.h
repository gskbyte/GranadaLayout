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

// TODO use C arrays?
+ (NSArray*) verticalRules;
+ (NSArray*) horizontalRules;

@property (nonatomic, readonly) NSArray * rules;          // size GRXRelativeLayoutRuleCount
@property (nonatomic, readonly) NSArray * parentRules;    // size GRXRelativeLayoutParentRuleCount

- (BOOL) hasRule:(GRXRelativeLayoutRule)rule;
- (UIView*) viewForRule:(GRXRelativeLayoutRule)rule;
- (void) setRule:(GRXRelativeLayoutRule)rule
         forView:(UIView*)view;

- (BOOL) hasParentRule:(GRXRelativeLayoutParentRule)parentRule;
- (void) setParentRule:(GRXRelativeLayoutParentRule)parentRule
                active:(BOOL)active;

@end

@interface UIView (GRXRelativeLayoutParams)

@property (nonatomic, readonly) GRXRelativeLayoutParams * grx_relativeLayoutParams;

@end
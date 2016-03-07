#import "GRXRelativeLayout+GRXLayoutInflater.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GRXRelativeLayout (GRXLayoutInflater)

static NSDictionary *RelativeRules = nil;
static NSDictionary *ParentRules = nil;

+ (void)initializeRuleDictionaries {
    RelativeRules = @{@"toLeftOf": @(GRXRelativeLayoutRuleLeftOf),
                      @"toRightOf": @(GRXRelativeLayoutRuleRightOf),
                      @"above": @(GRXRelativeLayoutRuleAbove),
                      @"below": @(GRXRelativeLayoutRuleBelow),

                      @"alignLeft": @(GRXRelativeLayoutRuleAlignLeft),
                      @"alignRight": @(GRXRelativeLayoutRuleAlignRight),
                      @"alignTop": @(GRXRelativeLayoutRuleAlignTop),
                      @"alignBottom": @(GRXRelativeLayoutRuleAlignBottom), };

    ParentRules = @{
        @"alignParentLeft": @(GRXRelativeLayoutParentRuleAlignLeft),
        @"alignParentRight": @(GRXRelativeLayoutParentRuleAlignRight),
        @"alignParentTop": @(GRXRelativeLayoutParentRuleAlignTop),
        @"alignParentBottom": @(GRXRelativeLayoutParentRuleAlignBottom),

        @"centerInParent": @(GRXRelativeLayoutParentRuleCenter),
        @"centerHorizontal": @(GRXRelativeLayoutParentRuleCenterHorizontal),
        @"centerVertical": @(GRXRelativeLayoutParentRuleCenterVertical),
    };
}

- (void)configureSubviewLayoutParams:(GRXLayoutParams *)params
                      fromDictionary:(NSDictionary *)dict
                          inInflater:(GRXLayoutInflater *)inflater {
    [super configureSubviewLayoutParams:params
                         fromDictionary:dict
                             inInflater:inflater];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.class initializeRuleDictionaries];
    });

    GRXRelativeLayoutParams *p = (GRXRelativeLayoutParams *)params;

    for (NSString *key in ParentRules.allKeys) {
        NSString *value = dict[key];
        if (value == nil) {
            continue;
        }

        if (value.boolValue) {
            GRXRelativeLayoutParentRule rule = [ParentRules[key] unsignedIntegerValue];
            [p setParentRule:rule];
        }
    }

    for (NSString *key in RelativeRules.allKeys) {
        NSString *viewId = dict[key];
        if (viewId == nil) {
            continue;
        }
        UIView *view = [self grx_subviewForIdentifier:viewId];
        if (view == nil) {
            NSLog(@"Warning: view not found for id %@ in GRXRelativeLayout", viewId);
            continue;
        }
        GRXRelativeLayoutRule rule = [RelativeRules[key] integerValue];
        [p setRule:rule forView:view];
    }
}

@end

NS_ASSUME_NONNULL_END

#import "GRXRelativeLayoutTestController.h"
#import "GRXRelativeLayout.h"

@implementation GRXRelativeLayoutTestController

+ (NSString *)selectionTitle {
    return @"RelativeLayout test 1";
}

+ (NSString *)selectionDetail {
    return @"";
}

- (GRXLayout *)initializeTopLayout {
    GRXLayout *top = [[GRXRelativeLayout alloc] initWithFrame:CGRectZero];
    return top;
}

- (GRXRelativeLayout *)topRelativeLayout {
    return (GRXRelativeLayout *)self.topLayout;
}

- (void)createViews {
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectZero];
    view1.backgroundColor = [UIColor blueColor];
    view1.grx_debugIdentifier = @"view1";
    GRXRelativeLayoutParams *params1 = [[GRXRelativeLayoutParams alloc] initWithSize:CGSizeMake(50, 50)];
    [params1 setParentRule:GRXRelativeLayoutParentRuleAlignTop active:YES];
    [params1 setParentRule:GRXRelativeLayoutParentRuleAlignRight active:YES];
    view1.grx_layoutParams = params1;
    [self.topLayout addSubview:view1];

    UIView *view2 = [[UIView alloc] initWithFrame:CGRectZero];
    view2.backgroundColor = [UIColor greenColor];
    view2.grx_debugIdentifier = @"view2";
    GRXRelativeLayoutParams *params2 = [[GRXRelativeLayoutParams alloc] initWithSize:CGSizeMake(70, 50)];
    [params2 setRule:GRXRelativeLayoutRuleBelow forView:view1];
    [params2 setRule:GRXRelativeLayoutRuleLeftOf forView:view1];
    view2.grx_layoutParams = params2;
    [self.topLayout addSubview:view2 ];

    UIView *view3 = [[UIView alloc] initWithFrame:CGRectZero];
    view3.backgroundColor = [UIColor redColor];
    view3.grx_debugIdentifier = @"view3";
    GRXRelativeLayoutParams *params3 = [[GRXRelativeLayoutParams alloc] initWithSize:CGSizeMake(50, 50)];
    [params3 setParentRule:GRXRelativeLayoutParentRuleCenterHorizontal active:YES];
    [params3 setRule:GRXRelativeLayoutRuleBelow forView:view2];
    view3.grx_layoutParams = params3;
    [self.topLayout addSubview:view3];
}



@end

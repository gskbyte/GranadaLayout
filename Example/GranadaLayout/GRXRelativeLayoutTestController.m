#import "GRXRelativeLayoutTestController.h"
#import "GRXRelativeLayout.h"

@implementation GRXRelativeLayoutTestController

+ (NSString *)selectionTitle {
    return @"RelativeLayout test 1";
}

+ (NSString *)selectionDetail {
    return @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (GRXLayout *) initializeTopLayout {
    GRXLayout * top = [[GRXRelativeLayout alloc] initWithFrame:CGRectZero];
    return top;
}

- (GRXRelativeLayout *)topRelativeLayout {
    return (GRXRelativeLayout *)self.topLayout;
}

-(void)createViews {
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectZero];
    view1.backgroundColor = [UIColor blueColor];
    view1.accessibilityLabel = @"view1";
    GRXRelativeLayoutParams * params1 = [[GRXRelativeLayoutParams alloc] initWithSize:CGSizeMake(200, 100)];
    [params1 setParentRule:GRXRelativeLayoutParentRuleAlignTop active:YES];
    [params1 setParentRule:GRXRelativeLayoutParentRuleAlignRight active:YES];
    [self.topLayout addSubview:view1 layoutParams:params1];

    UIView * view2 = [[UIView alloc] initWithFrame:CGRectZero];
    view2.backgroundColor = [UIColor greenColor];
    view2.accessibilityLabel = @"view2";
    GRXRelativeLayoutParams * params2 = [[GRXRelativeLayoutParams alloc] initWithSize:CGSizeMake(100, 140)];
    [params2 setRule:GRXRelativeLayoutRuleBelow forView:view1];
    [params2 setRule:GRXRelativeLayoutRuleLeftOf forView:view1];
    [self.topLayout addSubview:view2 layoutParams:params2];

    UIView * view3 = [[UIView alloc] initWithFrame:CGRectZero];
    view3.backgroundColor = [UIColor redColor];
    view3.accessibilityLabel = @"view3";
    GRXRelativeLayoutParams * params3 = [[GRXRelativeLayoutParams alloc] initWithSize:CGSizeMake(100, 200)];
    [params3 setParentRule:GRXRelativeLayoutParentRuleCenterHorizontal active:YES];
    [params3 setRule:GRXRelativeLayoutRuleBelow forView:view2];
    [self.topLayout addSubview:view3 layoutParams:params3];

}



@end

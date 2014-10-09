#import "GRXRelativeLayoutTestController2.h"
#import "GRXRelativeLayout.h"

@implementation GRXRelativeLayoutTestController2

+ (NSString *)selectionTitle {
    return @"RelativeLayout test 2";
}

+ (NSString *)selectionDetail {
    return @"A simple layout aligned to the left";
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [params1 setParentRule:GRXRelativeLayoutParentRuleAlignLeft active:YES];
    view1.grx_layoutParams = params1;
    [self.topLayout addSubview:view1];


    UIView *view2 = [[UIView alloc] initWithFrame:CGRectZero];
    view2.backgroundColor = [UIColor greenColor];
    view2.grx_debugIdentifier = @"view2";
    GRXRelativeLayoutParams *params2 = [[GRXRelativeLayoutParams alloc] initWithSize:CGSizeMake(40, 40)];
    [params2 setRule:GRXRelativeLayoutRuleBelow forView:view1];
    [params2 setRule:GRXRelativeLayoutRuleRightOf forView:view1];
    view2.grx_layoutParams = params2;
    [self.topLayout addSubview:view2];
}



@end

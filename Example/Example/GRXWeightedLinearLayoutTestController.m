#import "GRXWeightedLinearLayoutTestController.h"
#import "GRXLinearLayout.h"

@implementation GRXWeightedLinearLayoutTestController

+ (NSString *)selectionTitle {
    return @"weighted linear test 1";
}

+ (NSString *)selectionDetail {
    return @"Includes UIImageView and UISwitch";
}

- (GRXLayout *)initializeTopLayout {
    GRXLinearLayout *top = [[GRXLinearLayout alloc] initWithFrame:CGRectZero];
    top.direction = GRXLinearLayoutDirectionVertical;
    top.weightSum = 1;
    return top;
}

- (void)createViews {
    UIView *view0 = [[UIView alloc] initWithDefaultParamsInLayout:self.topLayout];
    view0.backgroundColor = [UIColor blueColor];
    view0.grx_linearLayoutParams.minSize = CGSizeMake(100, 50);
    view0.grx_linearLayoutParams.weight = 0.20;
    view0.grx_linearLayoutParams.gravity = GRXLinearLayoutGravityEnd;
    view0.grx_linearLayoutParams.margins = UIEdgeInsetsMake(0, 0, 10, 0);

    UIImageView *imageView = [[UIImageView alloc] initWithDefaultParamsInLayout:self.topLayout];
    imageView.image = [UIImage imageNamed:@"lab"];
    imageView.grx_linearLayoutParams.gravity = GRXLinearLayoutGravityEnd;
    imageView.grx_linearLayoutParams.weight = 0.30;

    UIView *view1 = [[UIView alloc] initWithDefaultParamsInLayout:self.topLayout];
    view1.backgroundColor = [UIColor greenColor];
    view1.grx_linearLayoutParams.minSize = CGSizeMake(30, 80);
    view1.grx_linearLayoutParams.weight = 0.4;

    UISwitch *sw = [[UISwitch alloc] initWithDefaultParamsInLayout:self.topLayout];
    sw.backgroundColor = UIColor.yellowColor;
    sw.grx_linearLayoutParams.minSize = CGSizeMake(200, 200);
    sw.grx_linearLayoutParams.margins = UIEdgeInsetsMake(5, 10, 30, 20);
    sw.grx_linearLayoutParams.gravity = GRXLinearLayoutGravityEnd;
}

@end

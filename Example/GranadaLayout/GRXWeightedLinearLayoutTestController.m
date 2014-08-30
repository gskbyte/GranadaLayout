#import "GRXWeightedLinearLayoutTestController.h"
#import "GRXWeightedLinearLayout.h"

@implementation GRXWeightedLinearLayoutTestController

+ (NSString *)selectionTitle {
    return @"Weighted linear test 1";
}

+ (NSString *)selectionDetail {
    return @"Includes UIImageView and UISwitch";
}

- (GRXLayout *) initializeTopLayout {
    GRXLayout * top = [[GRXWeightedLinearLayout alloc] initWithDirection:GRXLinearLayoutDirectionVertical
                                                                         weightSum:1];
    return top;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView * view0 = [[UIView alloc] initWithDefaultParamsInLayout:self.topLayout];
    view0.backgroundColor = [UIColor blueColor];
    view0.grx_weightedLinearLayoutParams.minSize = CGSizeMake(100, 50);
    view0.grx_weightedLinearLayoutParams.weight = 0.20;
    view0.grx_weightedLinearLayoutParams.gravity = GRXLinearLayoutGravityEnd;
    view0.grx_weightedLinearLayoutParams.margins = UIEdgeInsetsMake(0, 0, 10, 0);

    UIImageView * imageView = [[UIImageView alloc] initWithDefaultParamsInLayout:self.topLayout];
    imageView.image = [UIImage imageNamed:@"lab"];
    imageView.grx_weightedLinearLayoutParams.gravity = GRXLinearLayoutGravityEnd;
    imageView.grx_weightedLinearLayoutParams.weight = 0.30;

    UIView * view1 = [[UIView alloc] initWithDefaultParamsInLayout:self.topLayout];
    view1.backgroundColor = [UIColor greenColor];
    view1.grx_weightedLinearLayoutParams.minSize = CGSizeMake(30, 80);

    UISwitch * sw = [[UISwitch alloc] initWithDefaultParamsInLayout:self.topLayout];
    sw.backgroundColor = UIColor.yellowColor;
    sw.grx_weightedLinearLayoutParams.size = CGSizeMake(200, 200);
    sw.grx_weightedLinearLayoutParams.minSize = CGSizeMake(200, 200);
    sw.grx_weightedLinearLayoutParams.margins = UIEdgeInsetsMake(5, 10, 30, 20);
    sw.grx_weightedLinearLayoutParams.gravity = GRXLinearLayoutGravityEnd;
}

@end

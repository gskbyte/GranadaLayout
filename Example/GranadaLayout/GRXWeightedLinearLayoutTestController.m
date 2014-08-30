#import "GRXWeightedLinearLayoutTestController.h"
#import "GRXWeightedLinearLayout.h"

@implementation GRXWeightedLinearLayoutTestController {
    UIView * view0, *view1, *view2;
    UIImageView * image;
    UISwitch * sw;
}

+ (NSString *)selectionTitle {
    return @"Weighted linear test 1";
}

+ (NSString *)selectionDetail {
    return @"Includes UIImageView and UISwitch";
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.topLayout = [[GRXWeightedLinearLayout alloc] initWithDirection:GRXLinearLayoutDirectionVertical
                                                              weightSum:1];
    self.topLayout.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.topLayout];

    view0 = [[UIView alloc] initWithFrame:CGRectZero];
    view0.backgroundColor = [UIColor blueColor];

    GRXWeightedLinearLayoutParams * p0 = [[GRXWeightedLinearLayoutParams alloc] initWithSize:CGSizeMake(GRXWrapContent, GRXWrapContent)];
    p0.minSize = CGSizeMake(100, 50);
    p0.weight = 0.20;
    p0.gravity = GRXLinearLayoutGravityEnd;
    [self.topLayout addSubview:view0 layoutParams:p0];

    image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lab"]];
    GRXWeightedLinearLayoutParams * imageParams = [[GRXWeightedLinearLayoutParams alloc] init];
    imageParams.gravity = GRXLinearLayoutGravityEnd;
    imageParams.weight = 0.30;
    [self.topLayout addSubview:image layoutParams:imageParams];
//
//    view1 = [[UIView alloc] initWithFrame:CGRectZero];
//    view1.backgroundColor = [UIColor greenColor];
//
//    GRXWeightedLinearLayoutParams * p1 = [[GRXWeightedLinearLayoutParams alloc] init];
//    p1.minSize = CGSizeMake(30, 80);
//    [self.topLayout addSubview:view1 layoutParams:p1];
//
//
//    sw = [[UISwitch alloc] initWithFrame:CGRectZero];
//    sw.backgroundColor = UIColor.yellowColor;
//
//    GRXWeightedLinearLayoutParams * sw0 = [[GRXWeightedLinearLayoutParams alloc] init];
//    sw0.size = CGSizeMake(200, 200);
//    sw0.minSize = CGSizeMake(200, 200);
//    sw0.margins = UIEdgeInsetsMake(5, 10, 30, 20);
//    sw0.gravity = GRXLinearLayoutGravityEnd;
//    [self.topLayout addSubview:sw layoutParams:sw0];
}

@end

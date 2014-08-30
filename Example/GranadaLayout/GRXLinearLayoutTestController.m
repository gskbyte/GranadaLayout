#import "GRXLinearLayoutTestController.h"
#import "GRXLinearLayout.h"

@implementation GRXLinearLayoutTestController {
    UIView * view0, *view1, *view2;
    UIImageView * image;
    UISwitch * sw;
}

+ (NSString *)selectionTitle {
    return @"LinearLayout test 1";
}

+ (NSString *)selectionDetail {
    return @"Includes UIImageView and UISwitch";
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.topLayout = [[GRXLinearLayout alloc] initWithDirection:GRXLinearLayoutDirectionVertical];
    self.topLayout.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.topLayout];

    view0 = [[UIView alloc] initWithFrame:CGRectZero];
    view0.backgroundColor = [UIColor blueColor];

    GRXLinearLayoutParams * p0 = [[GRXLinearLayoutParams alloc] initWithSize:CGSizeMake(GRXWrapContent, GRXWrapContent)];
    p0.minSize = CGSizeMake(100, 50);
    p0.gravity = GRXLinearLayoutGravityCenter;
    p0.margins = UIEdgeInsetsMake(10, 0, 30, 0);
    [self.topLayout addSubview:view0 layoutParams:p0];

    image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lab"]];
    GRXLinearLayoutParams * imageParams = [[GRXLinearLayoutParams alloc] init];
    imageParams.gravity = GRXLinearLayoutGravityEnd;
    [self.topLayout addSubview:image layoutParams:imageParams];

    view1 = [[UIView alloc] initWithFrame:CGRectZero];
    view1.backgroundColor = [UIColor greenColor];

    GRXLinearLayoutParams * p1 = [[GRXLinearLayoutParams alloc] init];
    p1.minSize = CGSizeMake(30, 80);
    [self.topLayout addSubview:view1 layoutParams:p1];


    sw = [[UISwitch alloc] initWithFrame:CGRectZero];
    sw.backgroundColor = UIColor.yellowColor;

    GRXLinearLayoutParams * sw0 = [[GRXLinearLayoutParams alloc] init];
    sw0.size = CGSizeMake(200, 200);
    sw0.minSize = CGSizeMake(200, 200);
    sw0.margins = UIEdgeInsetsMake(5, 10, 30, 20);
    sw0.gravity = GRXLinearLayoutGravityEnd;
    [self.topLayout addSubview:sw layoutParams:sw0];
}

@end

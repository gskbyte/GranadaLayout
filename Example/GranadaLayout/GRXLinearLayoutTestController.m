#import "GRXLinearLayoutTestController.h"
#import "GRXLinearLayout.h"

@implementation GRXLinearLayoutTestController

+ (NSString *)selectionTitle {
    return @"LinearLayout test 1";
}

+ (NSString *)selectionDetail {
    return @"Includes UIImageView and UISwitch";
}

- (GRXLayout *) initializeTopLayout {
    GRXLayout * top = [[GRXLinearLayout alloc] initWithDirection:GRXLinearLayoutDirectionVertical];
    return top;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView * view0 = [[UIView alloc] initWithDefaultParamsInLayout:self.topLayout];
    view0.backgroundColor = [UIColor blueColor];
    view0.grx_linearLayoutParams.minSize = CGSizeMake(100, 50);
    view0.grx_linearLayoutParams.gravity = GRXLinearLayoutGravityCenter;
    view0.grx_linearLayoutParams.margins = UIEdgeInsetsMake(10, 0, 30, 0);

    UIImageView * imageView = [[UIImageView alloc] initWithDefaultParamsInLayout:self.topLayout];
    imageView.image = [UIImage imageNamed:@"lab"];
    imageView.grx_linearLayoutParams.gravity = GRXLinearLayoutGravityEnd;

    UIView * view1 = [[UIView alloc] initWithDefaultParamsInLayout:self.topLayout];
    view1.backgroundColor = [UIColor greenColor];
    view1.grx_linearLayoutParams.minSize = CGSizeMake(30, 80);

    UISwitch * sw = [[UISwitch alloc] initWithDefaultParamsInLayout:self.topLayout];
    sw.backgroundColor = UIColor.yellowColor;
    sw.grx_linearLayoutParams.size = CGSizeMake(200, 200);
    sw.grx_linearLayoutParams.minSize = CGSizeMake(200, 200);
    sw.grx_linearLayoutParams.margins = UIEdgeInsetsMake(5, 10, 30, 20);
    sw.grx_linearLayoutParams.gravity = GRXLinearLayoutGravityEnd;
}

@end

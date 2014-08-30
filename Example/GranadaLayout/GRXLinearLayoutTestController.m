#import "GRXLinearLayoutTestController.h"
#import "GRXLinearLayout.h"

@interface GRXLinearLayoutTestController () {
    GRXLinearLayout * layout;
    UIView * view0, *view1, *view2;
    UIImageView * image;
    UISwitch * sw;
}

@end

@implementation GRXLinearLayoutTestController

+ (NSString *)selectionTitle {
    return @"LinearLayout test 1";
}

+ (NSString *)selectionDetail {
    return @"Includes UIImageView and UISwitch";
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    layout = [[GRXLinearLayout alloc] initWithDirection:GRXLinearLayoutDirectionVertical];
    layout.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:layout];

    view0 = [[UIView alloc] initWithFrame:CGRectZero];
    view0.backgroundColor = [UIColor blueColor];

    GRXLinearLayoutParams * p0 = [[GRXLinearLayoutParams alloc] initWithSize:CGSizeMake(GRXWrapContent, GRXWrapContent)];
    p0.minSize = CGSizeMake(100, 50);
    p0.gravity = GRXLinearLayoutGravityCenter;
    p0.margins = UIEdgeInsetsMake(10, 0, 30, 0);
    [layout addSubview:view0 layoutParams:p0];

    image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lab"]];
    GRXLinearLayoutParams * imageParams = [[GRXLinearLayoutParams alloc] init];
    imageParams.gravity = GRXLinearLayoutGravityEnd;
    [layout addSubview:image layoutParams:imageParams];

    view1 = [[UIView alloc] initWithFrame:CGRectZero];
    view1.backgroundColor = [UIColor greenColor];

    GRXLinearLayoutParams * p1 = [[GRXLinearLayoutParams alloc] init];
    p1.minSize = CGSizeMake(30, 80);
    [layout addSubview:view1 layoutParams:p1];


    sw = [[UISwitch alloc] initWithFrame:CGRectZero];
    sw.backgroundColor = UIColor.yellowColor;

    GRXLinearLayoutParams * sw0 = [[GRXLinearLayoutParams alloc] init];
    sw0.size = CGSizeMake(200, 200);
    sw0.minSize = CGSizeMake(200, 200);
    sw0.margins = UIEdgeInsetsMake(5, 10, 30, 20);
    sw0.gravity = GRXLinearLayoutGravityEnd;
    [layout addSubview:sw layoutParams:sw0];

}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    layout.frame = CGRectMake(0, 60, self.view.width, self.view.height-60);
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect swf = sw.frame;
    NSLog(@"%f %f  -  %f %f", swf.origin.x, swf.origin.y, swf.size.width, swf.size.height);
}

@end

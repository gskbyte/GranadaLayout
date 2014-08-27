#import "GRXViewController.h"
#import "GRXLinearLayout.h"

@interface GRXViewController () {
    GRXLinearLayout * layout;
    UIView * view0, *view1, *view2;
    UIImageView * image;
}

@end

@implementation GRXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    layout = [[GRXLinearLayout alloc] initWithDirection:GRXLinearLayoutDirectionVertical];
    layout.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:layout];

    view0 = [[UIView alloc] initWithFrame:CGRectZero];
    view0.backgroundColor = [UIColor blueColor];

    GRXLinearLayoutParams * p0 = [[GRXLinearLayoutParams alloc] initWithSize:CGSizeMake(GRXMatchParent, GRXWrapContent)];
    p0.minSize = CGSizeMake(100, 50);
    p0.margins = UIEdgeInsetsMake(10, 20, 30, 40);
    [layout addSubview:view0 layoutParams:p0];

    image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lab"]];
    GRXLinearLayoutParams * imageParams = [[GRXLinearLayoutParams alloc] init];
    [layout addSubview:image layoutParams:imageParams];

    view1 = [[UIView alloc] initWithFrame:CGRectZero];
    view1.backgroundColor = [UIColor greenColor];

    GRXLinearLayoutParams * p1 = [[GRXLinearLayoutParams alloc] init];
    p1.minSize = CGSizeMake(30, 80);
    [layout addSubview:view1 layoutParams:p1];


}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    layout.frame = self.view.frame;
}

@end

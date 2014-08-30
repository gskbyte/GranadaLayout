#import "GRXUILabelTestViewController.h"
#import "GRXLinearLayout.h"

@interface GRXUILabelTestViewController ()

@end

@implementation GRXUILabelTestViewController

+ (NSString *)selectionTitle {
    return @"UILabel height test";
}

+ (NSString *)selectionDetail {
    return @"Tests height calculation for UILabels";
}


- (GRXLayout *) initializeTopLayout {
    GRXLayout * top = [[GRXLinearLayout alloc] initWithDirection:GRXLinearLayoutDirectionVertical];
    return top;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView * view0 = [[UIView alloc] initWithFrame:CGRectZero];
    view0.backgroundColor = [UIColor blueColor];

    GRXLinearLayoutParams * p0 = [[GRXLinearLayoutParams alloc] initWithSize:CGSizeMake(GRXWrapContent, GRXWrapContent)];
    p0.minSize = CGSizeMake(100, 50);
    p0.gravity = GRXLinearLayoutGravityCenter;
    p0.margins = UIEdgeInsetsMake(10, 0, 30, 0);
    [self.topLayout addSubview:view0 layoutParams:p0];

    

    UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lab"]];
    GRXLinearLayoutParams * imageParams = [[GRXLinearLayoutParams alloc] init];
    imageParams.gravity = GRXLinearLayoutGravityEnd;
    [self.topLayout addSubview:image layoutParams:imageParams];

    UIView * view1 = [[UIView alloc] initWithFrame:CGRectZero];
    view1.backgroundColor = [UIColor greenColor];
    
}
@end

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

- (void)createViews {
    [super createViews];

    UILabel * label0 = [[UILabel alloc] initWithDefaultParamsInLayout:self.topLayout];
    label0.text = @"test size WW for 1 line";
    label0.numberOfLines = 1;
    label0.grx_linearLayoutParams.minSize = CGSizeMake(100, 40);
    label0.backgroundColor = [UIColor greenColor];

    UILabel * label1 = [[UILabel alloc] initWithDefaultParamsInLayout:self.topLayout];
    label1.text = @"test size MW for 1 line";
    label1.numberOfLines = 1;
    label1.grx_linearLayoutParams.width = GRXMatchParent;
    label1.backgroundColor = [UIColor redColor];
}
@end

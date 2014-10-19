#import "GRXLinearLayoutInflaterAnimationController.h"
#import "GRXLinearLayout.h"

@implementation GRXLinearLayoutInflaterAnimationController

+ (NSString *)selectionTitle {
    return @"Linear inflation";
}

+ (NSString *)selectionDetail {
    return @"Features an animation on direction change";
}

- (NSString *)layoutFileNameInBundle {
    return @"linear_test_1.grx";
}

- (void)createViews {
    UIImageView *imageView = [self.layoutInflater viewForIdentifier:@"image"];
    imageView.image = [UIImage imageNamed:@"power.png"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *directionButton = [[UIBarButtonItem alloc] initWithTitle:@"change"
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(switchDirection)];
    self.navigationItem.rightBarButtonItem = directionButton;
}

- (void)switchDirection {
    GRXLinearLayout *linear = (GRXLinearLayout *)self.topLayout;
    if (linear.direction == GRXLinearLayoutDirectionVertical) {
        linear.direction = GRXLinearLayoutDirectionHorizontal;
    } else {
        linear.direction = GRXLinearLayoutDirectionVertical;
    }

    [UIView animateWithDuration:1 animations:^{
        [linear layoutIfNeeded];
    }];
}

@end

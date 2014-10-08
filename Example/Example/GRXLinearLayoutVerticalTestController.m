#import "GRXLinearLayoutVerticalTestController.h"
#import "GRXLinearLayout.h"

@implementation GRXLinearLayoutVerticalTestController

+ (NSString *)selectionTitle {
    return @"LinearLayout vertical test";
}

+ (NSString *)selectionDetail {
    return @"Tests a vertical layout without weights";
}

- (NSString *)layoutFileNameInBundle {
    return @"linear_test_1.grx";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureDirectionButton];
}

- (GRXLinearLayout *)topLinearLayout {
    return (GRXLinearLayout *)self.topLayout;
}

- (void)configureDirectionButton {
    NSString *title;
    if (self.topLinearLayout.direction == GRXLinearLayoutDirectionVertical) {
        title = @"Set horizontal";
    } else {
        title = @"Set vertical";
    }
    self.navigationItem.rightBarButtonItem =     [[UIBarButtonItem alloc] initWithTitle:title
                                                                                  style:UIBarButtonItemStyleDone
                                                                                 target:self
                                                                                 action:@selector(changeLayoutDirection)];
}

- (void)changeLayoutDirection {
    if (self.topLinearLayout.direction == GRXLinearLayoutDirectionVertical) {
        self.topLinearLayout.direction = GRXLinearLayoutDirectionHorizontal;
    } else {
        self.topLinearLayout.direction = GRXLinearLayoutDirectionVertical;
    }
    [self.topLinearLayout layoutIfNeeded];
    [self configureDirectionButton];
}

- (void)createViews {
    UIImageView *iv = [self.layoutInflater viewForIdentifier:@"image"];
    iv.image = [UIImage imageNamed:@"lab.png"];
}


@end

#import "GRXRelativeLayoutInflaterAnimationController.h"
#import <GranadaLayout/GRXRelativeLayout.h>
#import <GranadaLayout/GRXTextView.h>

#import "GRXTextGenerator.h"

@interface GRXRelativeLayoutInflaterAnimationController ()

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) GRXTextView *titleView;
@property (nonatomic) UILabel *subtitleView;

@end

@implementation GRXRelativeLayoutInflaterAnimationController

+ (NSString *)selectionTitle {
    return @"Relative inflation";
}

+ (NSString *)selectionDetail {
    return @"Features an animation on attribute change";
}

- (NSString *)layoutFileNameInBundle {
    return @"relative_test_2.grx";
}

- (void)createViews {
    self.imageView = [self.layoutInflater viewForIdentifier:@"image"];
    self.imageView.image = [UIImage imageNamed:@"lab.png"];

    self.titleView = [self.layoutInflater viewForIdentifier:@"title"];
    self.titleView.font = [UIFont systemFontOfSize:14];

    self.subtitleView = [self.layoutInflater viewForIdentifier:@"subtitle"];
    self.subtitleView.numberOfLines = 10;
    self.subtitleView.font = [UIFont systemFontOfSize:12];
    [self generateText];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *directionButton = [[UIBarButtonItem alloc] initWithTitle:@"move image"
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(moveImage)];
    self.navigationItem.rightBarButtonItem = directionButton;
}

- (void)moveImage {
    GRXRelativeLayout *relative = (GRXRelativeLayout *)self.topLayout;
    GRXRelativeLayoutParams *imageParams = self.imageView.grx_relativeLayoutParams;
    UIEdgeInsets imageMargins = imageParams.margins;
    GRXRelativeLayoutParams *titleParams = self.titleView.grx_relativeLayoutParams;

    if ([imageParams hasParentRule:GRXRelativeLayoutParentRuleAlignLeft]) {
        imageMargins.right = 0;
        imageMargins.left = 8;

        [imageParams setParentRule:GRXRelativeLayoutParentRuleAlignLeft active:NO];
        [imageParams setParentRule:GRXRelativeLayoutParentRuleAlignRight active:YES];
        [imageParams setParentRule:GRXRelativeLayoutParentRuleCenterVertical active:YES];
        [imageParams setParentRule:GRXRelativeLayoutParentRuleAlignTop active:NO];

        [titleParams setRule:GRXRelativeLayoutRuleRightOf forView:nil];
        [titleParams setRule:GRXRelativeLayoutRuleLeftOf forView:self.imageView];
    } else {
        imageMargins.right = 8;
        imageMargins.left = 0;

        [imageParams setParentRule:GRXRelativeLayoutParentRuleAlignLeft active:YES];
        [imageParams setParentRule:GRXRelativeLayoutParentRuleAlignRight active:NO];
        [imageParams setParentRule:GRXRelativeLayoutParentRuleCenterVertical active:NO];
        [imageParams setParentRule:GRXRelativeLayoutParentRuleAlignTop active:YES];

        [titleParams setRule:GRXRelativeLayoutRuleRightOf forView:self.imageView];
        [titleParams setRule:GRXRelativeLayoutRuleLeftOf forView:nil];
    }
    imageParams.margins = imageMargins;
    [self generateText];

    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [relative layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (void)generateText {
    self.titleView.text = [GRXTextGenerator stringWithMinimumWords:8 maxWords:15];
    self.subtitleView.text = [GRXTextGenerator stringWithMinimumWords:20 maxWords:40];
}

@end

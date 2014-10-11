#import "GRXRelativeLayoutTestController3.h"
#import "GRXRelativeLayout.h"

typedef NS_ENUM (NSUInteger, GRXRelativeLayoutTestControllerMode) {
    GRXRelativeLayoutTestControllerMode0 = 0,
    GRXRelativeLayoutTestControllerMode1,

    GRXRelativeLayoutTestControllerModeCount
};

@interface GRXRelativeLayoutTestController3 ()

@property (nonatomic) GRXRelativeLayoutTestControllerMode mode;
@property (nonatomic) BOOL animate;
@property (nonatomic) UIBarButtonItem *animateItem, *modeItem;

@end

@implementation GRXRelativeLayoutTestController3

+ (NSString *)selectionTitle {
    return @"RelativeLayout test 3";
}

+ (NSString *)selectionDetail {
    return @"Showcases layout change and animations";
}

- (void)viewDidLoad {
    self.views = [NSMutableArray array];
    [super viewDidLoad];

    self.animateItem = [[UIBarButtonItem alloc] initWithTitle:@"Anim"
                                                        style:UIBarButtonItemStyleDone
                                                       target:self
                                                       action:@selector(toggleAnimation)];
    self.animate = NO;

    self.modeItem = [[UIBarButtonItem alloc] initWithTitle:@"mode"
                                                     style:UIBarButtonItemStyleDone
                                                    target:self
                                                    action:@selector(setNextMode)];
    self.navigationItem.rightBarButtonItems = @[self.animateItem, self.modeItem];
    self.mode = GRXRelativeLayoutTestControllerMode0;
}

- (void)toggleAnimation {
    self.animate = !self.animate;
}

- (void)setAnimate:(BOOL)animate {
    _animate = animate;
    self.animateItem.title = [NSString stringWithFormat:@"anim %@", self.animate ? @"on":@"off"];
}

- (GRXLayout *)initializeTopLayout {
    GRXLayout *top = [[GRXRelativeLayout alloc] initWithFrame:CGRectZero];
    return top;
}

- (GRXRelativeLayout *)topRelativeLayout {
    return (GRXRelativeLayout *)self.topLayout;
}

- (void)createViews {
    UIView *view0 = [[UIView alloc] initWithFrame:CGRectZero];
    view0.backgroundColor = [UIColor blueColor];
    view0.grx_debugIdentifier = @"view0";
    [self.topLayout addSubview:view0];
    [self.views addObject:view0];

    UIView *view1 = [[UIView alloc] initWithFrame:CGRectZero];
    view1.backgroundColor = [UIColor greenColor];
    view1.grx_debugIdentifier = @"view1";
    [self.topLayout addSubview:view1];
    [self.views addObject:view1];

    UILabel *view2 = [[UILabel alloc] initWithFrame:CGRectZero];
    view2.backgroundColor = [UIColor redColor];
    view2.grx_debugIdentifier = @"view2";
    view2.text = @"view2 is in da haus";
    [self.topLayout addSubview:view2];
    [self.views addObject:view2];

    UIImageView *view3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lab.png"]];
    view3.grx_debugIdentifier = @"image";
    [self.topLayout addSubview:view3];
    [self.views addObject:view3];

    [self adjustLayoutForCurrentMode];
}

- (void)setNextMode {
    self.mode = (self.mode + 1) % GRXRelativeLayoutTestControllerModeCount;
}

- (void)setMode:(GRXRelativeLayoutTestControllerMode)mode {
    _mode = mode;
    self.modeItem.title = [NSString stringWithFormat:@"mode %zd", self.mode];

    [UIView animateWithDuration:self.animate ? 1:0 delay:0 options:0 animations:^{
        [self adjustLayoutForCurrentMode];
        if (self.animate) {
            [self.topLayout layoutSubviews];
        }
    } completion:^(BOOL finished) {
    }];
}

- (void)adjustLayoutForCurrentMode {
    UIView *view0 = self.views[0];
    UIView *view1 = self.views[1];
    UIView *view2 = self.views[2];
    UIView *view3 = self.views[3];

    switch (self.mode) {
        case GRXRelativeLayoutTestControllerMode0 : {
                GRXRelativeLayoutParams *p0 = [[GRXRelativeLayoutParams alloc] initWithSize:CGSizeMake(50, 50)];
                [p0 setParentRule:GRXRelativeLayoutParentRuleAlignTop];
                [p0 setParentRule:GRXRelativeLayoutParentRuleCenterHorizontal];
                p0.margins = UIEdgeInsetsMake(0, 50, 0, 0);
                view0.grx_layoutParams = p0;

                GRXRelativeLayoutParams *p1 = [[GRXRelativeLayoutParams alloc] initWithSize:CGSizeMake(40, 40)];
                [p1 setRule:GRXRelativeLayoutRuleBelow forView:view0];
                [p1 setRule:GRXRelativeLayoutRuleLeftOf forView:view0];
                view1.grx_layoutParams = p1;

                GRXRelativeLayoutParams *p2 = [[GRXRelativeLayoutParams alloc] initWithSize:CGSizeMake(GRXMatchParent, 70)];
                [p2 setParentRule:GRXRelativeLayoutParentRuleAlignBottom];
                p2.margins = UIEdgeInsetsMake(0, 10, 15, 0);
                view2.grx_layoutParams = p2;

                GRXRelativeLayoutParams *p3 = [[GRXRelativeLayoutParams alloc] initWithSize:CGSizeMake(GRXWrapContent, GRXWrapContent)];
                [p3 setParentRule:GRXRelativeLayoutParentRuleCenter];
                view3.grx_layoutParams = p3;
        }
            break;
        case GRXRelativeLayoutTestControllerMode1 : {
                GRXRelativeLayoutParams *p1 = [[GRXRelativeLayoutParams alloc] initWithSize:CGSizeMake(100, 60)];
                [p1 setParentRule:GRXRelativeLayoutParentRuleAlignRight];
                [p1 setParentRule:GRXRelativeLayoutParentRuleAlignBottom];
                p1.margins = UIEdgeInsetsMake(10, 10, 10, 10);
                view1.grx_layoutParams = p1;

                GRXRelativeLayoutParams *p0 = [[GRXRelativeLayoutParams alloc] initWithSize:CGSizeMake(50, 120)];
                [p0 setRule:GRXRelativeLayoutRuleAbove forView:view1];
                [p0 setRule:GRXRelativeLayoutRuleLeftOf forView:view1];
                view0.grx_layoutParams = p0;

                GRXRelativeLayoutParams *p2 = [[GRXRelativeLayoutParams alloc] initWithSize:CGSizeMake(GRXWrapContent, 70)];
                [p2 setParentRule:GRXRelativeLayoutParentRuleAlignLeft];
                [p2 setRule:GRXRelativeLayoutRuleAbove forView:view0];
                view2.grx_layoutParams = p2;

                GRXRelativeLayoutParams *p3 = [[GRXRelativeLayoutParams alloc] initWithSize:CGSizeMake(GRXMatchParent, GRXWrapContent)];
                [p3 setParentRule:GRXRelativeLayoutParentRuleAlignLeft];
                [p3 setParentRule:GRXRelativeLayoutParentRuleAlignTop];
                view3.grx_layoutParams = p3;
        }
            break;

        default:
            break;
    }
}


@end

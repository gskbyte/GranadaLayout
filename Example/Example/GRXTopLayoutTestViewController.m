#import "GRXTopLayoutTestViewController.h"
#import "GRXLayout.h"

@implementation GRXTopLayoutTestViewController

+ (NSString *)selectionTitle {
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = [self.class selectionTitle];
    self.view.backgroundColor = [UIColor lightGrayColor];

    _topLayout = [self initializeTopLayout];
    if (_topLayout != nil) {
        _topLayout.clipsToBounds = YES;
        [self.view addSubview:_topLayout];
    }
    [self createViews];
}

- (GRXLayout *)initializeTopLayout {
    NSAssert(NO, @"implement -initializeTopLayout");
    return nil;
}

- (void)createViews {
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.topLayout.top = 64;
}

@end

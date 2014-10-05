#import "GRXTestViewController.h"
#import "GRXLayout.h"

@implementation GRXTestViewController

+ (NSString *)selectionTitle {
    return NSStringFromClass(self.class);
}

+ (NSString *)selectionDetail {
    return @"";
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
    self.topLayout.top = 200;
}

@end

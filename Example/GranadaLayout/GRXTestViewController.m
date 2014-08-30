#import "GRXTestViewController.h"
#import "GRXLayout.h"

@implementation GRXTestViewController

+ (NSString *)selectionTitle {
    return NSStringFromClass(self.class);
}

+ (NSString *)selectionDetail {
    return @"";
}

- (void) viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = [self.class selectionTitle];
    self.view.backgroundColor = [UIColor lightGrayColor];

    _topLayout = [self initializeTopLayout];
    if(_topLayout != nil) {
        [self.view addSubview:_topLayout];
    }
}

- (GRXLayout *) initializeTopLayout {
    return nil;
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.topLayout.frame = CGRectMake(0, 60, self.view.width, self.view.height-60);
}

@end

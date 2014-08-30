#import "GRXTestViewController.h"
#import "GRXLayout.h"

@implementation GRXTestViewController

+ (NSString *)selectionTitle {
    return NSStringFromClass(self.class);
}

+ (NSString *)selectionDetail {
    return @"";
}



- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.topLayout.frame = CGRectMake(0, 60, self.view.width, self.view.height-60);
}
@end

#import "GRXBaseInflationTestController.h"

@interface GRXBaseInflationTestController ()

@end

@implementation GRXBaseInflationTestController

- (NSString *)layoutFileNameInBundle {
    return @"";
}

- (void)viewDidLoad {
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *path = [bundle pathForResource:[self layoutFileNameInBundle]
                                      ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    self.layoutInflater = [[GRXLayoutInflater alloc] initWithData:data];
    [super viewDidLoad];
}

- (GRXLayout *)initializeTopLayout {
    return (GRXLayout *)self.layoutInflater.rootView;
}

- (void)createViews {
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%@", self.topLayout.grx_debugDescription);
}

@end

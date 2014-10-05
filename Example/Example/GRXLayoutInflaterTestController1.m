#import "GRXLayoutInflaterTestController1.h"
#import <GRXLayoutInflater.h>

@interface GRXLayoutInflaterTestController1 ()

@property (nonatomic) GRXLayoutInflater *layoutInflater;

@end

@implementation GRXLayoutInflaterTestController1

+ (NSString *)selectionTitle {
    return @"Inflation test 1";
}

+ (NSString *)selectionDetail {
    return @"Inflates a layout from a file";
}

- (void)viewDidLoad {
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *path = [bundle pathForResource:@"prototype.grx" ofType:nil];
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
    NSLog(@"%@", self.view.debugDescription);
}

@end

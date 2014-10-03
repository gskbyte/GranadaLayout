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
    UIImageView *image = [self.layoutInflater viewForIdentifier:@"image"];
    image.image = [UIImage imageNamed:@"lab.png"];

    UISwitch *sw = [self.layoutInflater viewForIdentifier:@"switch"];
    sw.backgroundColor = [UIColor greenColor];

    UIView *view = [self.layoutInflater viewForIdentifier:@"view"];
    view.backgroundColor = [UIColor redColor];
}

@end

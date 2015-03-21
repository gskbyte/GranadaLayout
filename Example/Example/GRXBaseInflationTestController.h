#import "GRXTopLayoutTestViewController.h"
#import <GranadaLayout/GranadaLayout.h>

@interface GRXBaseInflationTestController : GRXTopLayoutTestViewController

@property (nonatomic) GRXLayoutInflater *layoutInflater;

- (NSString *)layoutFileNameInBundle;

@end

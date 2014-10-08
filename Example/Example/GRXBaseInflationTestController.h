#import "GRXTopLayoutTestViewController.h"
#import <GRXLayoutInflater.h>

@interface GRXBaseInflationTestController : GRXTopLayoutTestViewController

@property (nonatomic) GRXLayoutInflater *layoutInflater;

- (NSString*) layoutFileNameInBundle;

@end

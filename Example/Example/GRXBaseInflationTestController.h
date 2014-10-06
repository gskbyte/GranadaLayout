#import "GRXTestViewController.h"
#import <GRXLayoutInflater.h>

@interface GRXBaseInflationTestController : GRXTestViewController

@property (nonatomic) GRXLayoutInflater *layoutInflater;

- (NSString*) layoutFileNameInBundle;

@end

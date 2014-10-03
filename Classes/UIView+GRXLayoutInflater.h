#import <UIKit/UIKit.h>
#import "GRXLayoutParams.h"

@interface UIView (GRXLayoutInflater)

- (void)grx_configureFromDictionary:(NSDictionary *)dictionary;

@end

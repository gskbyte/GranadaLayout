#import "GRXRelativeLayout+GRXLayoutInflater.h"
#import "GRXLayout+GRXLayoutInflater.h"

@implementation GRXRelativeLayout (GRXLayoutInflater)

+ (void) parseParamsFromDictionary:(NSDictionary*)dictionary
                   forLayoutParams:(GRXLayoutParams*)params {
    [GRXLayout.class parseParamsFromDictionary:dictionary
                               forLayoutParams:params];
    
}

@end

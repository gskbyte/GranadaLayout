#import "GRXLayout.h"

@interface GRXLayout (GRXLayoutInflater)

// method to be overriden by subclasses
+ (void) parseParamsFromDictionary:(NSDictionary*)dictionary
                   forLayoutParams:(GRXLayoutParams*)params;

// should not be overriden, uses [self.class layoutParamsClass]
+ (GRXLayoutParams*) layoutParamsForSubviewFromDictionary:(NSDictionary*)dictionary;

@end

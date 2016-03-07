#import "GRXLayout.h"
#import "UIView+GRXLayoutInflater.h"
#import "GRXLayoutInflater.h"

NS_ASSUME_NONNULL_BEGIN

@interface GRXLayout (GRXLayoutInflater)

- (void)configureSubviewLayoutParams:(GRXLayoutParams *)params
                      fromDictionary:(NSDictionary *)dictionary
                          inInflater:(GRXLayoutInflater *)inflater;
+ (void)configureUnparentedLayoutParams:(GRXLayoutParams *)params
                         fromDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END

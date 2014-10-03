#import <GranadaLayout/GRXLayoutInflater.h>

@interface GRXTestHelper : NSObject

+ (GRXLayoutInflater *)inflaterForFileWithName:(NSString *)filename;
+ (id)rootViewForLayoutFileWithName:(NSString *)filename;

@end

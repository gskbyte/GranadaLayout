#import <GranadaLayout/GRXLayoutInflater.h>

@interface GRXTestHelper : NSObject

+ (UIImage *)imageWithName:(NSString *)filename;
+ (GRXLayoutInflater *)inflaterForFileWithName:(NSString *)filename;
+ (id)rootViewForLayoutFileWithName:(NSString *)filename;

@end

#import <GranadaLayout/GRXLayoutInflater.h>

@interface GRXTestHelper : NSObject

+ (UIImage *)imageWithName:(NSString *)filename;
+ (GRXLayoutInflater *)inflaterForFileWithName:(NSString *)filename;
+ (GRXLayoutInflater *)inflaterForFileWithName:(NSString *)filename
                                      rootView:(UIView*)rootView;
+ (id)rootViewForLayoutFileWithName:(NSString *)filename;

@end

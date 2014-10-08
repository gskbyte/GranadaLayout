#import <UIKit/UIKit.h>

@protocol GRXTestViewControllerProtocol <NSObject>

+ (NSString *)selectionTitle; // return nil to not appear in the list

@optional
+ (NSString *)selectionDetail;

@end
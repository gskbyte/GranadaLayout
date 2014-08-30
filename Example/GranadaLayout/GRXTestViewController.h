#import <UIKit/UIKit.h>

@class GRXLayout;

@interface GRXTestViewController : UIViewController

+(NSString *) selectionTitle;
+(NSString *) selectionDetail;

@property (nonatomic) GRXLayout * topLayout;

@end

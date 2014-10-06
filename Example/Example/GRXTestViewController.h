#import <UIKit/UIKit.h>
#import "GRXLayout.h"

@interface GRXTestViewController : UIViewController

+ (NSString *)selectionTitle;
+ (NSString *)selectionDetail;

@property (nonatomic, readonly) GRXLayout *topLayout;

- (GRXLayout *)initializeTopLayout;
- (void)createViews;

@end

#import <UIKit/UIKit.h>

@class GRXLayout;

@interface GRXTestViewController : UIViewController

+ (NSString *)selectionTitle;
+ (NSString *)selectionDetail;

@property (nonatomic, readonly) GRXLayout *topLayout;

- (GRXLayout *)initializeTopLayout;
- (void)createViews;

@end

#import <UIKit/UIKit.h>
#import "GRXLayout.h"
#import "GRXTestViewController.h"

@interface GRXTopLayoutTestViewController : UIViewController <GRXTestViewControllerProtocol>

@property (nonatomic, readonly) GRXLayout *topLayout;

- (GRXLayout *)initializeTopLayout;
- (void)createViews;

@end

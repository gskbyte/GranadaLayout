#import "GRXAppDelegate.h"
#import "GRXSelectionViewController.h"

@implementation GRXAppDelegate

- (BOOL)              application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (NSClassFromString(@"XCTestCase")) {
        return YES;
    }

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    GRXSelectionViewController *root = [[GRXSelectionViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:root];
    self.window.rootViewController = nav;

    return YES;
}

@end

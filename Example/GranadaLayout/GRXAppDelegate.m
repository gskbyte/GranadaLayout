#import "GRXAppDelegate.h"
#import "GRXViewController.h"

@implementation GRXAppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    GRXViewController * root = [[GRXViewController alloc] init];
    self.window.rootViewController = root;

    return YES;
}

@end

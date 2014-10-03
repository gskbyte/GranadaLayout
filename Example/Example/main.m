#import <UIKit/UIKit.h>
#import "GRXAppDelegate.h"
#import "GRXTestAppDelegate.h"

int main(int argc, char *argv[]) {
    @autoreleasepool {
        BOOL runningTests = NSClassFromString(@"XCTestCase") != nil;
        if(runningTests) {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([GRXTestAppDelegate class]));
        } else {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([GRXAppDelegate class]));
        }

    }

    
}

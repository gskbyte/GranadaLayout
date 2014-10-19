#import <UIKit/UIKit.h>

@interface GRXLayoutInflater : NSObject

@property (nonatomic, readonly) id rootView; // UIView* instance

+ (BOOL)areDebugOptionsEnabled;
+ (void)setDebugOptionsEnabled:(BOOL)active;


- (instancetype)initWithData:(NSData *)data
                    rootView:(UIView*)rootView;
- (instancetype)initWithBundleFile:(NSString *)filename
                          rootView:(UIView*)rootView;
- (instancetype)initWithFile:(NSString *)filename
                  fromBundle:(NSBundle *)bundle
                    rootView:(UIView*)rootView;

// same result as calling previous initializers with rootView=nil
- (instancetype)initWithData:(NSData *)data;
- (instancetype)initWithBundleFile:(NSString *)filename;
- (instancetype)initWithFile:(NSString *)filename
                  fromBundle:(NSBundle *)bundle;

- (id)viewForIdentifier:(NSString *)identifier;



@end

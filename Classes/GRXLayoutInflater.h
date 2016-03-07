#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GRXLayoutInflater : NSObject

@property (nullable, nonatomic, readonly) NSError *parseError;
@property (nullable, nonatomic, readonly) UIView *rootView;

+ (BOOL)areDebugOptionsEnabled;
+ (void)setDebugOptionsEnabled:(BOOL)active;

- (instancetype)initWithData:(NSData *)data
                    rootView:(nullable __kindof UIView *)rootView;
- (instancetype)initWithBundleFile:(NSString *)filename
                          rootView:(nullable __kindof UIView *)rootView;
- (instancetype)initWithFile:(NSString *)filename
                  fromBundle:(NSBundle *)bundle
                    rootView:(nullable __kindof UIView *)rootView;

// same result as calling previous initializers with rootView=nil
- (instancetype)initWithData:(NSData *)data;
- (instancetype)initWithBundleFile:(NSString *)filename;
- (instancetype)initWithFile:(NSString *)filename
                  fromBundle:(NSBundle *)bundle;

- (nullable __kindof UIView *)viewWithIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END

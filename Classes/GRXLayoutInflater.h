#import <UIKit/UIKit.h>

@interface GRXLayoutInflater : NSObject

@property (nonatomic, readonly) id rootView; // UIView* instance

- (instancetype)initWithData:(NSData *)data;
- (instancetype)initWithBundleFile:(NSString *)filename;
- (instancetype)initWithFile:(NSString *)filename fromBundle:(NSBundle *)bundle;

- (id)viewForIdentifier:(NSString *)identifier;

@end

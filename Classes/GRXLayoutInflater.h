#import <UIKit/UIKit.h>

@interface GRXLayoutInflater : NSObject

@property (nonatomic, readonly) UIView *rootView;

- (instancetype)initWithData:(NSData *)data;
- (instancetype)initWithBundleFile:(NSString *)filename;

- (id)viewForIdentifier:(NSString *)identifier;

@end

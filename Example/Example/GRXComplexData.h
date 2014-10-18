#import <UIKit/UIKit.h>

@interface GRXComplexDataHeader : NSObject

@property (nonatomic) UIImage *image;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *message;
@property (nonatomic) NSDate *date;

@property (nonatomic, readonly) NSString *formattedDate;

@end

@interface GRXComplexDataBody : NSObject

@property (nonatomic) UIImage *image;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *subtitle;
@property (nonatomic) NSURL *url;

@end

@interface GRXComplexData : NSObject

@property (nonatomic) GRXComplexDataHeader *header;
@property (nonatomic) NSArray *bodies;

+ (NSArray*)generateDataWithCount:(NSUInteger)count;

@end

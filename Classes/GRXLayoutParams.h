#import <Foundation/Foundation.h>

static const CGFloat GRXMatchParent = -1;
static const CGFloat GRXWrapContent = -2;

#define kGRXLayoutParamsDefaultSize CGSizeMake(GRXWrapContent, GRXWrapContent)

@interface GRXLayoutParams : NSObject <NSCopying>

@property (nonatomic, weak, readonly) UIView * view;

@property (nonatomic) CGSize size;

@property (nonatomic) CGSize minSize;

@property (nonatomic) UIEdgeInsets margins;
@property (nonatomic, readonly) BOOL hasMargins;

- (instancetype) init;
- (instancetype) initWithSize:(CGSize)size;

@end

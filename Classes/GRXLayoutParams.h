#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static const CGFloat GRXMatchParent = -1;
static const CGFloat GRXWrapContent = -2;

#define kGRXLayoutParamsDefaultSize CGSizeMake(GRXWrapContent, GRXWrapContent)

@interface GRXLayoutParams : NSObject <NSCopying>

@property (nonatomic, weak, readonly) UIView *view;

@property (nonatomic) CGSize size;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) UIEdgeInsets margins;
@property (nonatomic, readonly) BOOL hasMargins;

- (instancetype)init;
- (instancetype)initWithSize:(CGSize)size;
- (instancetype)initWithLayoutParams:(GRXLayoutParams *)layoutParams;

@end

NS_ASSUME_NONNULL_END

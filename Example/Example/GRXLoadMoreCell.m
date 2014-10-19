#import "GRXLoadMoreCell.h"

@interface GRXLoadMoreCell ()

@property (nonatomic) UIActivityIndicatorView *refresh;

@end

@implementation GRXLoadMoreCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.refresh = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        [self.contentView addSubview:self.refresh];
        [self.refresh startAnimating];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect ownRect = self.contentView.frame;
    CGRect refreshRect = self.refresh.frame;

    refreshRect.origin.x = (ownRect.size.width - refreshRect.size.width) / 2;
    refreshRect.origin.y = (ownRect.size.height - refreshRect.size.height) / 2;

    self.refresh.frame = refreshRect;
}

+ (CGSize)cellSizeForCollectionView:(UICollectionView *)collectionView {
    return CGSizeMake(collectionView.frame.size.width * 0.9, 80);
}

@end

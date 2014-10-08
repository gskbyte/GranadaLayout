#import "GRXTextView.h"

@implementation GRXTextView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    self = [super initWithFrame:frame textContainer:textContainer];
    if(self) {
        [self commonInit];
    }
    return self;
}

- (void) commonInit {
    self.scrollEnabled = NO;
    self.editable = NO;
    self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.textContainerInset = UIEdgeInsetsMake(-3, -5, 0, 0);
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
}

@end

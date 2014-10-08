#import "GRXTextView.h"
#import "UIView+GRXLayout.h"

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
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.scrollEnabled = NO;
    self.editable = NO;
    self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.textContainerInset = UIEdgeInsetsMake(-3, -5, 0, 0);
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
}

- (CGSize)grx_measureForWidthSpec:(GRXMeasureSpec)widthSpec
                       heightSpec:(GRXMeasureSpec)heightSpec {
    CGSize measurementSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    if (widthSpec.mode != GRXMeasureSpecUnspecified) {
        measurementSize.width = widthSpec.value;
    }
    if (heightSpec.mode != GRXMeasureSpecUnspecified) {
        measurementSize.height = heightSpec.value;
    }

    CGSize measuredSize = [self sizeThatFits:measurementSize];
    if (widthSpec.mode == GRXMeasureSpecExactly) {
        measuredSize.width = widthSpec.value;
    }
    if (heightSpec.mode == GRXMeasureSpecExactly) {
        measuredSize.height = heightSpec.value;
    }

    return measuredSize;
}


- (void)setText:(NSString *)text {
    if (NO == [self.text isEqualToString:text]) {
        [super setText:text];
        [self grx_setNeedsLayoutInParent];
    }
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    if (NO == [self.attributedText isEqualToAttributedString:attributedText]) {
        [super setAttributedText:attributedText];
        [self grx_setNeedsLayoutInParent];
    }
}

- (void)setFont:(UIFont *)font {
    if (NO == [self.font isEqual:font]) {
        [super setFont:font];
        [self grx_setNeedsLayoutInParent];
    }
}

@end

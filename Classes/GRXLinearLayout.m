#import "GRXLinearLayout.h"

@implementation GRXLinearLayout

+ (Class) layoutParamsClass {
    return GRXLinearLayoutParams.class;
}

- (instancetype) init {
    return [self initWithDirection:kGRXLinearLayoutDefaultDirection];
}

- (instancetype) initWithDirection:(GRXLinearLayoutDirection)direction {
    self = [super init];
    if(self) {
        self.direction = direction;
    }
    return self;
}

- (void)setDirection:(GRXLinearLayoutDirection)direction {
    _direction = direction;
    [self setNeedsLayout];
}

- (void) layoutSubviews {
    [super layoutSubviews];

    CGPoint pos = CGPointZero;
    for(NSUInteger i=0; i<self.subviews.count; ++i) {
        UIView * view = self.subviews[i];
        if(!view.grx_drawable) {
            continue;
        }
        CGSize remainingSize = self.size;
        GRXLinearLayoutParams * params = view.grx_linearLayoutParams;
        UIEdgeInsets margins = params.margins;

        // 1. calculate remaining size and origin
        remainingSize.width -= (margins.left + margins.right);
        remainingSize.height -= (margins.top + margins.bottom);

        if(self.direction == GRXLinearLayoutDirectionHorizontal) {
            pos.x += margins.left;
            pos.y = MAX(margins.top, 0);

            remainingSize.width -= pos.x;
        } else {
            pos.y += margins.top;
            pos.x = MAX(margins.left, 0);

            remainingSize.height -= pos.y;
        }

        if(remainingSize.width < 0 || remainingSize.height < 0) {
            view.origin = pos;
            view.size = CGSizeZero;
            continue;
        }

        // 2. calculate view size given its layout params and this container's size
        GRXMeasureSpec measureSpec;
        if(params.width == GRXMatchParent) {
            measureSpec.width = remainingSize.width;
            measureSpec.widthMode = GRXMeasureSpecAtMost;
        } else if (params.width == GRXWrapContent) {
            measureSpec.width = 0;
            measureSpec.widthMode = GRXMeasureSpecUnspecified;
        } else {
            measureSpec.width = params.width;
            measureSpec.widthMode = GRXMeasureSpecExactly;
        }

        if(params.height == GRXMatchParent) {
            measureSpec.height = remainingSize.height;
            measureSpec.heightMode = GRXMeasureSpecAtMost;
        } else if (params.height == GRXWrapContent) {
            measureSpec.height = 0;
            measureSpec.heightMode = GRXMeasureSpecUnspecified;
        } else {
            measureSpec.height = params.height;
            measureSpec.heightMode = GRXMeasureSpecExactly;
        }

        [view grx_measureWithSpec:measureSpec];
        CGSize viewSize = view.grx_measuredSize;
        view.size = viewSize;

        // 3. Position view on layout depending on gravity
        switch (params.gravity) {
            default:
            case GRXLinearLayoutGravityBegin:
                view.origin = pos;
                break;
            case GRXLinearLayoutGravityCenter:
                if(self.direction == GRXLinearLayoutDirectionHorizontal) {
                    view.origin = CGPointMake(pos.x,
                                           params.margins.top + (self.height-viewSize.height)/2);
                } else {
                    view.origin = CGPointMake(params.margins.left + (self.width-viewSize.width)/2,
                                           pos.y);
                }
                break;
            case GRXLinearLayoutGravityEnd:
                if(self.direction == GRXLinearLayoutDirectionHorizontal) {
                    view.left = pos.x;
                    view.bottom = remainingSize.height;
                } else {
                    view.right = remainingSize.width;
                    view.top = pos.y;
                }
                break;
        }


        // 4. Advance origin for the next view
        if(self.direction == GRXLinearLayoutDirectionHorizontal) {
            pos.x += viewSize.width + margins.right;
        } else {
            pos.y += viewSize.height + margins.bottom;
        }
    }
}

@end

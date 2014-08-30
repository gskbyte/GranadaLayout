#import "GRXLinearLayout.h"

@implementation GRXLinearLayout

+ (Class) layoutParamsClass {
    return GRXLinearLayoutParams.class;
}

- (instancetype) init {
    return [self initWithDirection:kGRXLinearLayoutDefaultDirection
                         weightSum:kGRXLinearLayoutDefaultWeightSum];
}

- (instancetype)initWithDirection:(GRXLinearLayoutDirection)direction{
    return [self initWithDirection:direction
                         weightSum:kGRXLinearLayoutDefaultWeightSum];
}

- (instancetype)initWithDirection:(GRXLinearLayoutDirection)direction
                        weightSum:(CGFloat)weightSum {
    self = [super init];
    if(self) {
        self.direction = direction;
        self.weightSum = weightSum;
    }
    return self;
}

- (void)setDirection:(GRXLinearLayoutDirection)direction {
    _direction = direction;
    [self setNeedsLayout];
}

- (void)setWeightSum:(CGFloat)weightSum {
    NSAssert(weightSum >= 0, @"weightSum must be >=0");
    _weightSum = weightSum;
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
        CGSize availableSize = self.size;
        GRXLinearLayoutParams * params = view.grx_linearLayoutParams;
        UIEdgeInsets margins = params.margins;

        // 1. calculate remaining size and origin
        availableSize.width -= (margins.left + margins.right);
        availableSize.height -= (margins.top + margins.bottom);

        if(self.direction == GRXLinearLayoutDirectionHorizontal) {
            pos.x += margins.left;
            pos.y = MAX(margins.top, 0);

            availableSize.width -= pos.x;
        } else {
            pos.y += margins.top;
            pos.x = MAX(margins.left, 0);

            availableSize.height -= pos.y;
        }

        if(availableSize.width < 0 || availableSize.height < 0) {
            view.origin = pos;
            view.size = CGSizeZero;
            continue;
        }

        // 2. calculate view size given its layout params and this container's size
        GRXMeasureSpec measureSpec = [self measureSpecForLayoutParams:params
                                                        availableSize:availableSize];
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
                    view.bottom = availableSize.height;
                } else {
                    view.right = availableSize.width;
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

- (GRXMeasureSpec) measureSpecForLayoutParams:(GRXLinearLayoutParams*)params
                                availableSize:(CGSize)availableSize {
    GRXMeasureSpec measureSpec;
    if(self.weightSum != 0 && self.direction == GRXLinearLayoutDirectionHorizontal) {
        CGFloat weightProportion = params.weight / self.weightSum;
        measureSpec.width = availableSize.width * weightProportion;
        measureSpec.widthMode = GRXMeasureSpecExactly;
    } else {
        if(params.width == GRXMatchParent) {
            measureSpec.width = availableSize.width;
            measureSpec.widthMode = GRXMeasureSpecExactly;
        } else if (params.width == GRXWrapContent) {
            measureSpec.width = params.minSize.width;
            measureSpec.widthMode = GRXMeasureSpecUnspecified;
        } else {
            measureSpec.width = params.width;
            measureSpec.widthMode = GRXMeasureSpecExactly;
        }
    }

    if(self.weightSum != 0 && self.direction == GRXLinearLayoutDirectionVertical) {
        CGFloat weightProportion = params.weight / self.weightSum;
        measureSpec.height = availableSize.height * weightProportion;
        measureSpec.heightMode = GRXMeasureSpecExactly;
    } else {
        if(params.height == GRXMatchParent) {
            measureSpec.height = availableSize.height;
            measureSpec.heightMode = GRXMeasureSpecExactly;
        } else if (params.height == GRXWrapContent) {
            measureSpec.height = params.minSize.height;
            measureSpec.heightMode = GRXMeasureSpecUnspecified;
        } else {
            measureSpec.height = params.height;
            measureSpec.heightMode = GRXMeasureSpecExactly;
        }
    }

    return measureSpec;
}

@end

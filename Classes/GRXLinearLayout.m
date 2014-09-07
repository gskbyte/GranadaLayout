#import "GRXLinearLayout.h"

@implementation GRXLinearLayout

+ (Class)layoutParamsClass {
    return GRXLinearLayoutParams.class;
}

- (instancetype)init {
    return [self initWithDirection:kGRXLinearLayoutDefaultDirection
                         weightSum:kGRXLinearLayoutDefaultWeightSum];
}

- (instancetype)initWithDirection:(GRXLinearLayoutDirection)direction {
    return [self initWithDirection:direction
                         weightSum:kGRXLinearLayoutDefaultWeightSum];
}

- (instancetype)initWithDirection:(GRXLinearLayoutDirection)direction
                        weightSum:(CGFloat)weightSum {
    self = [super init];
    if (self) {
        self.direction = direction;
        self.weightSum = weightSum;
    }
    return self;
}

- (void)setDirection:(GRXLinearLayoutDirection)direction {
    _direction = direction;
    [self grx_setNeedsLayout];
}

- (void)setWeightSum:(CGFloat)weightSum {
    NSAssert(weightSum >= 0, @"weightSum must be >=0");
    _weightSum = weightSum;
    [self grx_setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGPoint pos = CGPointMake(self.padding.left, self.padding.top);
    for (UIView *view in self.subviews) {
        if (!view.grx_drawable) {
            continue;
        }
        CGSize availableSize = self.size;
        GRXLinearLayoutParams *params = view.grx_linearLayoutParams;
        UIEdgeInsets margins = params.margins;

        // 1. calculate remaining size and origin
        availableSize.width -= (margins.left + margins.right + self.padding.left + self.padding.right);
        availableSize.height -= (margins.top + margins.bottom + self.padding.top + self.padding.bottom);

        if (self.direction == GRXLinearLayoutDirectionHorizontal) {
            pos.x += margins.left;
            pos.y = MAX(margins.top, pos.y);

            availableSize.width -= pos.x;
        } else {
            pos.y += margins.top;
            pos.x = MAX(margins.left, pos.x);

            availableSize.height -= pos.y;
        }

        if (availableSize.width <= 0 || availableSize.height <= 0) {
            view.origin = pos;
            view.size = CGSizeZero;
            continue;
        }

        // 2. calculate view size given its layout params and this container's size
        GRXFullMeasureSpec measureSpec = [self measureSpecForLayoutParams:params
                                                            availableSize:availableSize];
        CGSize viewSize = [view grx_measuredSizeForWidthSpec:measureSpec.width
                                                  heightSpec:measureSpec.height];
        view.size = viewSize;

        // 3. Position view on layout depending on gravity
        switch (params.gravity) {
            default:
            case GRXLinearLayoutGravityBegin:
                view.origin = pos;
                break;
            case GRXLinearLayoutGravityCenter:
                if (self.direction == GRXLinearLayoutDirectionHorizontal) {
                    view.origin = CGPointMake(pos.x,
                                              params.margins.top + (self.height - viewSize.height) / 2);
                } else {
                    view.origin = CGPointMake(params.margins.left + (self.width - viewSize.width) / 2,
                                              pos.y);
                }
                break;
            case GRXLinearLayoutGravityEnd:
                if (self.direction == GRXLinearLayoutDirectionHorizontal) {
                    view.left = pos.x;
                    view.bottom = availableSize.height;
                } else {
                    view.right = availableSize.width;
                    view.top = pos.y;
                }
                break;
        }


        // 4. Advance origin for the next view
        if (self.direction == GRXLinearLayoutDirectionHorizontal) {
            pos.x += viewSize.width + margins.right;
        } else {
            pos.y += viewSize.height + margins.bottom;
        }
    }
}

- (GRXFullMeasureSpec)measureSpecForLayoutParams:(GRXLinearLayoutParams *)params
                                   availableSize:(CGSize)availableSize {
    GRXFullMeasureSpec fullSpec;
    if (self.weightSum != 0 && self.direction == GRXLinearLayoutDirectionHorizontal) {
        CGFloat weightProportion = params.weight / self.weightSum;
        fullSpec.width.value = availableSize.width * weightProportion;
        fullSpec.width.mode = GRXMeasureSpecExactly;
    } else {
        if (params.width == GRXMatchParent) {
            fullSpec.width.value = availableSize.width;
            fullSpec.width.mode = GRXMeasureSpecExactly;
        } else if (params.width == GRXWrapContent) {
            fullSpec.width.value = params.minSize.width;
            fullSpec.width.mode = GRXMeasureSpecUnspecified;
        } else {
            fullSpec.width.value = params.width;
            fullSpec.width.mode = GRXMeasureSpecExactly;
        }
    }

    if (self.weightSum != 0 && self.direction == GRXLinearLayoutDirectionVertical) {
        CGFloat weightProportion = params.weight / self.weightSum;
        fullSpec.height.value = availableSize.height * weightProportion;
        fullSpec.height.mode = GRXMeasureSpecExactly;
    } else {
        if (params.height == GRXMatchParent) {
            fullSpec.height.value = availableSize.height;
            fullSpec.height.mode = GRXMeasureSpecExactly;
        } else if (params.height == GRXWrapContent) {
            fullSpec.height.value = params.minSize.height;
            fullSpec.height.mode = GRXMeasureSpecUnspecified;
        } else {
            fullSpec.height.value = params.height;
            fullSpec.height.mode = GRXMeasureSpecExactly;
        }
    }

    return fullSpec;
}

@end

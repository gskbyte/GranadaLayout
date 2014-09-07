typedef NS_ENUM(NSUInteger, GRXMeasureSpecMode) {
    GRXMeasureSpecUnspecified = 0,
    GRXMeasureSpecExactly,
    GRXMeasureSpecAtMost
};

typedef struct GRXMeasureSpec {
    CGFloat width;
    GRXMeasureSpecMode widthMode;

    CGFloat height;
    GRXMeasureSpecMode heightMode;
} GRXMeasureSpec;

typedef struct GRXPartialMeasureSpec {
    CGFloat value;
    GRXMeasureSpecMode mode;
} GRXPartialMeasureSpec;


CG_INLINE GRXMeasureSpec
GRXMeasureSpecMake(CGFloat width, GRXMeasureSpecMode widthMode,
                   CGFloat height, GRXMeasureSpecMode heightMode) {
    GRXMeasureSpec spec;
    spec.width = width;
    spec.widthMode = widthMode;
    spec.height = height;
    spec.heightMode = heightMode;
    return spec;
}

CG_INLINE GRXMeasureSpec
GRXMeasureSpecMakeFromPartial(GRXPartialMeasureSpec wspec, GRXPartialMeasureSpec hspec) {
    GRXMeasureSpec spec;
    spec.width = wspec.value;
    spec.widthMode = wspec.mode;
    spec.height = hspec.value;
    spec.heightMode = hspec.mode;
    return spec;
}

CG_INLINE CGFloat
GRXMeasureSpecGetDefaultValue(CGFloat sizeValue, CGFloat sizeSpecValue, GRXMeasureSpecMode mode) {
    switch (mode) {
        default:
        case GRXMeasureSpecUnspecified:
            return sizeValue;
        case GRXMeasureSpecExactly:
        case GRXMeasureSpecAtMost:
            return sizeSpecValue;
    }
}

CG_INLINE BOOL
GRXMeasureSpecIsZero(GRXMeasureSpec spec) {
    return spec.width==0 && spec.widthMode==0 && spec.height==0 && spec.heightMode==0;
}

CG_INLINE BOOL
GRXMeasureSpecsEqual(GRXMeasureSpec spec1, GRXMeasureSpec spec2) {
    return spec1.width == spec2.width &&
        spec1.widthMode == spec2.widthMode &&
        spec1.height == spec2.height &&
        spec1.heightMode == spec2.heightMode;
}

CG_INLINE GRXPartialMeasureSpec
GRXPartialMeasureSpecMake(CGFloat value, GRXMeasureSpecMode mode) {
    GRXPartialMeasureSpec spec;
    spec.value = value;
    spec.mode = mode;
    return spec;
}

CG_INLINE CGFloat
resolveSizeValue(CGFloat sizeValue, GRXPartialMeasureSpec measureSpec) {
    switch (measureSpec.mode) {
        default:
        case GRXMeasureSpecUnspecified:
            return sizeValue;
        case GRXMeasureSpecExactly:
            return measureSpec.value;
            break;
        case GRXMeasureSpecAtMost:
            return MIN(sizeValue, measureSpec.value);
    }
}

CG_INLINE CGFloat
getDefaultSize(CGFloat sizeValue, GRXPartialMeasureSpec measureSpec) {
    switch (measureSpec.mode) {
        default:
        case GRXMeasureSpecUnspecified:
            return sizeValue;
        case GRXMeasureSpecExactly:
        case GRXMeasureSpecAtMost:
            return measureSpec.value;
    }
}

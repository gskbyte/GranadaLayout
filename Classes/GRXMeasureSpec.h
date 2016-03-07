typedef NS_ENUM (NSUInteger, GRXMeasureSpecMode) {
    GRXMeasureSpecUnspecified = 0,
    GRXMeasureSpecExactly,
    GRXMeasureSpecAtMost
};

typedef struct GRXMeasureSpec {
    CGFloat value;
    GRXMeasureSpecMode mode;
} GRXMeasureSpec;

typedef struct GRXFullMeasureSpec {
    GRXMeasureSpec width;
    GRXMeasureSpec height;
} GRXFullMeasureSpec;

#pragma mark - Initializers

CG_INLINE GRXFullMeasureSpec
GRXFullMeasureSpecMake(GRXMeasureSpec wspec, GRXMeasureSpec hspec) {
    GRXFullMeasureSpec spec;
    spec.width = wspec;
    spec.height = hspec;
    return spec;
}

CG_INLINE GRXMeasureSpec
GRXMeasureSpecMake(CGFloat value, GRXMeasureSpecMode mode) {
    GRXMeasureSpec spec;
    spec.value = value;
    spec.mode = mode;
    return spec;
}

#pragma mark - Comparison

CG_INLINE BOOL
GRXMeasureSpecIsZero(GRXMeasureSpec spec) {
    return spec.value == 0 && spec.mode == 0;
}

CG_INLINE BOOL
GRXMeasureSpecsEqual(GRXMeasureSpec spec1, GRXMeasureSpec spec2) {
    return spec1.value == spec2.value &&
           spec1.mode == spec2.mode;
}

CG_INLINE BOOL
GRXFullMeasureSpecsEqual(GRXFullMeasureSpec spec1, GRXFullMeasureSpec spec2) {
    return GRXMeasureSpecsEqual(spec1.width, spec2.width) &&
           GRXMeasureSpecsEqual(spec1.height, spec2.height);
}

#pragma mark - Measurement

CG_INLINE CGFloat
GRXMeasureSpecResolveSizeValue(CGFloat sizeValue, GRXMeasureSpec measureSpec) {
    switch (measureSpec.mode) {
        default:
        case GRXMeasureSpecUnspecified:
            return sizeValue;
        case GRXMeasureSpecExactly:
            return measureSpec.value;
        case GRXMeasureSpecAtMost:
            return MIN(sizeValue, measureSpec.value);
    }
}

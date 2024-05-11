#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The "Image" asset catalog image resource.
static NSString * const ACImageNameImage AC_SWIFT_PRIVATE = @"Image";

/// The "gradient" asset catalog image resource.
static NSString * const ACImageNameGradient AC_SWIFT_PRIVATE = @"gradient";

/// The "logo" asset catalog image resource.
static NSString * const ACImageNameLogo AC_SWIFT_PRIVATE = @"logo";

/// The "logo 1" asset catalog image resource.
static NSString * const ACImageNameLogo1 AC_SWIFT_PRIVATE = @"logo 1";

/// The "test" asset catalog image resource.
static NSString * const ACImageNameTest AC_SWIFT_PRIVATE = @"test";

/// The "test2" asset catalog image resource.
static NSString * const ACImageNameTest2 AC_SWIFT_PRIVATE = @"test2";

#undef AC_SWIFT_PRIVATE

//
//  IDLSkinningMacros.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 29/07/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#ifndef Idlepixel_Common_IDLSkinningMacros_h
#define Idlepixel_Common_IDLSkinningMacros_h

#pragma mark - common

#define IDLSKIN_COPY_PROPERTY(__copy__, __property__) IDL_COPY_PROPERTY(__copy__, __property__)

#pragma mark - Font

#define IDLSKIN_INTERFACE_FONT(__property__) \
@property (nonatomic, strong, readwrite) NSNumber *__property__##Size;\
@property (nonatomic, strong, readwrite) UIFont *__property__;

#define IDLSKIN_INTERFACE_FONT_NAMED(__property__) \
@property (nonatomic, strong, readwrite) NSString *__property__##Name;\
@property (nonatomic, strong, readwrite) NSNumber *__property__##Size;\
@property (nonatomic, strong, readonly) UIFont *__property__;

#define IDLSKIN_IMPLEMENTATION_FONT(__property__) \
- (UIFont *)__property__ \
{\
 UIFont *font = _##__property__;\
 if (self.__property__##Size) {\
  return [font fontWithSize:self.__property__##Size.floatValue];\
 } else {\
  return font;\
 }\
}

#define IDLSKIN_IMPLEMENTATION_FONT_CHILD(__property__, __parent_property__) \
- (UIFont *)__property__ \
{\
 UIFont *font = _##__property__;\
 if (font == nil) font = self.__parent_property__;\
 if (self.__property__##Size) {\
  return [font fontWithSize:self.__property__##Size.floatValue];\
 } else {\
  return font;\
 }\
}

#define IDLSKIN_IMPLEMENTATION_FONT_NAMED(__property__) \
- (UIFont *)__property__ \
{\
 return [UIFont fontWithName:self.__property__##Name size:self.__property__##Size.floatValue];\
}

#define IDLSKIN_IMPLEMENTATION_FONT_NAMED_CHILD(__property__, __parent_property__) \
- (UIFont *)__property__ \
{\
 UIFont *font = nil;\
 UIFont *parentFont = self.__parent_property__;\
 if (self.__property__##Name.length > 0) {\
  CGFloat size = self.__property__##Size.floatValue;\
  if (!self.__property__##Size) size = parentFont.pointSize;\
  font = [UIFont fontWithName:self.__property__##Name size:size];\
 }\
 if (font == nil) {\
  font = parentFont;\
  if (self.__property__##Size) {\
   font = [font fontWithSize:self.__property__##Size.floatValue];\
  }\
 }\
 return font;\
}


#pragma mark - Image

#define IDLSKIN_INTERFACE_IMAGE(__property__) \
@property (nonatomic, strong, readwrite) UIImage *__property__;\
@property (nonatomic, assign, readwrite) UIEdgeInsets __property__##CapInsets;\
@property (nonatomic, assign, readwrite) UIImageResizingMode __property__##ResizingMode;

#define IDLSKIN_INTERFACE_IMAGE_NAMED(__property__) \
@property (nonatomic, strong, readwrite) NSString *__property__##Name;\
@property (nonatomic, assign, readwrite) UIEdgeInsets __property__##CapInsets;\
@property (nonatomic, assign, readwrite) UIImageResizingMode __property__##ResizingMode;\
@property (atomic, readonly) UIImage *__property__;

#define IDLSKIN_COPY_IMAGE(__copy__, __property__) \
IDLSKIN_COPY_PROPERTY(__copy__, __property__##Name);\
IDLSKIN_COPY_PROPERTY(__copy__, __property__##CapInsets);\
IDLSKIN_COPY_PROPERTY(__copy__, __property__##ResizingMode)

#define IDLSKIN_IMPLEMENTATION_IMAGE(__property__) \
- (UIImage *)__property__ \
{\
return [self resizableImageWithImage:_##__property__ capInsets:self.__property__##CapInsets resizingMode:self.__property__##ResizingMode];\
}

#define IDLSKIN_IMPLEMENTATION_IMAGE_NAMED(__property__) \
- (UIImage *)__property__ \
{\
if (self.__property__##Name) {\
return [self resizableImageWithImage:UIImageNamed(self.__property__##Name) capInsets:self.__property__##CapInsets resizingMode:self.__property__##ResizingMode];\
} else {\
return nil;\
}\
}

#define IDLSKIN_IMPLEMENTATION_IMAGE_NAMED_CHILD(__property__, __parent_property__) \
- (UIImage *)__property__ \
{\
    if (self.__property__##Name) {\
        return [self resizableImageWithImage:UIImageNamed(self.__property__##Name) capInsets:self.__property__##CapInsets resizingMode:self.__property__##ResizingMode];\
    } else {\
        return self.__parent_property__;\
    }\
}

#define IDLSKIN_IMPLEMENTATION_IMAGE_NAMED_TINTED(__property__, __tint_property__) \
- (UIImage *)__property__ \
{\
if (self.__property__##Name) {\
    if (self.__tint_property__) {\
        return [self resizableImageWithImage:UIImageNamedTint(self.__property__##Name, self.__tint_property__) capInsets:self.__property__##CapInsets resizingMode:self.__property__##ResizingMode];\
    } else {\
        return [self resizableImageWithImage:UIImageNamed(self.__property__##Name) capInsets:self.__property__##CapInsets resizingMode:self.__property__##ResizingMode];\
    }\
} else {\
return nil;\
}\
}

#pragma mark - Pattern

#define IDLSKIN_INTERFACE_PATTERN_NAMED(__property__) \
@property (nonatomic, strong, readwrite) NSString *__property__##Name;\
@property (atomic, readonly) UIColor *__property__;\

#define IDLSKIN_IMPLEMENTATION_PATTERN_NAMED(__property__) \
- (UIColor *)__property__ \
{\
if (self.__property__##Name) {\
    UIImage *image = UIImageNamed(self.__property__##Name);\
    if (image != nil) {\
        return [UIColor colorWithPatternImage:image];\
    }\
}\
return nil;\
}

#pragma mark - Color

#define IDLSKIN_INTERFACE_COLOR(__property__) \
@property (nonatomic, strong, readwrite) UIColor *__property__;

#define IDLSKIN_IMPLEMENTATION_COLOR(__property__) \
\

#define IDLSKIN_IMPLEMENTATION_COLOR_CHILD(__property__, __parent_property__) \
- (UIColor *)__property__ \
{\
if (_##__property__) {\
return _##__property__;\
} else {\
return self.__parent_property__;\
}\
}

#define IDLSKIN_INTERFACE_COLOR_ALPHA(__property__) \
@property (nonatomic, strong, readwrite) UIColor *__property__;\
@property (nonatomic, strong, readwrite) NSNumber *__property__##Alpha;

#define IDLSKIN_COPY_COLOR_ALPHA(__copy__, __property__) \
IDLSKIN_COPY_PROPERTY(__copy__, __property__);\
IDLSKIN_COPY_PROPERTY(__copy__, __property__##Alpha)

#define IDLSKIN_IMPLEMENTATION_COLOR_ALPHA(__property__) \
- (UIColor *)__property__ \
{\
if (self.__property__##Alpha) {\
CGFloat alpha = RANGE(0.0f, self.__property__##Alpha.floatValue, 1.0f);\
return [_##__property__ colorWithAlphaComponent:alpha];\
} else {\
return _##__property__;\
}\
}

#define IDLSKIN_IMPLEMENTATION_COLOR_ALPHA_CHILD(__property__, __parent_property__) \
- (UIColor *)__property__ \
{\
UIColor *c = _##__property__;\
if (c == nil) c = self.__parent_property__;\
if (self.__property__##Alpha) {\
CGFloat alpha = RANGE(0.0f, self.__property__##Alpha.floatValue, 1.0f);\
return [c colorWithAlphaComponent:alpha];\
} else {\
return c;\
}\
}

#endif

//
//  IDLTouchNotifyingViewMacros.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 2/08/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#ifndef Idlepixel_Common_IDLTouchNotifyingViewMacros_h
#define Idlepixel_Common_IDLTouchNotifyingViewMacros_h

// -(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

#define IDL_TOUCHNOTIFYING_UIView_touchesBegan() \
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event\
{\
    if ([self.touchNotifyingViewDelegate respondsToSelector:@selector(touchesBegan:withEvent:inView:)]) {\
        [self.touchNotifyingViewDelegate touchesBegan:touches withEvent:event inView:self];\
    }\
    [super touchesBegan:touches withEvent:event];\
}

// -(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event

#define IDL_TOUCHNOTIFYING_UIView_touchesCancelled() \
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event\
{\
    if ([self.touchNotifyingViewDelegate respondsToSelector:@selector(touchesCancelled:withEvent:inView:)]) {\
        [self.touchNotifyingViewDelegate touchesCancelled:touches withEvent:event inView:self];\
    }\
    [super touchesCancelled:touches withEvent:event];\
}

// -(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event

#define IDL_TOUCHNOTIFYING_UIView_touchesEnded() \
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event\
{\
    if ([self.touchNotifyingViewDelegate respondsToSelector:@selector(touchesEnded:withEvent:inView:)]) {\
        [self.touchNotifyingViewDelegate touchesEnded:touches withEvent:event inView:self];\
    }\
    [super touchesEnded:touches withEvent:event];\
}

// -(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event

#define IDL_TOUCHNOTIFYING_UIView_touchesMoved() \
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event\
{\
    if ([self.touchNotifyingViewDelegate respondsToSelector:@selector(touchesMoved:withEvent:inView:)]) {\
        [self.touchNotifyingViewDelegate touchesMoved:touches withEvent:event inView:self];\
    }\
    [super touchesMoved:touches withEvent:event];\
}

// IDL_TOUCHNOTIFYING_UIView_ALL

#define IDL_TOUCHNOTIFYING_UIView_ALL \
\
IDL_TOUCHNOTIFYING_UIView_touchesBegan()\
\
IDL_TOUCHNOTIFYING_UIView_touchesCancelled()\
\
IDL_TOUCHNOTIFYING_UIView_touchesEnded()\
\
IDL_TOUCHNOTIFYING_UIView_touchesMoved()

#endif

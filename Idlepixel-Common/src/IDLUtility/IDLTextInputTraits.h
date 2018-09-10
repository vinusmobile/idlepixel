//
//  IDLTextInputTraits.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 27/12/2013.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDLTextInputTraits : NSObject <UITextInputTraits>

@property (nonatomic, assign) UITextAutocapitalizationType autocapitalizationType;
@property (nonatomic, assign) UITextAutocorrectionType autocorrectionType;
@property (nonatomic, assign) UITextSpellCheckingType spellCheckingType;
@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, assign) UIKeyboardAppearance keyboardAppearance;
@property (nonatomic, assign) UIReturnKeyType returnKeyType;
@property (nonatomic, assign) BOOL enablesReturnKeyAutomatically;
@property (nonatomic, assign,getter=isSecureTextEntry) BOOL secureTextEntry;

+(instancetype)traitsWithKeyboardType:(UIKeyboardType)keyboardType;
+(instancetype)traitsWithKeyboardType:(UIKeyboardType)keyboardType keyboardAppearance:(UIKeyboardAppearance)keyboardAppearance;

+(instancetype)traitsFromTextInput:(NSObject<UITextInputTraits> *)textInput;
-(void)copyTraitsFromTextInput:(NSObject<UITextInputTraits> *)textInput;

-(void)applyToTextInput:(NSObject<UITextInputTraits> *)textInput;

@end

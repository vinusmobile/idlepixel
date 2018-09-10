//
//  IDLTextInputTraits.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 27/12/2013.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLTextInputTraits.h"

@implementation IDLTextInputTraits

+(instancetype)traitsWithKeyboardType:(UIKeyboardType)keyboardType
{
    return [self traitsWithKeyboardType:keyboardType keyboardAppearance:UIKeyboardAppearanceDefault];
}

+(instancetype)traitsWithKeyboardType:(UIKeyboardType)keyboardType keyboardAppearance:(UIKeyboardAppearance)keyboardAppearance
{
    IDLTextInputTraits *traits = [[self class] new];
    traits.keyboardType = keyboardType;
    traits.keyboardAppearance = keyboardAppearance;
    return traits;
}

+(instancetype)traitsFromTextInput:(NSObject<UITextInputTraits> *)textInput
{
    IDLTextInputTraits *traits = [[self class] new];
    [traits copyTraitsFromTextInput:textInput];
    return traits;
}

-(void)copyTraitsFromTextInput:(NSObject<UITextInputTraits> *)textInput
{
    self.autocapitalizationType = textInput.autocapitalizationType;
    self.autocorrectionType = textInput.autocorrectionType;
    self.spellCheckingType = textInput.spellCheckingType;
    self.keyboardType = textInput.keyboardType;
    self.keyboardAppearance = textInput.keyboardAppearance;
    self.returnKeyType = textInput.returnKeyType;
    self.enablesReturnKeyAutomatically = textInput.enablesReturnKeyAutomatically;
    self.secureTextEntry = textInput.isSecureTextEntry;
}

-(void)applyToTextInput:(NSObject<UITextInputTraits> *)textInput
{
    if (![textInput conformsToProtocol:@protocol(UITextInputTraits)]) return;
    
    textInput.autocapitalizationType = self.autocapitalizationType;
    textInput.autocorrectionType = self.autocorrectionType;
    textInput.spellCheckingType = self.spellCheckingType;
    textInput.keyboardType = self.keyboardType;
    textInput.keyboardAppearance = self.keyboardAppearance;
    textInput.returnKeyType = self.returnKeyType;
    textInput.enablesReturnKeyAutomatically = self.enablesReturnKeyAutomatically;
    textInput.secureTextEntry = self.isSecureTextEntry;
}

@end

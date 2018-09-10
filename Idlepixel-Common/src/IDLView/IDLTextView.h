//
//  IDLTextView.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 17/09/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDLTextView : UITextView

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, strong) UIFont *placeholderFont;

@end

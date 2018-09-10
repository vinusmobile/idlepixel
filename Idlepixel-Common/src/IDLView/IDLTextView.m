//
//  IDLTextView.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 17/09/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLTextView.h"
#import "IDLLabel.h"
#import "IDLUIKitInlineExtensions.h"
#import "IDLCGInlineExtensions.h"
#import "UIImage+Idlepixel.h"
#import "UIDevice+Idlepixel.h"

@interface IDLTextView ()

@property (nonatomic, strong) IDLLabel *placeHolderLabel;

- (void)textDidChangeNotification:(NSNotification *)notification;
- (void)textDidBeginEditingNotification:(NSNotification *)notification;
- (void)textDidEndEditingNotification:(NSNotification *)notification;

@end

@implementation IDLTextView
@synthesize placeholderFont=_placeholderFont;
@synthesize placeholderColor=_placeholderColor;

- (void)dealloc
{
    [self removeObservers];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Use Interface Builder User Defined Runtime Attributes to set
    // placeholder and placeholderColor in Interface Builder.
    if (!self.placeholder) {
        [self setPlaceholder:@""];
    }
    
    [self setupObservers];
}

- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
        [self setPlaceholder:@""];
        [self setupObservers];
    }
    return self;
}

-(void)setupObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangeNotification:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidBeginEditingNotification:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEndEditingNotification:) name:UITextViewTextDidEndEditingNotification object:nil];
}

-(void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#define kLabelTag       999

#define kPlaceholderInsetHorizontal     4.0f
#define kPlaceholderInsetVertical       8.0f

#pragma mark Notifications

- (void)textDidChangeNotification:(NSNotification *)notification
{
    [self updatePlaceholderVisibility:NO allowVisible:NO];
}

- (void)textDidBeginEditingNotification:(NSNotification *)notification
{
    [self updatePlaceholderVisibility:YES allowVisible:YES];
}

- (void)textDidEndEditingNotification:(NSNotification *)notification
{
    [self updatePlaceholderVisibility:NO allowVisible:YES];
}

-(void)updatePlaceholderVisibility:(BOOL)forceHidden allowVisible:(BOOL)allowVisible
{
    UIView *labelView = [self viewWithTag:kLabelTag];
    if (forceHidden || self.text.length > 0 || self.placeholder.length == 0) {
        labelView.alpha = 0.0f;
    } else if (allowVisible) {
        labelView.alpha = 1.0f;
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self updatePlaceholderVisibility:NO allowVisible:YES];
}

-(void)setPlaceholderFont:(UIFont *)placeholderFont
{
    _placeholderFont = placeholderFont;
    _placeHolderLabel.font = self.placeholderFont;
}

-(UIColor *)placeholderColor
{
    if (_placeholderColor != nil) {
        return _placeholderColor;
    } else {
        return self.textColor;
    }
}

-(UIFont *)placeholderFont
{
    if (_placeholderFont != nil) {
        return _placeholderFont;
    } else {
        return self.font;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    frame.origin = CGPointZero;
    
    if (self.placeholder.length > 0) {
        
        frame = CGRectInset(frame, kPlaceholderInsetHorizontal, kPlaceholderInsetVertical);
        
        if (self.placeHolderLabel == nil) {
            IDLLabel *label = [[IDLLabel alloc] initWithFrame:frame];
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.numberOfLines = 0;
            label.font = self.font;
            label.backgroundColor = [UIColor clearColor];
            label.textColor = self.placeholderColor;
            label.alpha = 1.0f;
            label.userInteractionEnabled = NO;
            label.tag = kLabelTag;
            label.verticalAlignment = IDLVerticalAlignmentTop;
            [self addSubview:label];
            self.placeHolderLabel = label;
            
        } else {
            self.placeHolderLabel.frame = frame;
        }
        
        self.placeHolderLabel.font = self.placeholderFont;
        
        self.placeHolderLabel.text = self.placeholder;
        [self sendSubviewToBack:self.placeHolderLabel];
    }
    
    [self updatePlaceholderVisibility:NO allowVisible:YES];
}

@end

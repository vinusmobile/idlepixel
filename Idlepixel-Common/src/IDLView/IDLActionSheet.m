//
//  IDLActionSheet.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 6/05/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLActionSheet.h"

@interface IDLActionSheet ()

@property (nonatomic, strong, readwrite) UITapGestureRecognizer *dismissTapOutRecognizer;

@end

@implementation IDLActionSheet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configure];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    if (self.shouldLayoutOnAwakeFromNib) {
        [self layoutSubviews];
    }
}

-(BOOL)shouldLayoutOnAwakeFromNib
{
    return NO;
}

-(void)configure
{
    // do nothing
}

-(UITapGestureRecognizer *)dismissTapOutRecognizer
{
    if (_dismissTapOutRecognizer == nil) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissWithTapOut:)];
        tap.cancelsTouchesInView = NO;
        _dismissTapOutRecognizer = tap;
    }
    return _dismissTapOutRecognizer;
}

-(void)dismissWithTapOut:(UITapGestureRecognizer *)recognizer
{
    CGPoint p = [recognizer locationInView:self];
    if (p.y < 0) {
        [self dismissWithClickedButtonIndex:-1 animated:YES];
    }
}

-(void)didMoveToWindow
{
    if (self.window != nil) {
        [self.window addGestureRecognizer:self.dismissTapOutRecognizer];
    }
}

-(void)willMoveToWindow:(UIWindow *)newWindow
{
    if (self.window != nil) {
        [self.window removeGestureRecognizer:self.dismissTapOutRecognizer];
    }
}

-(void)dealloc
{
    //IDLLogObject(self);
}

@end

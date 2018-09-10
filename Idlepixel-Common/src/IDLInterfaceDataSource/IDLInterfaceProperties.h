//
//  IDLInterfaceProperties.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 30/09/2014.
//  Copyright (c) 2014 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLObjectProtocols.h"

@interface IDLInterfaceProperties : NSObject <IDLConfigurable>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *details;

@property (nonatomic, strong) NSObject *data;
@property (nonatomic, strong) NSObject *secondaryData;

@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *detailsColor;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *color;

@property (nonatomic, strong) NSString *caption;

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSObject *imageData;

@property (nonatomic, strong) NSString *href;

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL disabled;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

//
//  IDLTableViewHeaderFooterView.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 22/02/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDLInterfaceProtocols.h"
#import "IDLInterfaceTypedefs.h"

@interface IDLTableViewHeaderFooterView : UITableViewHeaderFooterView <IDLReusableInterfaceElement, IDLActionResponseSource, IDLLayoutOnAwakeFromNib>

@property (nonatomic, assign) id<IDLActionResponseDelegate> actionResponseDelegate;

@property (weak, nonatomic) IBOutlet UIView *flairBackgroundView;

@end

//
//  IDLView.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 8/06/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDLInterfaceProtocols.h"
#import "IDLInterfaceTypedefs.h"

@interface IDLView : UIView <IDLReusableInterfaceElement, IDLActionResponseSource, IDLLayoutOnAwakeFromNib>

@property (nonatomic, assign) id<IDLActionResponseDelegate> actionResponseDelegate;

@end

@interface IDLTouchNotifyingView : IDLView

@property (nonatomic, weak) IBOutlet NSObject <IDLTouchNotifyingViewDelegate>* touchNotifyingViewDelegate;

@end

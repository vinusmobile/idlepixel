//
//  IDLScrollView.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 2/08/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDLInterfaceProtocols.h"

@interface IDLScrollView : UIScrollView

@property (nonatomic, weak) IBOutlet NSObject <IDLTouchNotifyingViewDelegate>* touchNotifyingViewDelegate;
@property (nonatomic, weak) IBOutlet UIView *contentSizeView;

-(void)adjustContentSize;

@end

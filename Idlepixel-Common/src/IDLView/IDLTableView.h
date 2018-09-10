//
//  IDLTableView.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 2/08/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDLInterfaceProtocols.h"

@interface IDLTableView : UITableView

@property (nonatomic, weak) IBOutlet NSObject <IDLTouchNotifyingViewDelegate>* touchNotifyingViewDelegate;

@end

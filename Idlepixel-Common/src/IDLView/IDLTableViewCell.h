//
//  IDLTableViewCell.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 22/02/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDLInterfaceProtocols.h"
#import "IDLInterfaceTypedefs.h"

@interface IDLTableViewCell : UITableViewCell <IDLReusableInterfaceElement, IDLActionResponseSource, IDLLayoutOnAwakeFromNib>

@property (nonatomic, assign) id<IDLActionResponseDelegate> actionResponseDelegate;

-(void)saveTextLabelColor:(UILabel *)aLabel;
-(UIColor *)textLabelColor:(UILabel *)aLabel;
-(void)restoreTextLabelColor:(UILabel *)aLabel;

-(void)executeSelectedHighlightedBlock:(BOOL)selected highlighted:(BOOL)highlighted animated:(BOOL)animated;

@property (nonatomic, copy) IDLSelectedHighlightedBlock selectedHighlightedBlock;

@property (weak, nonatomic) IBOutlet UIView *flairBackgroundView;

@end

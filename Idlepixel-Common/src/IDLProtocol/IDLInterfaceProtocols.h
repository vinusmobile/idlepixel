//
//  IDLInterfaceProtocols.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 14/01/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IDLInterfaceTypedefs.h"
#import "IDLInterfaceDataSourceHeaders.h"
#import "IDLPopulatableViewProtocols.h"

@protocol IDLTypedViewController <NSObject>

@required
+(NSString *)typeIdentifier;
@property (readonly) NSString *typeIdentifier;

@optional
+(NSArray *)typeIdentifiers;
@property (readonly) NSArray *typeIdentifiers;

+(IDLTypedUserInterfaceIdiom)typeUserInterface;
@property (readonly) IDLTypedUserInterfaceIdiom typeUserInterface;

@end

@protocol IDLReuseIdentifiable <NSObject>

@required
+(NSString *)reuseIdentifier;

@end

@protocol IDLReusableInterfaceElement <IDLReuseIdentifiable, IDLConfigurable>

@required
-(void)customLayoutSubviews;

-(CGFloat)calculatedHeight;
-(CGSize)calculatedSize;

@end


@protocol IDLLayoutOnAwakeFromNib <NSObject>

@required
-(BOOL)shouldLayoutOnAwakeFromNib;

@end


@protocol IDLNibLoadable <NSObject>

@required
- (id) initWithNibName: (NSString*) nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end

@protocol IDLNavigationAnchor <NSObject>

@required
+(NSString *)navigationAnchor;
-(NSString *)navigationAnchor;
-(BOOL)hasNavigationAnchor:(NSString *)anchor;

@end

@protocol IDLTouchNotifyingViewDelegate <NSObject>

@optional
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView *)view;
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView *)view;
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView *)view;
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView *)view;

@end

@protocol IDLActionResponseDelegate <NSObject>

@required
-(BOOL)actionEncountered:(SEL)actionSelector withSender:(id)sender fromSource:(UIView *)aSource;

@end

@protocol IDLActionResponseSource <NSObject>

@required
@property (nonatomic, assign) id<IDLActionResponseDelegate> actionResponseDelegate;
-(void)handleAction:(SEL)actionSelector withSender:(id)sender;

@end

@protocol IDLPersistableViewController <NSObject>

@required
- (NSString *)uniqueIdentifier;
- (void)autoFillPersistentFields;
- (void)savePersistentFields;

@end

@protocol IDLViewControllerManagerInitializable <NSObject>

@required
+(void)initializeWithViewControllerManager;

@end

@protocol IDLViewControllerInterfaceItemSelectionDelegate <NSObject>

@required
-(void)interfaceItemSelected:(IDLInterfaceItem *)interfaceItem atIndexPath:(NSIndexPath *)indexPath forView:(UIView *)view forViewController:(UIViewController *)viewController;

@end

@protocol IDLViewControllerActionResponseDelegate <NSObject>

@required
-(BOOL)actionEncountered:(SEL)actionSelector withSender:(id)sender fromSource:(UIView *)aSource forViewController:(UIViewController *)viewController;

@end


//
//  IDLViewController.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 18/03/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDLProtocolHeaders.h"
#import "IDLViewStore.h"
#import "IDLFontStore.h"
#import "IDLInterfaceItem.h"
#import "IDLPersistentFieldStore.h"
#import "IDLTypedefs.h"

#define IDLViewControllerStoredFontFromLabel(__owner__, __label__) [self storedFontWithIdentifier:ObjectWithOwnerToNSString(__label__, __owner__) fromLabel:__label__]

@interface IDLViewController : UIViewController <IDLNavigationAnchor, IDLPopulatableViewController, IDLTypedViewController, IDLActionResponseDelegate, IDLViewControllerActionResponseDelegate, IDLNotificationObservant, IDLViewControllerInterfaceItemSelectionDelegate, IDLConfigurable>

+(void)registerStoryboardForIdentifierUse:(UIStoryboard *)storyboard;
+(NSArray *)registeredIdentifierStoryboards;
+(void)clearRegisteredIdentifierStoryboards;

// view controller identifier

-(UIViewController *)viewControllerWithIdentifier:(NSString *)identifier;
-(UIViewController *)viewControllerWithStoryboardIdentifier:(NSString *)identifier;
+(UIViewController *)viewControllerWithStoryboardIdentifier:(NSString *)identifier storyboard:(UIStoryboard *)storyboard;
-(UIViewController *)viewControllerWithTypeIdentifier:(NSString *)identifier;

// table/collection view

-(void)registerComponentClasses;

// interface items

@property (nonatomic, assign) BOOL registerPlatformReuseIdentifiableNibsAutomatically;

-(IDLInterfaceDataSource *)interfaceDataSourceForView:(UIView *)aView;
-(void)setInterfaceDataSource:(IDLInterfaceDataSource *)dataSource forView:(UIView *)aView;
-(void)setInterfaceDataSource:(IDLInterfaceDataSource *)dataSource forView:(UIView *)aView reloadData:(BOOL)reloadData;
-(void)interfaceItemSelected:(IDLInterfaceItem *)interfaceItem atIndexPath:(NSIndexPath *)indexPath forView:(UIView *)view forViewController:(UIViewController *)viewController;

@property (nonatomic, strong, readonly) IDLViewStore *viewStore;
@property (nonatomic, strong, readonly) IDLFontStore *fontStore;

-(UIFont *)storedFontWithIdentifier:(NSString *)identifier fromLabel:(UILabel *)label;

// interface item selected delegate

@property (nonatomic, weak) id<IDLViewControllerInterfaceItemSelectionDelegate> interfaceItemSelectionDelegate;
@property (nonatomic, weak) id<IDLViewControllerActionResponseDelegate> actionResponseDelegate;

// configure

@property (nonatomic, assign, readonly) BOOL viewControllerConfigured;
-(void)configure;

// refresh

-(BOOL)refreshControlEnabled;
@property (nonatomic, strong, readwrite) UIControl *refreshControl;
-(void)handleRefresh:(id)sender;

// reload content

@property (nonatomic, assign, readonly) BOOL contentNeedsReload;
@property (nonatomic, assign, readonly) NSTimeInterval lastContentReloadTimeStamp;
-(void)setContentNeedsReload;
-(void)reloadContent;

// interface locking

@property (nonatomic, weak) Class interfaceLockOverlayClass;
@property (nonatomic, strong, readonly) UIView *interfaceLockOverlayView;
@property (nonatomic, assign) BOOL keepInterfaceLockStateOnNavigation;
@property (nonatomic, assign) IDLInterfaceLockState interfaceLockState;
@property (nonatomic, assign) NSTimeInterval interfaceLockFadeInDuration;
@property (nonatomic, assign) NSTimeInterval interfaceLockFadeOutDuration;

// persistent

@property (readonly) NSString *persistentFieldIdentifier;

+(NSSet *)persistentFieldsForViewController:(NSString *)uniqueIdentifier;
+(IDLPersistentField *)persistentFieldForViewController:(NSString *)uniqueIdentifier setterSelector:(SEL)setterSelector;
+(void)setPersistentFieldValue:(NSString *)fieldValue forViewController:(NSString *)uniqueIdentifier setterSelector:(SEL)setterSelector;

-(NSSet *)persistentFields;
-(IDLPersistentField *)persistentFieldWithSetterSelector:(SEL)setterSelector;
-(void)setPersistentFieldValue:(NSString *)fieldValue setterSelector:(SEL)setterSelector;
-(void)autoFillPersistentFields;
-(void)autoFillPersistentField:(IDLPersistentField *)field;

// keyboard

-(void)keyboardWillShow;
-(void)keyboardDidHide;
@property (nonatomic, assign, readonly) BOOL keyboardVisible;

// miscel

+(IDLSystemVersion)deviceSystemVersion;
@property (readonly) IDLSystemVersion deviceSystemVersion;

-(NSArray *)identifiersWithinViewControllerHierachy;

@property (readonly) UINavigationController *rootNavigationController;
@property (nonatomic, strong, readwrite) UIColor *backgroundColor;
@property (readonly) NSTimeInterval age;
@property (readonly) NSTimeInterval visibleAge;
@property (nonatomic, assign, readonly) NSTimeInterval viewWillAppearTimeStamp;
@property (nonatomic, assign, readonly) NSTimeInterval viewVisibleTimeStamp;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong, readonly) NSCache *cache;

@end

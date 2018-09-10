//
//  IDLViewController.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 18/03/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLViewController.h"
#import "IDLViewControllerManager.h"
#import "IDLAbstractModel.h"
#import "IDLInterfaceDataSourceHeaders.h"
#import "IDLCommonMacros.h"
#import "IDLNSInlineExtensions.h"
#import "IDLCategoryUIKitHeaders.h"
#import "IDLCategoryFoundationHeaders.h"
#import "IDLPopulatableViewAssistantManager.h"
#import "UIFont+Idlepixel.h"
#import "IDLViewManager.h"

@interface IDLViewController ()

-(void)configureViewControllerAtInit;
@property (nonatomic, assign, readwrite) BOOL viewControllerConfigured;
@property (nonatomic, strong, readwrite) IDLViewStore *viewStore;
@property (nonatomic, strong, readwrite) IDLFontStore *fontStore;

#pragma mark interface items

@property (nonatomic, strong) IDLInterfaceDataSourceCollection *interfaceDataSourceCollection;
-(IDLInterfaceDataSource *)interfaceItemsForKey:(NSObject<NSCopying> *)aKey;
-(void)setInterfaceDataSource:(IDLInterfaceDataSource *)dataSource forKey:(NSObject<NSCopying> *)aKey;

#pragma mark miscellanious

@property (nonatomic, assign, readwrite) NSTimeInterval viewWillAppearTimeStamp;
@property (nonatomic, assign, readwrite) NSTimeInterval viewVisibleTimeStamp;
@property (nonatomic, assign) BOOL viewWillAppearTimeStampValid;
@property (nonatomic, assign) BOOL viewVisibleTimeStampValid;
@property (nonatomic, assign, readwrite) BOOL keyboardVisible;
@property (nonatomic, strong, readwrite) NSCache *cache;

@property (nonatomic, assign, readwrite) BOOL contentNeedsReload;
@property (nonatomic, assign, readwrite) NSTimeInterval lastContentReloadTimeStamp;

#pragma mark overlay

@property (nonatomic, strong, readwrite) UIView *interfaceLockFrozenView;
@property (nonatomic, strong, readwrite) UIView *interfaceLockOverlayView;

@end

@implementation IDLViewController

static NSArray *idl_registeredIdentifierStoryboards = nil;

+(void)registerStoryboardForIdentifierUse:(UIStoryboard *)storyboard
{
    if (storyboard != nil) {
        if (idl_registeredIdentifierStoryboards == nil) {
            idl_registeredIdentifierStoryboards = [NSArray arrayWithObject:storyboard];
        } else if (![idl_registeredIdentifierStoryboards containsObject:storyboard]) {
            idl_registeredIdentifierStoryboards = [idl_registeredIdentifierStoryboards arrayByAddingObject:storyboard];
        }
    }
}

+(NSArray *)registeredIdentifierStoryboards
{
    if (idl_registeredIdentifierStoryboards != nil) {
        return [NSArray arrayWithArray:idl_registeredIdentifierStoryboards];
    } else {
        return nil;
    }
}

+(void)clearRegisteredIdentifierStoryboards
{
    idl_registeredIdentifierStoryboards = nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self configureViewControllerAtInit];
    }
    return self;
}

#pragma mark - Populatable

-(IDLPopulatableViewAssistantManager *)populatableAssistantManager
{
    return [IDLPopulatableViewAssistantManager sharedManager];
}

+(void)registerPopulatableViewControllerAssistants:(IDLPopulatableViewAssistantManager *)manager
{
    // do nothing
}

#pragma mark - Typed view controller

-(UIViewController *)viewControllerWithIdentifier:(NSString *)identifier
{
    UIViewController *vc = nil;
    if (identifier != nil) {
        vc = [self viewControllerWithStoryboardIdentifier:identifier];
        if (vc == nil) {
            vc = [self viewControllerWithTypeIdentifier:identifier];
        }
    }
    return vc;
}

-(UIViewController *)viewControllerWithStoryboardIdentifier:(NSString *)identifier
{
    UIViewController *vc = nil;
    if (identifier != nil) {
        vc = [[self class] viewControllerWithStoryboardIdentifier:identifier storyboard:self.storyboard];
        if (vc == nil) {
            vc = [[self class] viewControllerWithRegisteredStoryboardIdentifier:identifier];
        }
    }
    return vc;
}

+(UIViewController *)viewControllerWithRegisteredStoryboardIdentifier:(NSString *)identifier
{
    UIViewController *vc = nil;
    if (identifier != nil) {
        NSArray *storyboards = [self registeredIdentifierStoryboards];
        for (UIStoryboard *storyboard in storyboards) {
            vc = [self viewControllerWithStoryboardIdentifier:identifier storyboard:storyboard];
            if (vc != nil) break;
        }
    }
    return vc;
}

+(UIViewController *)viewControllerWithStoryboardIdentifier:(NSString *)identifier storyboard:(UIStoryboard *)storyboard
{
    UIViewController *vc = nil;
    if (identifier != nil && storyboard != nil) {
        @try {
            vc = [storyboard instantiateViewControllerWithIdentifier:identifier];
        }
        @catch (NSException *exception) {
            //
        }
        if (vc == nil) {
            Class vcClass = [IDLViewControllerManager viewControllerClassWithTypeIdentifier:identifier];
            if (vcClass != nil) {
                identifier = [vcClass className];
                @try {
                    vc = [storyboard instantiateViewControllerWithIdentifier:identifier];
                }
                @catch (NSException *exception) {
                    //
                }
            }
        }
        vc.storyboardIdentifier = identifier;
    }
    return vc;
}

-(UIViewController *)viewControllerWithTypeIdentifier:(NSString *)identifier
{
    UIViewController *vc = nil;
    if (identifier != nil) {
        Class vcClass = [IDLViewControllerManager viewControllerClassWithTypeIdentifier:identifier];
        if (vcClass != nil) {
            vc = [vcClass platformSubclassInstanceWithNib];
        }
    }
    return vc;
}

#pragma mark - Initialisation

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self configureViewControllerAtInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configureViewControllerAtInit];
    }
    return self;
}

-(void)configureViewControllerAtInit
{
    if (!_viewControllerConfigured) {
        [self configure];
    }
}

-(void)configure
{
    self.viewControllerConfigured = YES;
    self.viewStore = [IDLViewStore new];
    self.fontStore = [IDLFontStore new];
    self.interfaceLockFadeInDuration = 0.1f;
    self.interfaceLockFadeOutDuration = 0.4f;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //
    self.backgroundColor = self.backgroundColor;
    //
    [self registerComponentClasses];
}

- (void)viewWillAppear:(BOOL)animated
{
    _viewWillAppearTimeStamp = SystemTimeSinceSystemStartup();
    _viewWillAppearTimeStampValid = YES;
    //
    [super viewWillAppear:animated];
    //
    if (!self.keepInterfaceLockStateOnNavigation) {
        self.interfaceLockState = IDLInterfaceLockStateUnlocked;
    }
    //
    [self setupObservers];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _viewVisibleTimeStamp = SystemTimeSinceSystemStartup();
    _viewVisibleTimeStampValid = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeObservers];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.viewStore clearStore];
    self.keyboardVisible = NO;
    _viewVisibleTimeStamp = NSTimeIntervalDistantFuture;
    _viewVisibleTimeStampValid = NO;
}

#pragma mark - IDLTypedViewController

+(NSString *)typeIdentifier
{
    return nil;
}

-(NSString *)typeIdentifier
{
    return [[self class] typeIdentifier];
}

+(NSArray *)typeIdentifiers
{
    return nil;
}

-(NSArray *)typeIdentifiers
{
    return [[self class] typeIdentifiers];
}

+(IDLTypedUserInterfaceIdiom)typeUserInterface
{
    return IDLTypedUserInterfaceIdiomUnspecified;
}

-(IDLTypedUserInterfaceIdiom)typeUserInterface
{
    return [[self class] typeUserInterface];
}

#pragma mark - Navigation

-(NSArray *)identifiersWithinViewControllerHierachy
{
    NSMutableArray *identifiers = [NSMutableArray array];
    UIViewController *vc = self;
    NSString *identifier = nil;
    
    do {
        
        identifier = vc.storyboardOrTypeIdentifier;
        if (identifier != nil) {
            [identifiers addObject:identifier];
        } else {
            [identifiers addObject:NSNULL];
        }
        
        // check view controller array
        if ([vc.parentViewController isKindOfClass:[UINavigationController class]]) {
            BOOL found = NO;
            NSArray *array = [(UINavigationController *)[vc parentViewController] viewControllers];
            array = array.reversedArray;
            for (UIViewController *arrayVC in array) {
                if (arrayVC == self) {
                    found = YES;
                } else if (found) {
                    identifier = arrayVC.storyboardOrTypeIdentifier;
                    if (identifier != nil) {
                        [identifiers addObject:identifier];
                    } else {
                        [identifiers addObject:NSNULL];
                    }
                }
            }
        }
        
        vc = vc.parentViewController;
        
    } while (vc != nil);
    
    return [NSArray arrayWithArray:identifiers];
}

-(UINavigationController *)rootNavigationController
{
    return CLASS_OR_NIL([[[UIApplication sharedApplication] keyWindow] rootViewController],UINavigationController);
}

#pragma mark - IDLNavigationAnchor

+(NSString *)navigationAnchor
{
    return nil;
}

-(NSString *)navigationAnchor
{
    return [[self class] navigationAnchor];
}

-(BOOL)hasNavigationAnchor:(NSString *)anchor
{
    return NSObjectEquals(anchor, self.navigationAnchor);
}

#pragma mark - Lock Interface

-(void)setInterfaceLockState:(IDLInterfaceLockState)interfaceLockState
{
    _interfaceLockState = interfaceLockState;
    
    UIView *interfaceLockView = nil;
    
    if (interfaceLockState != IDLInterfaceLockStateFrozen) {
        if (self.interfaceLockFrozenView != nil) {
            interfaceLockView = self.interfaceLockFrozenView;
            self.interfaceLockFrozenView = nil;
        }
    }
    
    if (interfaceLockState != IDLInterfaceLockStateOverlay || ![self.interfaceLockOverlayView isKindOfClass:[self.interfaceLockOverlayClass class]]) {
        if (self.interfaceLockOverlayView != nil) {
            [interfaceLockView removeFromSuperview];
            interfaceLockView = self.interfaceLockOverlayView;
            self.interfaceLockOverlayView = nil;
        }
    }
     
    if (interfaceLockState != IDLInterfaceLockStateUnlocked) {
        
        UIViewAutoresizing autoresizingMask =  UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        CGRect frame = self.view.bounds;
        
        if (interfaceLockView != nil) {
            [interfaceLockView removeFromSuperview];
            interfaceLockView = nil;
        }
        
        if (interfaceLockState == IDLInterfaceLockStateFrozen) {
            
            if (self.interfaceLockFrozenView == nil) {
                self.interfaceLockFrozenView = [[UIView alloc] initWithFrame:frame];
                self.interfaceLockFrozenView.autoresizingMask = autoresizingMask;
                self.interfaceLockFrozenView.backgroundColor = [UIColor clearColor];
                self.interfaceLockFrozenView.userInteractionEnabled = YES;
                self.interfaceLockOverlayView.alpha = 0.0f;
            }
            interfaceLockView = self.interfaceLockFrozenView;
            
        } else if (interfaceLockState == IDLInterfaceLockStateOverlay && [self.interfaceLockOverlayClass isSubclassOfClass:[UIView class]]) {
            
            if (self.interfaceLockOverlayView == nil) {
                self.interfaceLockOverlayView = [[self.interfaceLockOverlayClass class] platformSubclassInstanceWithNib];
                if (self.interfaceLockOverlayView == nil) {
                    self.interfaceLockOverlayView = [[[self.interfaceLockOverlayClass class] alloc] initWithFrame:frame];
                }
                self.interfaceLockOverlayView.autoresizingMask = autoresizingMask;
                self.interfaceLockOverlayView.userInteractionEnabled = YES;
                self.interfaceLockOverlayView.alpha = 0.0f;
            }
            interfaceLockView = self.interfaceLockOverlayView;
            
        }
        
        if (interfaceLockView != nil) {
            
            interfaceLockView.frame = frame;
            [self.view addSubview:interfaceLockView];
            
            [UIView animateWithDuration:self.interfaceLockFadeInDuration animations:^(void){
                interfaceLockView.alpha = 1.0f;
            }];
        }
        
    } else {
        
        if (interfaceLockView != nil) {
            
            [UIView animateWithDuration:self.interfaceLockFadeOutDuration animations:^(void){
                interfaceLockView.alpha = 0.0f;
            } completion:^(BOOL finished){
                if (finished) {
                    [interfaceLockView removeFromSuperview];
                }
            }];
        }
    }
}

#pragma mark - refresh control

-(void)handleRefresh:(id)sender
{
    // do nothing, meant for override
}

-(BOOL)refreshControlEnabled
{
    return NO;
}

#pragma mark - background color

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    self.view.backgroundColor = backgroundColor;
}

#pragma mark - interface items

-(IDLInterfaceDataSource *)interfaceDataSourceForView:(UIView *)aView
{
    return [self.interfaceDataSourceCollection dataSourceForView:aView];
}

-(void)setInterfaceDataSource:(IDLInterfaceDataSource *)dataSource forView:(UIView *)aView
{
    [self setInterfaceDataSource:dataSource forView:aView reloadData:NO];
}

-(void)setInterfaceDataSource:(IDLInterfaceDataSource *)dataSource forView:(UIView *)aView reloadData:(BOOL)reloadData
{
    if (self.registerPlatformReuseIdentifiableNibsAutomatically) {
        
        if ([aView isKindOfClass:[UITableView class]]) {
            
            UITableView *tableView = (UITableView *)aView;
            
            NSSet *reuseIdentifiers = dataSource.itemReuseIdentifiers;
            NSSet *viewClasses = [IDLViewManager viewClassesWithReuseIdentifiers:reuseIdentifiers];
            
            Class viewClass = nil;
            
            for (viewClass in viewClasses) {
                [tableView registerPlatformReuseIdentifiableCellClassNib:viewClass];
            }
            
            reuseIdentifiers = dataSource.headerSectionReuseIdentifiers;
            viewClasses = [IDLViewManager viewClassesWithReuseIdentifiers:reuseIdentifiers];
            
            for (viewClass in viewClasses) {
                [tableView registerPlatformReuseIdentifiableViewClassNib:viewClass];
            }
            
            reuseIdentifiers = dataSource.footerSectionReuseIdentifiers;
            viewClasses = [IDLViewManager viewClassesWithReuseIdentifiers:reuseIdentifiers];
            
            for (viewClass in viewClasses) {
                [tableView registerPlatformReuseIdentifiableViewClassNib:viewClass];
            }
            
        } else if ([aView isKindOfClass:[UICollectionView class]]) {
            
            UICollectionView *collectionView = (UICollectionView *)aView;
            
            NSSet *reuseIdentifiers = dataSource.itemReuseIdentifiers;
            NSSet *viewClasses = [IDLViewManager viewClassesWithReuseIdentifiers:reuseIdentifiers];
            
            Class viewClass = nil;
            
            for (viewClass in viewClasses) {
                [collectionView registerPlatformReuseIdentifiableCellClassNib:viewClass];
            }
            
            reuseIdentifiers = dataSource.headerSectionReuseIdentifiers;
            viewClasses = [IDLViewManager viewClassesWithReuseIdentifiers:reuseIdentifiers];
            
            for (viewClass in viewClasses) {
                [collectionView registerPlatformReuseIdentifiableViewClassNib:viewClass forSupplementaryViewOfKind:UICollectionElementKindSectionHeader];
            }
            
            reuseIdentifiers = dataSource.footerSectionReuseIdentifiers;
            viewClasses = [IDLViewManager viewClassesWithReuseIdentifiers:reuseIdentifiers];
            
            for (viewClass in viewClasses) {
                [collectionView registerPlatformReuseIdentifiableViewClassNib:viewClass forSupplementaryViewOfKind:UICollectionElementKindSectionFooter];
            }
        }
    }
    
    if (self.interfaceDataSourceCollection == nil) {
        self.interfaceDataSourceCollection = [IDLInterfaceDataSourceCollection new];
    }
    [self.interfaceDataSourceCollection setDataSource:dataSource forView:aView];
    
    if (reloadData && [aView respondsToSelector:@selector(reloadData)]) {
        [(UITableView *)aView reloadData];
    }
}

-(IDLInterfaceDataSource *)interfaceItemsForKey:(NSObject<NSCopying> *)aKey
{
    return [self.interfaceDataSourceCollection dataSourceForKey:aKey];
}

-(void)setInterfaceDataSource:(IDLInterfaceDataSource *)dataSource forKey:(NSObject<NSCopying> *)aKey
{
    if (self.interfaceDataSourceCollection == nil) {
        self.interfaceDataSourceCollection = [IDLInterfaceDataSourceCollection new];
    }
    [self.interfaceDataSourceCollection setDataSource:dataSource forKey:aKey];
}

-(void)interfaceItemSelected:(IDLInterfaceItem *)interfaceItem atIndexPath:(NSIndexPath *)indexPath forView:(UIView *)view forViewController:(UIViewController *)viewController
{
    // do nothing, meant for override
}

#pragma mark - reload content

-(void)setContentNeedsReload
{
    self.contentNeedsReload = YES;
    [self performSelector:@selector(checkContentNeedsReload:) withObject:@(SystemTimeSinceSystemStartup()) afterDelay:0.05f];
}

- (void)checkContentNeedsReload:(NSNumber *)checkRequestTimeStamp
{
    if (self.contentNeedsReload && (checkRequestTimeStamp == nil || checkRequestTimeStamp.floatValue > self.lastContentReloadTimeStamp)) {
        [self reloadContent];
    } else {
        //IDLLog(@"Warning: Ignoring reloadContent made before the last reload.");
    }
}

-(void)reloadContent
{
    self.contentNeedsReload = NO;
}

#pragma mark - view/font store

-(UIFont *)storedFontWithIdentifier:(NSString *)identifier fromLabel:(UILabel *)label
{
    UIFont *labelFont = [self.fontStore storedFontWithIdentifier:identifier];
    if (labelFont == nil) {
        labelFont = label.font;
        labelFont.attributedStringAttributes = label.attributedStringAttributes;
        [self.fontStore storeFont:labelFont withIdentifier:identifier];
    }
    return labelFont;
}

#pragma mark - Miscellanious convenience

+(IDLSystemVersion)deviceSystemVersion
{
    return [UIDevice currentDevice].deviceSystemVersion;
}

-(IDLSystemVersion)deviceSystemVersion
{
    return [[self class] deviceSystemVersion];
}

-(NSTimeInterval)age
{
    if (_viewWillAppearTimeStampValid) {
        return SystemTimeSinceInterval(_viewWillAppearTimeStamp);
    } else {
        return -1.0f;
    }
}

-(NSTimeInterval)visibleAge
{
    if (_viewVisibleTimeStampValid) {
        return SystemTimeSinceInterval(_viewVisibleTimeStamp);
    } else {
        return -1.0f;
    }
}

-(NSTimeInterval)viewWillAppearTimeStamp
{
    if (_viewWillAppearTimeStampValid) {
        return _viewWillAppearTimeStamp;
    } else {
        return NSTimeIntervalDistantFuture;
    }
}

#pragma mark - IDLNotificationObservant

-(void)setupObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationUIKeyboardDidHideNotification) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationUIKeyboardWillShowNotification) name:UIKeyboardWillShowNotification object:nil];
}

-(void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

-(void)notificationObserved:(NSNotification *)notification
{
    // do nothing, meant for override
}

#pragma mark - ActionResponseDelegate

-(BOOL)actionEncountered:(SEL)actionSelector withSender:(id)sender fromSource:(UIView *)aSource
{
    BOOL handled = NO;
    if ([self.actionResponseDelegate respondsToSelector:@selector(actionEncountered:withSender:fromSource:forViewController:)]) {
        handled = [self.actionResponseDelegate actionEncountered:actionSelector withSender:sender fromSource:aSource forViewController:self];
    }
    return handled;
}

-(BOOL)actionEncountered:(SEL)actionSelector withSender:(id)sender fromSource:(UIView *)aSource forViewController:(UIViewController *)viewController
{
    return NO;
}

#pragma mark - table/collection view

-(void)registerComponentClasses
{
    // do nothing
}

#pragma mark - Persistent Fields

-(NSString *)persistentFieldIdentifier
{
    return nil;
}

+(NSSet *)persistentFieldsForViewController:(NSString *)uniqueIdentifier
{
    IDLAbstractModel *model = [IDLAbstractModel sharedModel];
    return [model.persistentFieldStore fieldsForOwner:uniqueIdentifier];
}

+(IDLPersistentField *)persistentFieldForViewController:(NSString *)uniqueIdentifier setterSelector:(SEL)setterSelector
{
    IDLAbstractModel *model = [IDLAbstractModel sharedModel];
    return [model.persistentFieldStore fieldForOwner:uniqueIdentifier setterSelector:setterSelector];
}

+(void)setPersistentFieldValue:(NSString *)fieldValue forViewController:(NSString *)uniqueIdentifier setterSelector:(SEL)setterSelector
{
    IDLAbstractModel *model = [IDLAbstractModel sharedModel];
    if (model != nil) {
        IDLPersistentField *field = [self persistentFieldForViewController:uniqueIdentifier setterSelector:setterSelector];
        if (field == nil) {
            field = [IDLPersistentField new];
            field.owner = uniqueIdentifier;
            field.setterSelector = setterSelector;
            [model.persistentFieldStore addField:field];
        }
        field.fieldValue = fieldValue;
    }
}

-(NSSet *)persistentFields
{
    return [[self class] persistentFieldsForViewController:self.persistentFieldIdentifier];
}

-(IDLPersistentField *)persistentFieldWithSetterSelector:(SEL)setterSelector
{
    return [[self class] persistentFieldForViewController:self.persistentFieldIdentifier setterSelector:setterSelector];
}

-(void)setPersistentFieldValue:(NSString *)fieldValue setterSelector:(SEL)setterSelector
{
    [[self class] setPersistentFieldValue:fieldValue forViewController:self.persistentFieldIdentifier setterSelector:setterSelector];
}

- (void)autoFillPersistentFields
{
    NSSet *fields = [self persistentFields];
    for (IDLPersistentField *field in fields) {
        [self autoFillPersistentField:field];
    }
}

-(void)autoFillPersistentField:(IDLPersistentField *)field
{
    if ([field isKindOfClass:[IDLPersistentField class]]) {
        SEL selector = [field setterSelector];
        if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:selector withObject:field.fieldValue];
#pragma clang diagnostic pop
        }
    }
}

#pragma mark - Keyboard

-(void)notificationUIKeyboardDidHideNotification
{
    self.keyboardVisible = NO;
    [self keyboardDidHide];
}

-(void)notificationUIKeyboardWillShowNotification
{
    self.keyboardVisible = YES;
    [self keyboardWillShow];
}

-(void)keyboardDidHide
{
    // do nothing
}

-(void)keyboardWillShow
{
    // do nothing
}

#pragma mark - Cache

-(NSCache *)cache
{
    if (_cache == nil) {
        _cache = [NSCache new];
    }
    return _cache;
}

@end

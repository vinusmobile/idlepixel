//
//  IDLInterfaceItem.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 5/02/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLInterfaceTypedefs.h"
#import "IDLInterfaceElement.h"

NS_INLINE IDLInterfaceAlternatingFlag IDLInterfaceAlternatingFlagToggle(IDLInterfaceAlternatingFlag flag)
{
    if (flag == IDLInterfaceAlternatingFlagEven) {
        return IDLInterfaceAlternatingFlagOdd;
    } else {
        return IDLInterfaceAlternatingFlagEven;
    }
}

@interface IDLInterfaceItem : IDLInterfaceElement

@property (nonatomic, weak) IDLInterfaceItem *parentItem;

@property (nonatomic, strong) NSString *sectionTitle;
@property (nonatomic, strong) NSString *reuseIdentifier;
@property (nonatomic, strong) NSString *populatableAssistantIdentifier;
@property (nonatomic, strong) IDLInterfaceDimensions *dimensions;
@property (nonatomic, assign) BOOL ignoreSelection;
@property (nonatomic, assign) BOOL transitorySelection;
@property (nonatomic, assign) IDLInterfaceItemPosition position;
@property (nonatomic, assign) BOOL manualPosition;

@property (nonatomic, strong) NSString *disclosureImageName;

+(id)itemWithReuseIdentifier:(NSString *)reuseIdentifier;
+(id)itemWithData:(NSObject *)data;
+(id)itemWithData:(NSObject *)data reuseIdentifier:(NSString *)reuseIdentifier;
-(id)initWithData:(NSObject *)data reuseIdentifier:(NSString *)reuseIdentifier;

@end

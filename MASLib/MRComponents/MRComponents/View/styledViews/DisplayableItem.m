//
//  DisplayableItem.h
//  MASClient
//
//  Created by Federico Gasperini on 04/11/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import "DisplayableItem.h"
#import <MRBase/UIColor+colorWithName.h>
#import <objc/runtime.h>

static __strong DisplayableItem* __nullItem;

@implementation DisplayableItem

+(void)load
{
    __nullItem = [[DisplayableItem alloc] init];
    __nullItem.preferredHeight = .01;
}

-(BOOL)isNullItem
{
    return self == __nullItem;
}

+(instancetype)nullItem
{
    return __nullItem;
}

+(instancetype)itemWithDictionary:(NSDictionary *)dict
{
    DisplayableItem* i = [[DisplayableItem alloc] init];
    [i setValuesForKeysWithDictionary:dict];
    return i;
}

+(instancetype)itemWithTitle:(NSString*)title
{
    DisplayableItem* i = [[DisplayableItem alloc] init];
    i.displayTitle = title;
    return i;
}

+(instancetype)itemWithTitle:(NSString*)title andImage:(UIImage*)image
{
    DisplayableItem* i = [[DisplayableItem alloc] init];
    i.displayTitle = title;
    i.displayImage = image;
    return i;
}

+(instancetype)itemWithTitle:(NSString*)title andCustomContent:(id)customContent
{
    DisplayableItem* i = [[DisplayableItem alloc] init];
    i.displayTitle = title;
    i.customContent = customContent;
    return i;
}

-(NSString*)displayTitle
{
    return NSLocalizedString(_displayTitle, @"");
}

-(void)setColor1:(UIColor *)color1
{
    if ([color1 isKindOfClass:[NSString class]]) {
        color1 = [UIColor colorWithHexString:(NSString*)color1];
    }
    _color1 = color1;
}

-(void)setColor2:(UIColor *)color2
{
    if ([color2 isKindOfClass:[NSString class]]) {
        color2 = [UIColor colorWithHexString:(NSString*)color2];
    }
    _color2 = color2;
}

-(void)setColor3:(UIColor *)color3
{
    if ([color3 isKindOfClass:[NSString class]]) {
        color3 = [UIColor colorWithHexString:(NSString*)color3];
    }
    _color3 = color3;
}

-(void)setFont:(UIFont *)font
{
    if ([font isKindOfClass:[NSString class]]) {
        NSArray *fontComponent = [(NSString*)font componentsSeparatedByString:@"@"];
        if ([fontComponent count]==1) {
            _font = [UIFont fontWithName:fontComponent[0] size:_font.pointSize];
        }
        else if ([fontComponent count]==2) {
            _font = [UIFont fontWithName:fontComponent[0] size:[fontComponent[1] floatValue]];
        }
    }
}

-(void)setDisplayImage:(UIImage *)displayImage
{
    if ([displayImage isKindOfClass:[NSString class]]) {
        displayImage = [UIImage imageNamed:(NSString*)displayImage];
    }
    _displayImage = displayImage;
}

@end


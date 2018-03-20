//
//  DisplayableItem.h
//  MASClient
//
//  Created by Federico Gasperini on 04/11/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DisplayableItem <NSObject>

-(void)setConfiguration:(id<DisplayableItem>)configuration;

@optional
-(NSString*)displayTitle;
-(UIImage*)displayImage;
-(NSString*)nibName;
@property (assign, nonatomic) CGFloat preferredHeight;
@property (readwrite, nonatomic) id customContent;
@property (readonly) BOOL isNullItem;
-(NSString*)displayCategoryName;
-(NSString*)displaySubtitle;
-(NSString*)displayFirstDate;
-(NSString*)displayLastDate;
-(UIImage*)secondImage;
-(UIImage*)thirdImage;
-(UIFont*)font;
-(UIColor*)color1;
-(UIColor*)color2;
-(UIColor*)color3;

@end

@interface DisplayableItem : NSObject <DisplayableItem>

+(instancetype)nullItem;

+(instancetype)itemWithDictionary:(NSDictionary*)dict;
+(instancetype)itemWithTitle:(NSString*)title andCustomContent:(id)customContent;
+(instancetype)itemWithTitle:(NSString*)title andImage:(UIImage*)image;
+(instancetype)itemWithTitle:(NSString*)title;

@property (strong, nonatomic) NSString* displayTitle;
@property (strong, nonatomic) UIImage* displayImage;
@property (strong, nonatomic) id customContent;
@property (assign, nonatomic) CGFloat preferredHeight;
@property (strong, nonatomic) NSString* nibName;
@property (strong, nonatomic) UIFont *font;
@property (strong, nonatomic) UIColor *color1;
@property (strong, nonatomic) UIColor *color2;
@property (strong, nonatomic) UIColor *color3;

@end


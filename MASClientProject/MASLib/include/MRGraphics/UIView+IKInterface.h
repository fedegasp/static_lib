//
//  UIView+SOFViewInterface.h
//  SOFLibrary
//
//  Created by Dario Trisciuoglio on 11/08/13.
//  Copyright (c) 2013 Dario Trisciuoglio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ETViewDelegate <NSObject>

@optional

-(void)doActionForKey:(NSString*)actionKey withData:(id)actionData;

@end

@interface UIView (IKInterface)

@property (nonatomic, weak) IBOutlet id<ETViewDelegate> etViewDelegate;
@property (nonatomic, strong) IBInspectable NSString* segueIdentifier;

+ (instancetype)viewWithNib:(NSString*)nibName;

- (void)setCornerRadius:(CGFloat)radius;
- (void)setAllCornerRadius:(CGFloat)radius;
- (void)setCornerWithOption:(UIRectCorner)option andRadius:(CGFloat)radius;
- (void)setBorderWithColor:(UIColor*)color width:(CGFloat)width;
- (void)setBorderMaskWithColor:(UIColor*)color width:(CGFloat)width;
- (void)setShadowWithColor:(UIColor*)color radius:(CGFloat)radius opacity:(CGFloat)opacity offset:(CGSize)size;
- (id)findFirstResponder;
- (NSInteger)length;

+ (id)viewWithNibName:(NSString*)nibName;
+ (id)viewWithColor:(UIColor*)color;

+ (void)fadeInView:(UIView *)view withAnimationDuration:(NSTimeInterval)animationDuration completion:(void (^)(BOOL finished))completion;
+ (void)fadeOutView:(UIView *)view withAnimationDuration:(NSTimeInterval)animationDuration completion:(void (^)(BOOL finished))completion;
+ (void)verticalTranslationView:(UIView *)view withAnimationDuration:(NSTimeInterval)animationDuration andOffset:(CGFloat)offset completion:(void (^)(BOOL finished))completion;



@end

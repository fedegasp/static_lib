//
// MRBadgeView.m
//  ikframework
//
//  Created by Federico Gasperini on 03/11/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import "MRBadgeView.h"
#import "MRBadgeCounter.h"
//#import "NSString+formatUtil.h"

@interface MRBadgeView ()

-(void)mr_setup;

@end

@implementation MRBadgeView

-(instancetype)init
{
   self = [super init];
   if (self)
      [self mr_setup];
   return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
   if (self)
      [self mr_setup];
   return self;
}

-(void)awakeFromNib
{
   [super awakeFromNib];
   [self mr_setup];
}

-(void)mr_setup
{
   self.hidden = YES;
   [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(updateBadgeValue:)
                                                name:MRUpdateBadgeValue
                                              object:nil];
   [self setAppearence];
}

- (void) dealloc {
   [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setFrame:(CGRect)frame
{
   [super setFrame:frame];
   [self setAppearence];
}

-(void)setBackgroudView:(UIView *)backgroudView
{
   _backgroudView = backgroudView;
   [self setAppearence];
}

-(void)setBadgeTag:(NSString *)badgeTag
{
   _badgeTag = badgeTag;
   [self setAppearence];
}

-(void)setAppearence
{
   if (!self.backgroudView)
   {
      self.backgroundColor = [UIColor redColor];
      self.layer.cornerRadius = MIN(self.frame.size.width, self.frame.size.height) / 2.0f;
   }
   else
   {
      self.backgroudView.frame = self.bounds;
      self.backgroundColor = [UIColor clearColor];
      self.layer.cornerRadius = .0f;
   }
   if (self.badgeTag)
      [self setBadgeValue:[[MRBadgeCounter defaultCounter] valueForBadge:self.badgeTag]];
   else
      [self setBadgeValue:[[MRBadgeCounter defaultCounter] overallDescription]];
}

-(void)updateBadgeValue:(NSNotification*)notification
{
      if (self.badgeTag && [self.badgeTag isEqualToString:notification.userInfo[MRBadgeTag]]){
         
         [self setBadgeValue:[notification.object valueForBadge:self.badgeTag]];
      }
      else
      {
         [self setBadgeValue:[notification.object overallDescription]];
      }
}

-(void)setActive:(BOOL)active
{
   _active = active;
   [self setAppearence];
}

-(void)didMoveToSuperview
{
   [super didMoveToSuperview];
   if (self.superview)
      [self setAppearence];
}

-(void)setBadgeValue:(id)value
{
   NSString* text = [value description];
   self.hidden = !self.active || (text.length == 0 || (text.integerValue == 0));
   self.label.text = text;
}

@end

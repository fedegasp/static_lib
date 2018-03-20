//
//  MRButton.m
//  MASClient
//
//  Created by Federico Gasperini on 09/12/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import "MRButton.h"
#import <MRGraphics/UIImage+IKInterface.h>

static UIControlState ControlStates[] = {UIControlStateNormal,
   UIControlStateHighlighted,
   UIControlStateDisabled,
   UIControlStateSelected};


@implementation MRButton
{
   UIControlContentHorizontalAlignment _originalAlignment;
   UIEdgeInsets _originalTitleInset;
   UIEdgeInsets _originalImageInset;
   UIEdgeInsets _originalContentInset;
}

//CAN_FLIP

@synthesize titleTextAlignment = _titleTextAlignment;

-(void)setImage:(UIImage *)image forState:(UIControlState)state
{
   if (self.imageIsTemplate)
   {
      if(state == UIControlStateNormal || state == UIControlStateHighlighted)
         [super setImage:[image imageWithColor:self.tintColor] forState:state];
      else if(state == UIControlStateSelected)
         [super setImage:[image imageWithColor:self.selectedTintColor] forState:state];
      else if(state == UIControlStateDisabled)
         [super setImage:[image imageWithColor:self.disabledTintColor] forState:state];
   }
   else
      [super setImage:image forState:state];
}

-(void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state
{
   if (self.backgroundImageIsTemplate)
   {
      if(state == UIControlStateNormal || state == UIControlStateHighlighted)
         [super setBackgroundImage:[image imageWithColor:self.tintColor] forState:state];
      else if(state == UIControlStateSelected)
         [super setBackgroundImage:[image imageWithColor:self.selectedTintColor] forState:state];
      else if(state == UIControlStateDisabled)
         [super setBackgroundImage:[image imageWithColor:self.disabledTintColor] forState:state];
   }
   else
      [super setBackgroundImage:image forState:state];
}

-(void)adjustImagesTint
{
   if (self.backgroundImageIsTemplate)
   {
      for (int i = 0; i < 4; i++)
      {
         UIImage* img = [self backgroundImageForState:ControlStates[i]];
         if(ControlStates[i] == UIControlStateNormal || ControlStates[i] == UIControlStateHighlighted)
            img = [img imageWithColor:self.tintColor];
         else if(ControlStates[i] == UIControlStateSelected)
            img = [img imageWithColor:self.selectedTintColor];
         else
            img = [img imageWithColor:self.disabledTintColor];
         [super setBackgroundImage:img forState:ControlStates[i]];
      }
   }
   if (self.imageIsTemplate)
   {
      for (int i = 0; i < 4; i++)
      {
         UIImage* img = [self imageForState:ControlStates[i]];
         if(ControlStates[i] == UIControlStateNormal || ControlStates[i] == UIControlStateHighlighted)
            img = [img imageWithColor:self.tintColor];
         else if(ControlStates[i] == UIControlStateSelected)
            img = [img imageWithColor:self.selectedTintColor];
         else
            img = [img imageWithColor:self.disabledTintColor];
         [super setImage:img forState:ControlStates[i]];
      }
   }
}

-(void)setTintColor:(UIColor *)tintColor
{
   [super setTintColor:tintColor];
   [self adjustImagesTint];
}

-(void)awakeFromNib
{
   [super awakeFromNib];
   if(self.borderRadius > 0)
      [self setAllCornerRadius:self.borderRadius];
   if(self.borderColor)
      [self setBorderWithColor:self.borderColor];
   
   if (self.disabledColor == nil)
      self.disabledColor = [UIColor colorWithRed:.9f green:.9f blue:.9f alpha:1.0f];
   
   [self setEnabled:[self isEnabled]];
   [self setSelected:[self isSelected]];
   
   _originalAlignment = self.contentHorizontalAlignment;
   _originalTitleInset = self.titleEdgeInsets;
   _originalImageInset = self.imageEdgeInsets;
   _originalContentInset = self.contentEdgeInsets;
   
   self.titleLabel.shadowColor = [UIColor clearColor];
   if (self.autoShrink) {
      self.titleLabel.numberOfLines = 1;
      self.titleLabel.adjustsFontSizeToFitWidth = YES;
      self.titleLabel.lineBreakMode = NSLineBreakByClipping;
   }
   
   self.exclusiveTouch = YES;
   
   [self adjustImagesTint];
   
   if (self.customFont)
   {
      CGFloat fsize = self.titleLabel.font.pointSize;
      if (self.customFontSize)
         fsize = [self.customFontSize floatValue];
      if (fsize <= .0f)
         fsize = [UIFont systemFontSize];
      
      UIFont* f = [UIFont fontWithName:self.customFont size:fsize];
      if (f)
         self.titleLabel.font = f;
      else if (self.titleLabel.font)
         self.titleLabel.font = [self.titleLabel.font fontWithSize:fsize];
   }
   
   // FIX sfarfallio
   [self setImage:[self imageForState:UIControlStateNormal]
         forState:UIControlStateNormal|UIControlStateHighlighted|UIControlStateSelected|UIControlStateDisabled];
   
   [self setBackgroundImage:[self backgroundImageForState:UIControlStateNormal]
                   forState:UIControlStateNormal|UIControlStateHighlighted|UIControlStateSelected|UIControlStateDisabled];
   
   //   if (UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, self.titleEdgeInsets))
   //      self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 2, 0);
   
   //[self setTitle:self.titleLabel.text forState:UIControlStateNormal];
    if (self.titleEdgeTop || self.titleEdgeLeft || self.titleEdgeRight || self.titleEdgeBottom) {
        self.titleEdgeInsets = UIEdgeInsetsMake(self.titleEdgeTop.floatValue, self.titleEdgeLeft.floatValue, self.titleEdgeBottom.floatValue, self.titleEdgeRight.floatValue);
    }
}

-(void)setHidden:(BOOL)hidden
{
   [super setHidden:hidden];
   for (UILabel* label in self.externLabels)
      label.hidden = hidden;
}

-(void)setAlpha:(CGFloat)alpha
{
   [super setAlpha:alpha];
   for (UILabel* label in self.externLabels)
      label.alpha = alpha;
}

- (void)setEnabled:(BOOL)enabled
{
   [super setEnabled:enabled];
   UIColor* color = [self titleColorForState:self.state];
   for (UILabel* label in self.externLabels)
      label.textColor = color;
   if (self.normalColor && self.disabledColor)
   {
      if (!enabled)
         self.backgroundColor = self.disabledColor;
      else if (self.selected)
         self.backgroundColor = self.selectedColor ?: self.normalColor;
      else
         self.backgroundColor = self.normalColor;
   }
}

- (void)setSelected:(BOOL)selected
{
   [super setSelected:selected];
   UIColor* color = [self titleColorForState:self.state];
   for (UILabel* label in self.externLabels)
      label.textColor = color;
   if(self.normalColor && self.selectedColor)
   {
      if(selected)
      {
         if (self.normalColor)
            self.backgroundColor = self.selectedColor ?: (self.enabled ? (self.selectedColor ?: self.normalColor) : self.normalColor);
         if(self.borderColor)
            [self setBorderWithColor:self.borderSelectedColor];
      }
      else
      {
         if(self.borderColor)
            [self setBorderWithColor:self.borderColor];
         if (self.normalColor)
            self.backgroundColor = (self.enabled ? self.normalColor : (self.disabledColor ?: self.normalColor));
      }
   }
}

-(void)setBorderWithColor:(UIColor*)color
{
   CALayer* layerView = [self layer];
    if (self.borderWidth) {
        [layerView setBorderWidth:self.borderWidth];
    }
   [layerView setBorderColor:[color CGColor]];
}

- (void)setAllCornerRadius:(CGFloat)radius
{
   CALayer* layerView = [self layer];
   layerView.cornerRadius = radius;
}

- (void)setHighlighted:(BOOL)highlighted
{
   [super setHighlighted:highlighted];
   UIColor* color = [self titleColorForState:self.state];
   for (UILabel* label in self.externLabels)
      label.textColor = color;
}

-(void)setUnderline:(BOOL)underline
{
    _underline = underline;
    if (_underline)
    {
        NSMutableAttributedString *underlineString = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
        
        [underlineString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [underlineString length])];
        
        [self setAttributedTitle:underlineString forState:UIControlStateNormal];
    }
    else
        [self setTitle:self.titleLabel.text forState:UIControlStateNormal];
}


-(void)dealloc
{
   [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

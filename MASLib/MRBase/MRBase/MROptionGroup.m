//
//  OptionButtonGroup.m
//  ikframework
//
//  Created by Federico Gasperini on 01/08/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import "MROptionGroup.h"
#import <objc/runtime.h>


NSNotificationName kMROptionGroupDidChangeSelection = @"kMROptionGroupDidChangeSelection";
NSNotificationName kMROptionGroupSameSelection   = @"kMROptionGroupSameSelection";

static void* OptionGroupContext = &OptionGroupContext;

@interface MROptionGroup ()

@property (strong, nonatomic) NSArray* currSelection;

@end

@implementation MROptionGroup
{
   NSArray* _options;
}

-(NSArray*)options
{
   if (!_options)
      _options = [NSArray array];
   return _options;
}

-(NSArray*)currSelection
{
   if (!_currSelection)
      _currSelection = [[NSArray alloc] init];
   return _currSelection;
}

-(void)setOptions:(NSArray *)options
{
   for (UIControl* control in _options)
   {
      [control removeTarget:self
                     action:@selector(selectMe:)
           forControlEvents:UIControlEventTouchUpInside|UIControlEventEditingDidBegin];
      control.optionGroup = nil;
   }
   
   _options = options;
   
   for (UIControl* control in _options)
   {
      [control addTarget:self
                  action:@selector(selectMe:)
        forControlEvents:UIControlEventTouchUpInside|UIControlEventEditingDidBegin];
      control.optionGroup = self;
   }
}

-(IBAction)selectMe:(UIControl*)sender
{
   BOOL notifyObservers = self.multipleSelection
                          ||
                         (![self.currSelection containsObject:sender]
                          ||
                          self.clearable);

   if (notifyObservers)
      [self willChangeValueForKey:NSStringFromSelector(@selector(selection))];

   if (self.multipleSelection)
      ((UIControl*)sender).selected = !sender.selected;
   else
      for (UIControl* control in self.options)
         control.selected = (control == sender) && !(self.clearable && sender.selected);
   
   NSArray* currArray = self.selection;
   self.currSelection = currArray;
   
   if (notifyObservers)
   {
      [self didChangeValueForKey:NSStringFromSelector(@selector(selection))];
      
      [[NSNotificationCenter defaultCenter] postNotificationName:kMROptionGroupDidChangeSelection
                                                          object:self];
   }
   else
   {
       [[NSNotificationCenter defaultCenter] postNotificationName:kMROptionGroupSameSelection
                                                           object:self];
   }
    
}

-(IBAction)clearSelection
{
   BOOL notify = self.currSelection.count > 0;
   if (notify)
      [self willChangeValueForKey:NSStringFromSelector(@selector(selection))];
   for (UIControl* control in self.options)
      control.selected = NO;
   self.currSelection = nil;
   if (notify)
   {
      [self didChangeValueForKey:NSStringFromSelector(@selector(selection))];
      [[NSNotificationCenter defaultCenter] postNotificationName:kMROptionGroupDidChangeSelection
                                                          object:self];
   }
}

-(NSArray*)selection
{
   return [self.options filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"selected == YES"]];
}

@end


@implementation UIControl (OptionGroup)
static const char _option_group_key_;

-(void)becomeOptionSelection
{
   if ([self isEnabled])
      [self.optionGroup selectMe:self];
}

-(void)setOptionGroup:(MROptionGroup *)optionGroup
{
   objc_setAssociatedObject(self, &_option_group_key_, optionGroup, OBJC_ASSOCIATION_ASSIGN);
}

-(MROptionGroup*)optionGroup
{
   return objc_getAssociatedObject(self, &_option_group_key_);
}

@end

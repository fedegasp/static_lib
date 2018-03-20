//
//  NibEmbeddingView.m
//  MASClient
//
//  Created by Federico Gasperini on 19/11/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import "NibEmbeddingView.h"


@implementation NibEmbeddingView
{
   __weak UIView* _embeddedView;
}

-(void)awakeFromNib
{
   [super awakeFromNib];
   if (self.nibName.length)
   {
      UINib* nib = [UINib nibWithNibName:self.nibName
                                  bundle:nil];
      if (nib)
      {
         NSArray* a = [nib instantiateWithOwner:nil
                                        options:nil];
         if (a.count > self.objectIndex &&
             [a[self.objectIndex] isKindOfClass:[UIView class]])
         {
            UIView* v = [a objectAtIndex:self.objectIndex];
            _embeddedView = v;

            if (!self.centerContent)
            {
               v.translatesAutoresizingMaskIntoConstraints = NO;
               [self addSubview:v];
               NSString* horizontal = [NSString stringWithFormat:@"H:|-%@-[embedded]-%@-|",
                                       @(self.edgeInset.left),@(self.edgeInset.right)];
               NSString* vertical =   [NSString stringWithFormat:@"V:|-%@-[embedded]-%@-|",
                                       @(self.edgeInset.top),@(self.edgeInset.bottom)];
               NSDictionary* views = @{@"embedded":v};
               NSArray* hc = [NSLayoutConstraint constraintsWithVisualFormat:horizontal
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views];
               NSArray* vc = [NSLayoutConstraint constraintsWithVisualFormat:vertical
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views];
               [v addConstraints:hc];
               [v addConstraints:vc];
               [self setNeedsUpdateConstraints];
            }
            else
            {
               v.autoresizingMask =
               UIViewAutoresizingFlexibleLeftMargin|
               UIViewAutoresizingFlexibleRightMargin|
               UIViewAutoresizingFlexibleTopMargin|
               UIViewAutoresizingFlexibleBottomMargin;
               v.translatesAutoresizingMaskIntoConstraints = YES;
               v.center = CGPointMake(self.frame.size.width/2.0,
                                      self.frame.size.height/2.0);
               [self addSubview:v];
               [self setNeedsUpdateConstraints];
            }
         }
      }
   }
}

-(UIView*)embeddedView
{
   return _embeddedView;
}

-(void)didAddSubview:(UIView *)subview
{
   if (self.postData && subview == _embeddedView)
      [subview setPostData:self.postData];
}

-(void)setPostData:(id)postData
{
   [super setPostData:postData];
   [_embeddedView setPostData:postData];
}

@end

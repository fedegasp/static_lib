//
//  MRDiagonalCutView.m
//  MRGraphics
//
//  Created by Federico Gasperini on 31/05/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "MRDiagonalCutView.h"

@interface MRDiagonalCutView ()

@property (weak, nonatomic) CALayer* shapeLayer;

@end

@implementation MRDiagonalCutView

-(void)layoutSubviews
{
   [super layoutSubviews];
   UIColor* fillColor = nil;
   if ([self fillBottom])
   {
      self.backgroundColor = self.upColor ?: [UIColor clearColor];
      fillColor = self.bottomColor;
   }
   else
   {
      self.backgroundColor = self.bottomColor ?: [UIColor clearColor];
      fillColor = self.upColor;
   }
   
   CAShapeLayer *layer = [CAShapeLayer layer];
   
   UIBezierPath *path = [UIBezierPath bezierPath];
   CGRect bounds = self.bounds;
   CGPoint vertex[3];
   
   /*
    fillBottom
      bl -> tr
        0,h -> w,h -> w,0
      tl->br
        0,h -> w,h -> 0,0
    !fillBottom
      bl -> tr
        0,0 -> w,0 -> 0,h
      tl->br
        0,0 -> w,0, -> w,h
    */
   
   if ([self fillBottom])
   {
      vertex[0] = CGPointMake(0, bounds.size.height);
      vertex[1] = CGPointMake(bounds.size.width, bounds.size.height);
      if (self.diagonalDirection == MRDiagonalDirectionBottomLeftTopRight)
         vertex[2] = CGPointMake(bounds.size.width, 0);
      else
         vertex[2] = CGPointZero;
   }
   else
   {
      vertex[0] = CGPointZero;
      vertex[1] = CGPointMake(bounds.size.width, 0);
      if (self.diagonalDirection == MRDiagonalDirectionBottomLeftTopRight)
         vertex[2] = CGPointMake(0, bounds.size.height);
      else
         vertex[2] = CGPointMake(bounds.size.width, bounds.size.height);
   }
   
   [path moveToPoint:vertex[0]];
   [path addLineToPoint:vertex[1]];
   [path addLineToPoint:vertex[2]];
   [path closePath];
   
   layer.path = path.CGPath;
   layer.fillColor = fillColor.CGColor;
   layer.strokeColor = nil;
   
   self.shapeLayer = layer;
}

-(void)setShapeLayer:(CALayer *)shapeLayer
{
   [_shapeLayer removeFromSuperlayer];
   [self.layer addSublayer:shapeLayer];
   _shapeLayer = shapeLayer;
}
        
-(BOOL)fillBottom
{
   CGFloat alpha = .0;
   [self.bottomColor getRed:NULL
                      green:NULL
                       blue:NULL
                      alpha:&alpha];
   if (alpha > .0)
      return YES;
   return NO;
}

@end


@implementation MRDiagonalCutView (ibinspectable)

@dynamic diagonalDirection;

@end

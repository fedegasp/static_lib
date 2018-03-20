
//  Created by fabio on 01/08/15.
//  Copyright (c) 2015 fabio. All rights reserved.
//

#import "MRImageView.h"
#import <MRGraphics/UIImage+overlayColor.h>

@implementation MRImageView


- (void)awakeFromNib{
    [super awakeFromNib];
    [self layoutIfNeeded];
    
    if (self.isCircleImage) {
        [self setAllCornerRadius:self.bounds.size.width/2];
        [self setClipsToBounds:YES];
    }
    
    if(self.borderRadius > 0){
        [self setAllCornerRadius:self.borderRadius];
        [self setClipsToBounds:YES];
    }
    
    if (self.imageIsTemplate)
        [super setImage:[self.image imageWithColor:self.tintColor]];
    
    if(self.borderColor && self.borderWidth)
        [self setBorderWithColor:self.borderColor width:self.borderWidth];
}

-(void)setBorderWithColor:(UIColor*)color width:(CGFloat)width
{
    CALayer* layerView = [self layer];
    [layerView setBorderWidth:width];
    [layerView setBorderColor:[color CGColor]];
}

- (void)setAllCornerRadius:(CGFloat)radius
{
    CALayer* layerView = [self layer];
    layerView.cornerRadius = radius;
}


-(void)setImage:(UIImage *)image
{
    if (self.imageIsTemplate){
        UIImage* i = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [super setImage:[i imageWithColor:self.tintColor]];
    }
    else
    {
        [super setImage:image];
    }
}


-(void)tintColorDidChange
{
    if (self.imageIsTemplate)
        [self setImage:[self.image imageWithColor:self.tintColor]];
}

@end

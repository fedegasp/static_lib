//
//  UIView+Configuration.m
//  MRComponents
//
//  Created by Enrico Cupellini on 12/03/18.
//  Copyright © 2018 Accenture - MAS. All rights reserved.
//

#import "UIView+Configuration.h"
#import "ConfigurationFactory.h"
 #import <objc/runtime.h>

@implementation UIResponder (Configuration)

@dynamic style;

static char _style_;
-(void)setStyle:(NSString *)style
{
    objc_setAssociatedObject(self, &_style_, style, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    DisplayableItem *configurator = [ConfigurationFactory itemWithStyle:style andStatus:[self status]];
    [self setConfiguration:configurator];
}

-(NSString *)style
{
    return objc_getAssociatedObject(self, &_style_);
}

static char _status_;
-(void)setStatus:(NSString *)status
{
    objc_setAssociatedObject(self, &_status_, status, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    DisplayableItem *configurator = [ConfigurationFactory itemWithStyle:[self style] andStatus:status];
    [self setConfiguration:configurator];
}

-(NSString *)status
{
    return objc_getAssociatedObject(self, &_status_);
}

-(void)setConfiguration:(id<DisplayableItem>)configuration
{

}

@end

@implementation UIView (Configuration)

@dynamic style;
@dynamic status;

-(void)setConfiguration:(id<DisplayableItem>)configuration
{
    [super setConfiguration:configuration];
    if (configuration.color1) {
        self.backgroundColor = [configuration color1];
    }
    if (configuration.color2) {
        self.layer.borderColor = [[configuration color2] CGColor];
    }
}

@end

@implementation UILabel (Configuration)

-(void)setConfiguration:(id<DisplayableItem>)configuration
{
    if (configuration.font) {
        self.font = configuration.font;
    }
    if ([configuration color3]) {
        self.textColor = [configuration color3];
    }
//    if (configuration.displayTitle) {
//        self.text = configuration.displayTitle;
//    }
}

@end

@implementation UIImageView (Configuration)

-(void)setConfiguration:(id<DisplayableItem>)configuration
{
    [super setConfiguration:configuration];
    if (configuration.displayImage) {
        self.image = [configuration displayImage];
    }
}

@end

@implementation UIButton (Configuration)

-(void)setConfiguration:(id<DisplayableItem>)configuration
{
    [super setConfiguration:configuration];
    if (configuration.displayImage) {
        [self setImage:[configuration displayImage] forState:UIControlStateNormal];
    }
}

@end

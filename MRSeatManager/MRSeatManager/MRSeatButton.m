//
//  SeatButton.m
//  Seating
//
//  Created by Gai, Fabio on 08/07/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import "MRSeatButton.h"

@interface UIViewController ()

-(void)selectSeat:(id)sender;

@end

@implementation MRSeatButton

-(void)awakeFromNib{
    [super awakeFromNib];
    [self addTarget:self action:@selector(select) forControlEvents:UIControlEventTouchUpInside];
}

-(UIViewController*)viewController
{
    id retval = self.nextResponder;
    while (retval && ![retval isKindOfClass:UIViewController.class])
        retval = [retval nextResponder];
    return retval;
}

-(void)select{

   [self setSelected:!self.selected];
    if ([self.viewController canPerformAction:@selector(selectSeat:) withSender:self] ) {
        [self.viewController performSelector:@selector(selectSeat:) withObject:self];
    }
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        [self setBackgroundColor:[UIColor greenColor]];
    }else{
        [self setBackgroundColor:[UIColor redColor]];
    }
}



@end

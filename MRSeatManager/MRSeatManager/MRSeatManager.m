//
//  SeatManager.m
//  Seating
//
//  Created by Gai, Fabio on 08/07/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import "MRSeatManager.h"
#import "MRSeatButton.h"

@implementation MRSeatManager

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.selectedSeats = [[NSMutableArray alloc] init];
    self.seats = [[NSMutableArray alloc] init];
    
    for (MRSeatButton *btn in self.seatContainer.subviews) {
        if ([btn isKindOfClass:[MRSeatButton class]]) {
            [btn setSeatCode:btn.titleLabel.text];
            [self.seats addObject:btn];
        }
    }
}

-(void)selectSeat:(MRSeatButton *)seat{
    [self.delegate selectSeat:seat.seatCode];
    if (seat.selected) {
        [self.selectedSeats addObject:seat.seatCode];
    }else{
        [self.selectedSeats removeObject:seat.seatCode];
    }
    [self.delegate selectedSeats:self.selectedSeats];
}

@end

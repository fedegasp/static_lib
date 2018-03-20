//
//  SeatManager.h
//  Seating
//
//  Created by Gai, Fabio on 08/07/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MRSeatManagerDelegate <NSObject>
-(void)selectSeat:(NSString *)seat;
-(void)selectedSeats:(NSArray *)seats;
@end


@interface MRSeatManager : UIViewController
@property NSMutableArray *seats;
@property NSMutableArray *selectedSeats;
@property IBOutlet UIView *seatContainer;
@property id<MRSeatManagerDelegate> delegate;
@end

//
//  MRCollectionViewAutorepeater.h
//  Card
//
//  Created by Gai, Fabio on 11/02/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import "MRCollectionViewCarousel.h"

@interface MRCollectionViewAutorepeater : MRCollectionViewCarousel

@property(nonatomic) IBInspectable BOOL autorepeat;
@property IBInspectable CGFloat autorepeatTiming;

@property NSTimer *Timer;
-(void)setTimer;
- (void) resetTimer;
-(void)timerInvalidate;
//@property CGFloat registeredTime;

-(void)updateCarousel:(NSTimer *)theTimer;
@end

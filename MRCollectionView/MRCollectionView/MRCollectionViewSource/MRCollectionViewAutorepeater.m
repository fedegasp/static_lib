//
//  MRCollectionViewAutorepeater.m
//  Card
//
//  Created by Gai, Fabio on 11/02/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import "MRCollectionViewAutorepeater.h"

@implementation MRCollectionViewAutorepeater

-(void)initCollectionView{
    [super initCollectionView];
    [self setTimer];
}

-(void)setAutorepeat:(BOOL)autorepeat {
    
    if (self.autorepeat == autorepeat) {
        return;
    }
    
    self->_autorepeat = autorepeat;
    [self resetTimer];
}

-(void)setAutoRepeater:(BOOL)boolean withTimer:(CGFloat)time{
    
    if (boolean) {
        //self.registeredTime = time;
        self.Timer =[NSTimer scheduledTimerWithTimeInterval:time
                                                     target:self
                                                   selector:@selector(updateCarousel:)
                                                   userInfo:nil
                                                    repeats:YES];
        
    }
}

-(void)updateCarousel:(NSTimer *)theTimer {
    
    self.currentPage = [self nextPage];
    [self scrollToPage:@(self.currentPage) animated:YES];
    [self updatePageControl];
    [self notifyUpdatedPage];
}

-(void)setTimer{
    
    if (!self.Timer) {
        //timer
        if (self.autorepeat) {
            [self setAutoRepeater:self.autorepeat withTimer:self.autorepeatTiming];
        }else{
            [self setAutoRepeater:NO withTimer:0.0];
        }
    }
}

-(void)timerInvalidate{
    
    if(self.Timer) {
        [self.Timer invalidate];
        self.Timer = nil;
    }
}
- (void) resetTimer
{
    [self timerInvalidate];
    [self setTimer];
}

#pragma mark carousel invalidate
-(void)carouselInvalidate{
    [self timerInvalidate];
}

@end

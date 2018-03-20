//
//  VideoContainer.m
//  MASClient
//
//  Created by Gai, Fabio on 16/06/2017.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "VideoContainer.h"

@implementation VideoContainer

-(void)startLoadingVideoWithUrl:(NSString *)url {
    
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&sessionError];
    [[AVAudioSession sharedInstance] setActive:YES error:&sessionError];
    
    //Set up player
    NSURL *movieURL = [NSURL URLWithString:url];
    
    AVAsset *avAsset = [AVAsset assetWithURL:movieURL];
    AVPlayerItem *avPlayerItem =[[AVPlayerItem alloc]initWithAsset:avAsset];
    self.avplayer = [[AVPlayer alloc]initWithPlayerItem:avPlayerItem];
    AVPlayerLayer *avPlayerLayer =[AVPlayerLayer playerLayerWithPlayer:self.avplayer];
    [avPlayerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [avPlayerLayer setFrame:[[UIScreen mainScreen] bounds]];
    [avPlayerLayer setMasksToBounds:NO];
    [self.layer addSublayer:avPlayerLayer];
    
    //Config player
    [self.avplayer seekToTime:kCMTimeZero];
    [self.avplayer setVolume:0.0f];
    [self.avplayer setActionAtItemEnd:AVPlayerActionAtItemEndNone];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.avplayer currentItem]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerStartPlaying)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [self.avplayer addObserver:self forKeyPath:@"status" options:0 context:nil];

    
    [self.avplayer play];

}

-(void)didMoveToSuperview
{
    if (self.superview == nil)
    {
        [self.avplayer pause];
        self.avplayer = nil;
    }
}

-(void)dealloc
{
    [self disablePlayer];
}

-(void)disablePlayer
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [self.avplayer removeObserver:self forKeyPath:@"status"];
    
    [self.avplayer pause];
    self.avplayer = nil;
}

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

- (void)playerStartPlaying
{
    [self.avplayer play];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if (object == self.avplayer && [keyPath isEqualToString:@"status"]) {
        if (self.avplayer.status == AVPlayerStatusReadyToPlay) {
            
            if ([self.delegate respondsToSelector:@selector(didStartPlaying)]) {
            
                [self.delegate didStartPlaying];
                
            }
            
        } else if (self.avplayer.status == AVPlayerStatusFailed) {
            
            [self disablePlayer];
        }
        
        else if (self.avplayer.status == AVPlayerTimeControlStatusPaused) {
            
            [self disablePlayer];
            
        }
    }
}

@end

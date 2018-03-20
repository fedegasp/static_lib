//
//  VideoContainer.h
//  MASClient
//
//  Created by Gai, Fabio on 16/06/2017.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol VideoContainerDelegate <NSObject>

-(void)didStartPlaying;

@end

@interface VideoContainer : UIView
@property (nonatomic, strong) AVPlayer *avplayer;
@property (nonatomic,strong) NSString *videoName;
@property (nonatomic, weak) id<VideoContainerDelegate> delegate;
-(void)startLoadingVideoWithUrl:(NSString *)url;
-(void)disablePlayer;
@end

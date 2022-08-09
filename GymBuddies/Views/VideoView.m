//
//  VideoView.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 8/1/22.
//

#import "VideoView.h"

@interface VideoView ()
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) AVPlayerLooper *player;
@property (strong, nonatomic) AVQueuePlayer *queuePlayer;
@property (weak, nonatomic) IBOutlet UIImageView *pauseView;
@property (weak, nonatomic) IBOutlet UILabel *alternateText;
@end

@implementation VideoView

- (void)layoutSublayersOfLayer:(CALayer *)layer{
    [super layoutSublayersOfLayer:layer];
    self.playerLayer.frame = self.bounds;
}


- (void)setUpVideo:(NSURL *)videoURL{
    @try {
        // Loading video on loop
        self.queuePlayer = [AVQueuePlayer new];
        AVAsset *asset = [AVAsset assetWithURL:videoURL];
        AVPlayerItem *item = [AVPlayerItem playerItemWithAsset: asset];
        self.player = [AVPlayerLooper playerLooperWithPlayer:self.queuePlayer templateItem:item];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.queuePlayer];
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
         
        [self.layer addSublayer: self.playerLayer];
    } @catch (NSException *exception) {
        self.alternateText.text = @"There was an error loading the video";
        self.alternateText.hidden = NO;
    }
}


- (void)setAlternateView{
    self.alternateText.hidden = NO;
}


- (void)setPauseGesture{
    // Adding tap gesture to pause and resume the video
    UITapGestureRecognizer *tapToPause = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pause)];
    [self addGestureRecognizer:tapToPause];
}


- (void)play{
    [self.queuePlayer play];
}


- (void)pause{
    if (self.queuePlayer.rate != 0 && self.queuePlayer.error == nil){
        [self.queuePlayer pause];
        self.pauseView.hidden = NO;
        [self bringSubviewToFront:self.pauseView];
    } else {
        [self play];
        self.pauseView.hidden = YES;
    }
}

@end

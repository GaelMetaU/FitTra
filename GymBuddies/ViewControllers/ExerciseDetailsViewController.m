//
//  ExerciseDetailsViewController.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/26/22.
//

#import "ExerciseDetailsViewController.h"
#import "Parse/PFImageView.h"
#import "AVFoundation/AVFoundation.h"
#import "AVKit/AVKit.h"

static NSString * const kProfilePictureKey = @"profilePicture";

@interface ExerciseDetailsViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *exerciseImage;
@property (weak, nonatomic) IBOutlet PFImageView *authorProfilePicture;
@property (weak, nonatomic) IBOutlet UILabel *exerciseTitle;
@property (weak, nonatomic) IBOutlet UILabel *authorUsername;
@property (weak, nonatomic) IBOutlet PFImageView *bodyZoneIcon;
@property (weak, nonatomic) IBOutlet UILabel *bodyZoneTitle;
@property (strong, nonatomic) AVPlayerLooper *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@end

@implementation ExerciseDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setExercise:self.exercise];
    [self playVideo];
}


-(void)setExercise:(Exercise *)exercise{
    _exercise = exercise;
    
    self.exerciseImage.file = self.exercise.image;
    [self.exerciseImage loadInBackground];
    
    if(self.exercise.author[kProfilePictureKey]){
        self.authorProfilePicture.file = self.exercise.author[kProfilePictureKey];
        self.authorProfilePicture.layer.cornerRadius = self.authorProfilePicture.frame.size.width/2;
        [self.authorProfilePicture loadInBackground];
    }
    
    self.bodyZoneIcon.file = self.exercise.bodyZoneTag.icon;
    [self.bodyZoneIcon loadInBackground];
    
    self.exerciseTitle.text = self.exercise.title;
    self.authorUsername.text = self.exercise.author.username;
    self.bodyZoneTitle.text = self.exercise.bodyZoneTag.title;
    
}


#pragma mark - Video play

-(void)playVideo{
    if(self.exercise.video != nil){
        AVQueuePlayer *queuePlayer = [[AVQueuePlayer alloc]init];
        
        NSURL *url = [NSURL URLWithString:self.exercise.video.url];
        AVAsset *asset = [AVAsset assetWithURL:url];
        AVPlayerItem *item = [AVPlayerItem playerItemWithAsset: asset];
        self.player = [AVPlayerLooper playerLooperWithPlayer:queuePlayer templateItem:item];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:queuePlayer];
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [self.videoView.layer addSublayer: self.playerLayer];
        [queuePlayer play];
    }
}


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.playerLayer.frame = self.videoView.frame;
    self.videoView.layer.masksToBounds = YES;
}




@end

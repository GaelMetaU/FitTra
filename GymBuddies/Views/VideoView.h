//
//  VideoView.h
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 8/1/22.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVFoundation.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoView : UIView
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) AVPlayerLooper *player;
@property (strong, nonatomic) AVQueuePlayer *queuePlayer;
@property (weak, nonatomic) IBOutlet UIImageView *pauseView;

-(void)setUpVideo:(NSURL *)videoURL;
@end

NS_ASSUME_NONNULL_END

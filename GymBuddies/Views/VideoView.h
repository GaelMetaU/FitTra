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

/**
 * Initiates the player with the video URL
 */
- (void)setUpVideo:(NSURL *)videoURL;

/**
 * Initiates the alternate view when there is no video
 */
- (void)setAlternateView;

/**
 * Starts playing the video
 */
- (void)play;

/**
 * Adds a tap to pause gesture
 */
- (void)setPauseGesture;
@end

NS_ASSUME_NONNULL_END

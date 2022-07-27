//
//  ExerciseDetailsViewController.h
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/26/22.
//

#import <UIKit/UIKit.h>
#import "Exercise.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExerciseDetailsViewController : UIViewController
@property (strong, nonatomic) Exercise *exercise;
@end

NS_ASSUME_NONNULL_END

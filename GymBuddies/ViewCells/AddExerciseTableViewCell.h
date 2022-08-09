//
//  AddExerciseTableViewCell.h
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/14/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"
#import "Exercise.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddExerciseTableViewCell : UITableViewCell

/**
 * Exercise that gives the cell content
 */
@property (strong, nonatomic) Exercise *exercise;

/**
 * Setting the cell conte with an exercise
 */
- (void)setExercise:(Exercise *)exercise;
@end

NS_ASSUME_NONNULL_END

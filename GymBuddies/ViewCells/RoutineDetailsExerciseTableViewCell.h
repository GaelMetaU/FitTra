//
//  RoutineDetailsExerciseTableViewCell.h
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/26/22.
//

#import <UIKit/UIKit.h>
#import "ExerciseInRoutine.h"
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RoutineDetailsExerciseTableViewCell : UITableViewCell

/**
 * ExerciseInRoutine that gives content to the cell
 */
@property (strong, nonatomic) ExerciseInRoutine *exerciseInRoutine;

/**
 * Setting cell content with an ExerciseInRoutine
 */
- (void)setCellContent:(ExerciseInRoutine *)exerciseInRoutine;
@end

NS_ASSUME_NONNULL_END

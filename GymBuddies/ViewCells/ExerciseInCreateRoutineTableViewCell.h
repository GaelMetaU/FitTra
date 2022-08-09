//
//  ExerciseInCreateRoutineTableViewCell.h
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/18/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"
#import "ExerciseInRoutine.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExerciseInCreateRoutineTableViewCell : UITableViewCell

/**
 * Exercise that gives all properties to the cell
 */
@property (strong, nonatomic) ExerciseInRoutine *exerciseInRoutine;

 /**
  * Setting the cell's content with an ExerciseInRoutine
  */
- (void) setCellContent:(ExerciseInRoutine *)exerciseInRoutine;
@end

NS_ASSUME_NONNULL_END

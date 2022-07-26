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
@property (strong, nonatomic) ExerciseInRoutine *exerciseInRoutine;
@property (weak, nonatomic) IBOutlet PFImageView *exerciseImage;
@property (weak, nonatomic) IBOutlet PFImageView *bodyZoneIcon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfSetsLabel;
-(void)setCellContent:(ExerciseInRoutine *)exerciseInRoutine;
@end

NS_ASSUME_NONNULL_END

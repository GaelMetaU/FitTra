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
@property (weak, nonatomic) IBOutlet PFImageView *exerciseImage;
@property (weak, nonatomic) IBOutlet PFImageView *bodyZoneIcon;
@property (weak, nonatomic) IBOutlet UILabel *exerciseTitle;
@property (weak, nonatomic) IBOutlet UITextField *numberOfRepsOrTimeField;
@property (weak, nonatomic) IBOutlet UITextField *numberOfSetsField;
@property (weak, nonatomic) IBOutlet UIButton *amountUnitDropdownMenu;
@property (strong, nonatomic) ExerciseInRoutine *exerciseInRoutine;
- (void) setCellContent:(ExerciseInRoutine *)exerciseInRoutine;
@end

NS_ASSUME_NONNULL_END

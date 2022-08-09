//
//  RoutineDetailsExerciseTableViewCell.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/26/22.
//

#import "RoutineDetailsExerciseTableViewCell.h"
#import "SegmentedControlBlocksValues.h"

@interface RoutineDetailsExerciseTableViewCell ()
@property (weak, nonatomic) IBOutlet PFImageView *exerciseImage;
@property (weak, nonatomic) IBOutlet PFImageView *bodyZoneIcon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfSetsLabel;
@end

@implementation RoutineDetailsExerciseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (void)setCellContent:(ExerciseInRoutine *)exerciseInRoutine{
    _exerciseInRoutine = exerciseInRoutine;
    
    self.exerciseImage.file = self.exerciseInRoutine.baseExercise.image;
    [self.exerciseImage loadInBackground];
    self.bodyZoneIcon.file = self.exerciseInRoutine.baseExercise.bodyZoneTag.icon;
    [self.bodyZoneIcon loadInBackground];
    
    self.titleLabel.text = self.exerciseInRoutine.baseExercise.title;
    self.numberOfSetsLabel.text = [NSString stringWithFormat:@"%@ sets", self.exerciseInRoutine.numberOfSets];
    
    NSString *exerciseAmountUnit = [SegmentedControlBlocksValues convertRepsMinsOrSecs:self.exerciseInRoutine.amountUnit];
    self.amountLabel.text = [NSString stringWithFormat:@"%@ %@", self.exerciseInRoutine.amount, exerciseAmountUnit];
}


@end

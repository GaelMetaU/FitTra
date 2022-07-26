//
//  RoutineDetailsExerciseTableViewCell.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/26/22.
//

#import "RoutineDetailsExerciseTableViewCell.h"
#import "SegmentedControlBlocksValues.h"

static NSString * const kRepetitionsLabelValue = @"reps";
static NSString * const kMinutesLabelValue = @"min";
static NSString * const kSecondsLabelValue = @"sec";

@implementation RoutineDetailsExerciseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


-(void)setCellContent:(ExerciseInRoutine *)exerciseInRoutine{
    _exerciseInRoutine = exerciseInRoutine;
    
    self.exerciseImage.file = self.exerciseInRoutine.baseExercise.image;
    [self.exerciseImage loadInBackground];
    self.bodyZoneIcon.file = self.exerciseInRoutine.baseExercise.bodyZoneTag.icon;
    [self.bodyZoneIcon loadInBackground];
    
    self.titleLabel.text = self.exerciseInRoutine.baseExercise.title;
    self.numberOfSetsLabel.text = [NSString stringWithFormat:@"%@ sets", self.exerciseInRoutine.numberOfSets];
    
    NSString *exerciseAmountUnit = [self convertRepsMinsOrSecs];
    self.amountLabel.text = [NSString stringWithFormat:@"%@ %@", self.exerciseInRoutine.amount, exerciseAmountUnit];
}


-(NSString *)convertRepsMinsOrSecs{
    ExerciseAmountUnits exerciseAmountUnits = [self.exerciseInRoutine.amountUnit longValue];
    switch (exerciseAmountUnits){
        case ExerciseAmountUnitReps:
            return kRepetitionsLabelValue;
        case ExerciseAmountUnitMinutes:
            return kMinutesLabelValue;
        case ExerciseAmountUnitSeconds:
            return kSecondsLabelValue;
    }
}


@end

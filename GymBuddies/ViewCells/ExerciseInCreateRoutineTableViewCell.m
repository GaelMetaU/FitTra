//
//  ExerciseInCreateRoutineTableViewCell.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/18/22.
//

#import "ExerciseInCreateRoutineTableViewCell.h"
#import "SegmentedControlBlocksValues.h"

@implementation ExerciseInCreateRoutineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void) setCellContent:(ExerciseInRoutine *)exerciseInRoutine{
    _exerciseInRoutine = exerciseInRoutine;
    
    self.exerciseImage.file = self.exerciseInRoutine.baseExercise.image;
    [self.exerciseImage loadInBackground];
    self.bodyZoneIcon.file = self.exerciseInRoutine.baseExercise.bodyZoneTag.icon;
    [self.bodyZoneIcon loadInBackground];
    self.exerciseTitle.text = self.exerciseInRoutine.baseExercise.title;
    
    [self setDropdownMenu];
}

// Creates the menu and actions to be displayed when pressing the reps button
-(void)setDropdownMenu{
    UIAction *reps = [UIAction actionWithTitle:@"repetitions" image:nil identifier:nil handler:^(UIAction *action){
        self.exerciseInRoutine.amountUnit = [NSNumber numberWithLong:ExerciseAmountUnitReps];
        [self.amountUnitDropdownMenu setTitle:@"reps" forState:UIControlStateNormal];
    }];
    
    UIAction *sec = [UIAction actionWithTitle:@"seconds" image:nil identifier:nil handler:^(UIAction *action){
        self.exerciseInRoutine.amountUnit = [NSNumber numberWithLong:ExerciseAmountUnitSeconds];
        [self.amountUnitDropdownMenu setTitle:@"sec" forState:UIControlStateNormal];
    }];
    
    UIAction *min = [UIAction actionWithTitle:@"minutes" image:nil identifier:nil handler:^(UIAction *action){
        self.exerciseInRoutine.amountUnit = [NSNumber numberWithLong:ExerciseAmountUnitMinutes];
        [self.amountUnitDropdownMenu setTitle:@"min" forState:UIControlStateNormal];
    }];
    
    UIMenu *menu = [[UIMenu alloc]menuByReplacingChildren:[NSArray arrayWithObjects:reps, sec, min, nil]];
    self.amountUnitDropdownMenu.menu = menu;
    self.amountUnitDropdownMenu.showsMenuAsPrimaryAction = YES;
}

// Handles changes on the exercise cell text fields
- (IBAction)updateFieldsValues:(id)sender {
    self.exerciseInRoutine.numberOfSets = @([self.numberOfSetsField.text integerValue]);
    self.exerciseInRoutine.amount = @([self.numberOfRepsOrTimeField.text integerValue]);
}


@end

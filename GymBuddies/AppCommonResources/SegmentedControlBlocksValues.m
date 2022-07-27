//
//  SegmentedControlBlocksValues.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/26/22.
//

#import "SegmentedControlBlocksValues.h"

@implementation SegmentedControlBlocksValues

+(NSString *)setWorkoutPlaceLabelContent:(NSNumber *)workoutPlaceTag{
    
    WorkoutPlace workoutPlace = [workoutPlaceTag longValue];

    switch (workoutPlace) {
        case WorkoutPlaceGym:
            return kWorkoutPlaceGym;
        case WorkoutPlacePark:
            return kWorkoutPlacePark;
        case WorkoutPlaceHome:
            return kWorkoutPlaceHome;
        default:
            break;
    }
}


+(NSString *)setTrainingLevelLabelText:(NSNumber *)trainingLevelTag{
    
    TrainingLevels trainingLevel = [trainingLevelTag longValue];
    switch (trainingLevel) {
        case TrainingLevelExpert:
            return kTrainingLevelExpert;
        case TrainingLevelIntermediate:
            return kTrainingLevelMedium;
            break;
        case TrainingLevelBeginner:
            return kTrainingLevelBeginner;
            break;
        default:
            break;
    }
}


+(UIColor *)setTrainingLevelLabelColor:(NSNumber *)trainingLevelTag{
    
    TrainingLevels trainingLevel = [trainingLevelTag longValue];
    switch (trainingLevel) {
        case TrainingLevelExpert:
            return [UIColor systemRedColor];
        case TrainingLevelIntermediate:
            return [UIColor systemYellowColor];
        case TrainingLevelBeginner:
            return [UIColor systemGreenColor];
        default:
            break;
    }
}


+(NSString *)convertRepsMinsOrSecs:(NSNumber *)exerciseAmountUnitTag{
    ExerciseAmountUnits exerciseAmountUnits = [exerciseAmountUnitTag longValue];
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

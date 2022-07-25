//
//  SegmentedControlBlocksValues.h
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/11/22.
//

#ifndef SegmentedControlBlocksValues_h
#define SegmentedControlBlocksValues_h

typedef NS_ENUM(NSInteger, TrainingLevels){
    TrainingLevelBeginner,
    TrainingLevelIntermediate,
    TrainingLevelExpert
};

typedef NS_ENUM(NSInteger, WorkoutPlace){
    WorkoutPlaceHome,
    WorkoutPlacePark,
    WorkoutPlaceGym
};

typedef NS_ENUM(NSInteger, ExerciseAmountUnits){
    ExerciseAmountUnitSeconds,
    ExerciseAmountUnitMinutes,
    ExerciseAmountUnitReps
};

#endif /* SegmentedControlBlocksValues_h */

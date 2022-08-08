//
//  SegmentedControlBlocksValues.h
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/26/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

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

static NSString * const kTrainingLevelExpert = @"Expert";
static NSString * const kTrainingLevelMedium = @"Medium";
static NSString * const kTrainingLevelBeginner = @"Beginner";

static NSString * const kWorkoutPlaceHome = @"Home";
static NSString * const kWorkoutPlacePark = @"Park";
static NSString * const kWorkoutPlaceGym = @"Gym";

static NSString * const kRepetitionsLabelValue = @"reps";
static NSString * const kMinutesLabelValue = @"min";
static NSString * const kSecondsLabelValue = @"sec";

@interface SegmentedControlBlocksValues : NSObject
+ (NSString *)setWorkoutPlaceLabelContent:(NSNumber *)workoutPlaceTag;
+ (NSString *)setTrainingLevelLabelText:(NSNumber *)trainingLevelTag;
+ (UIColor *)setTrainingLevelLabelColor:(NSNumber *)trainingLevelTag;
+ (NSString *)convertRepsMinsOrSecs:(NSNumber *)exerciseAmountUnitTag;
@end

NS_ASSUME_NONNULL_END

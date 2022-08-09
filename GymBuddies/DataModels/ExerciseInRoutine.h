//
//  ExerciseInRoutine.h
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/18/22.
//

#import <Parse/Parse.h>
#import "Exercise.h"
#import "Routine.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExerciseInRoutine : PFObject<PFSubclassing>

/**
 * The amount of reps, minutes or seconds of the exercise
 */
@property (nonatomic, strong) NSNumber *amount;

/**
 * The exercise amoun unit (handled as ExerciseAmountUnits enum type)
 */
@property (nonatomic, strong) NSNumber *amountUnit;

/**
 * The exercise number of sets
 */
@property (nonatomic, strong) NSNumber *numberOfSets;

/**
 * The base exercise referenced (used to get the image, video, title and author)
 */
@property (nonatomic, strong) Exercise *baseExercise;

/**
 * Initiator with a base exercise object
 */
+ (ExerciseInRoutine *) initWithExercise:(Exercise *)exercise;

/**
 * Full attributes initiator
 */
+ (ExerciseInRoutine *) initWithAttributes:(Exercise *)exercise
                                   amount:(NSNumber *)amount
                               amountUnit:(NSNumber *)amountUnit
                             numberOfSets:(NSNumber *)numberOfSets;
@end

NS_ASSUME_NONNULL_END

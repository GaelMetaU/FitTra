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
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSNumber *amountUnit;
@property (nonatomic, strong) NSNumber *numberOfSets;
@property (nonatomic, strong) Exercise *baseExercise;
+(ExerciseInRoutine *) initWithExercise:(Exercise *)exercise;
+(ExerciseInRoutine *) initWithAttributes:(Exercise *)exercise
                                   amount:(NSNumber *)amount
                               amountUnit:(NSNumber *)amountUnit
                             numberOfSets:(NSNumber *)numberOfSets;
@end

NS_ASSUME_NONNULL_END

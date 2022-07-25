//
//  ExerciseInRoutine.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/18/22.
//

#import "ExerciseInRoutine.h"
#import "SegmentedControlBlocksValues.h"

@implementation ExerciseInRoutine
@dynamic amount;
@dynamic amountUnit;
@dynamic numberOfSets;
@dynamic baseExercise;

+ (nonnull NSString *)parseClassName {
    return @"ExerciseInRoutine";
}

+(ExerciseInRoutine *) initWithExercise:(Exercise *)exercise{
    ExerciseInRoutine *exerciseInRoutine = [ExerciseInRoutine new];
    exerciseInRoutine.baseExercise = exercise;
    exerciseInRoutine.amount = @10;
    exerciseInRoutine.amountUnit = [NSNumber numberWithLong:ExerciseAmountUnitReps];
    exerciseInRoutine.numberOfSets = @4;
    
    return exerciseInRoutine;
}


+(ExerciseInRoutine *) initWithAttributes:(Exercise *)exercise
                                   amount:(NSNumber *)amount
                               amountUnit:(NSNumber *)amountUnit
                             numberOfSets:(NSNumber *)numberOfSets{
    ExerciseInRoutine *exerciseInRoutine = [ExerciseInRoutine new];
    exerciseInRoutine.baseExercise = exercise;
    exerciseInRoutine.amount = amount;
    exerciseInRoutine.amountUnit = amountUnit;
    exerciseInRoutine.numberOfSets = numberOfSets;
    
    return exerciseInRoutine;
}


@end

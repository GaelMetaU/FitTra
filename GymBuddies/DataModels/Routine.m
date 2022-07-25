//
//  Routine.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/19/22.
//

#import "Routine.h"

@implementation Routine
@dynamic workoutPlace;
@dynamic trainingLevel;
@dynamic saveCount;
@dynamic author;
@dynamic caption;
@dynamic exerciseList;
@dynamic bodyZoneList;

+ (nonnull NSString *)parseClassName {
    return @"Routine";
}


+(Routine *)initWithAttributes:(PFUser *)author
                  exerciseList:(NSMutableArray *)exerciseList
                  bodyZoneList:(NSMutableArray *)bodyZoneList
                       caption:(NSString *)caption
                 trainingLevel:(NSNumber *)trainingLevel
                  workoutPlace:(NSNumber *)workoutPlace{
    Routine *routine = [Routine new];
    routine.author = author;
    routine.exerciseList = exerciseList;
    routine.bodyZoneList = bodyZoneList;
    routine.caption = caption;
    routine.trainingLevel = trainingLevel;
    routine.workoutPlace = workoutPlace;
    routine.saveCount = @0;
    
    return routine;
}


@end

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
@dynamic author;
@dynamic standardizedAuthorUsername;
@dynamic image;
@dynamic caption;
@dynamic standardizedCaption;
@dynamic exerciseList;
@dynamic bodyZoneList;
@dynamic likeCount;
@dynamic interactionScore;
@dynamic parkUsersInteractionScore;
@dynamic gymUsersInteractionScore;
@dynamic homeUsersInteractionScore;
@dynamic beginnerUsersInteractionScore;
@dynamic mediumUsersInteractionScore;
@dynamic expertUsersInteractionScore;
+ (nonnull NSString *)parseClassName {
    return @"Routine";
}


+ (Routine *)initWithAttributes:(PFUser *)author
                  exerciseList:(NSMutableArray *)exerciseList
                  bodyZoneList:(NSMutableArray *)bodyZoneList
                         image:(PFFileObject *)image
                       caption:(NSString *)caption
                 trainingLevel:(NSNumber *)trainingLevel
                  workoutPlace:(NSNumber *)workoutPlace{
    Routine *routine = [Routine new];
    routine.author = author;
    routine.standardizedAuthorUsername = [CommonValidations standardizeSearchTerm:routine.author.username];
    routine.exerciseList = exerciseList;
    routine.bodyZoneList = bodyZoneList;
    routine.image = image;
    routine.caption = caption;
    routine.standardizedCaption = [CommonValidations standardizeSearchTerm:routine.caption];
    routine.trainingLevel = trainingLevel;
    routine.workoutPlace = workoutPlace;
    
    return routine;
}


@end

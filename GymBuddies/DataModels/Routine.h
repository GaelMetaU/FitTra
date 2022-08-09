//
//  Routine.h
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/19/22.
//

#import <Parse/Parse.h>
#import "CommonValidations.h"

NS_ASSUME_NONNULL_BEGIN

@interface Routine : PFObject<PFSubclassing>
/**
 * The routine workout place (Handled as WorkoutPlace enum type)
 */
@property (nonatomic, strong) NSNumber *workoutPlace;

/**
 * The routine training level (Handled as TrainingLevel enum type)
 */
@property (nonatomic, strong) NSNumber *trainingLevel;

/**
 * The routine author
 */
@property (nonatomic, strong) PFUser *author;

/**
 * The author username standardized. This is used to make search easier, is not meant to be displayed
 */
@property (nonatomic, strong) NSString *standardizedAuthorUsername;

/**
 * The routine image
 */
@property (nonatomic, strong) PFFileObject *image;

/**
 * The routine caption
 */
@property (nonatomic, strong) NSString *caption;

/**
 * The caption standardized. This is used to make search easier, is not meant to be displayed
 */
@property (nonatomic, strong) NSString *standardizedCaption;

/**
 * The routine ExerciseInRoutine array
*/
@property (nonatomic, strong) NSMutableArray *exerciseList;

/**
 * The routine BodyZone array
 */
@property (nonatomic, strong) NSMutableArray *bodyZoneList;

/**
 * The routine like count
 */
@property (nonatomic, strong) NSNumber *likeCount;

/**
 * The body zone title
 */
@property (nonatomic, strong) NSNumber *interactionScore;

/**
 * The body zone title
 */
@property (nonatomic, strong) NSNumber *parkUsersInteractionScore;

/**
 * The body zone title
 */
@property (nonatomic, strong) NSNumber *homeUsersInteractionScore;

/**
 * The body zone title
 */
@property (nonatomic, strong) NSNumber *gymUsersInteractionScore;

/**
 * The body zone title
 */
@property (nonatomic, strong) NSNumber *beginnerUsersInteractionScore;

/**
 * The body zone title
 */
@property (nonatomic, strong) NSNumber *mediumUsersInteractionScore;

/**
 * The body zone title
 */
@property (nonatomic, strong) NSNumber *expertUsersInteractionScore;

/**
 * Initiator with all attributes
 */
+ (Routine *)initWithAttributes:(PFUser *)author
                  exerciseList:(NSMutableArray *)exerciseList
                  bodyZoneList:(NSMutableArray *)bodyZoneList
                         image:(PFFileObject *)image
                       caption:(NSString *)caption
                 trainingLevel:(NSNumber *)trainingLevel
                  workoutPlace:(NSNumber *)workoutPlace;
@end

NS_ASSUME_NONNULL_END

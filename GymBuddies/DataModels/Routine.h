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
@property (nonatomic, strong) NSNumber *workoutPlace;
@property (nonatomic, strong) NSNumber *trainingLevel;
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *standardizedAuthorUsername;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSString *standardizedCaption;
@property (nonatomic, strong) NSMutableArray *exerciseList;
@property (nonatomic, strong) NSMutableArray *bodyZoneList;
@property (nonatomic, strong) NSNumber *likeCount;

+(Routine *)initWithAttributes:(PFUser *)author
                  exerciseList:(NSMutableArray *)exerciseList
                  bodyZoneList:(NSMutableArray *)bodyZoneList
                         image:(PFFileObject *)image
                       caption:(NSString *)caption
                 trainingLevel:(NSNumber *)trainingLevel
                  workoutPlace:(NSNumber *)workoutPlace;
@end

NS_ASSUME_NONNULL_END

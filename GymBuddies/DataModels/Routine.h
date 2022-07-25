//
//  Routine.h
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/19/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Routine : PFObject<PFSubclassing>
@property (nonatomic, strong) NSNumber *workoutPlace;
@property (nonatomic, strong) NSNumber *trainingLevel;
@property (nonatomic, strong) NSNumber *saveCount;
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSMutableArray *exerciseList;
@property (nonatomic, strong) NSMutableArray *bodyZoneList;

+(Routine *)initWithAttributes:(PFUser *)author
                  exerciseList:(NSMutableArray *)exerciseList
                  bodyZoneList:(NSMutableArray *)bodyZoneList
                         title:(NSString *)title
                       caption:(NSString *)caption
                 trainingLevel:(NSNumber *)trainingLevel
                  workoutPlace:(NSNumber *)workoutPlace;
@end

NS_ASSUME_NONNULL_END

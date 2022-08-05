//
//  ParseAPIManager.h
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/7/22.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "Exercise.h"
#import "Routine.h"
#import "ExerciseInRoutine.h"
#import "SegmentedControlBlocksValues.h"


NS_ASSUME_NONNULL_BEGIN

typedef void (^ParseManagerAuthenticationCompletionBlock) (PFUser *user, NSError *error);
typedef void (^ParseManagerCreateCompletionBlock) (BOOL succeeded, NSError *error);
typedef void (^ParseManagerLogOutCompletionBlock) (NSError * _Nullable errorAPI);
typedef void (^ParseManagerFetchingDataRowsCompletionBlock) (NSArray *elements, NSError * _Nullable error);
typedef void (^ParseManagerFindObjectCompletionBlock) (PFObject *object, NSError * _Nullable error);

// Classes keys
static NSString * const kBodyZoneClass = @"BodyZone";
static NSString * const kSavedExerciseClass= @"SavedExercise";
static NSString * const kRoutineClass = @"Routine";
static NSString * const kLikedRoutineClass= @"LikedRoutine";

// Search Attribute Keys
static NSString * const kStandardizedCaptionAttributeKey = @"standardizedCaption";
static NSString * const kStandardizedAuthorUsernameAttributeKey = @"standardizedAuthorUsername";

// Common used attribute keys
static NSString * const kWorkoutPlaceAttributeKey = @"workoutPlace";
static NSString * const kTrainingLevelAttributeKey = @"trainingLevel";
static NSString * const kAuthorAttributeKey = @"author";
static NSString * const kUserAttributeKey = @"user";
static NSString * const kCreatedAtAttributeKey = @"createdAt";
static NSString * const kProfilePictureAttributeKey = @"profilePicture";

// Routine attributes
static NSString * const kRoutineAttributeKey = @"routine";
static NSString * const kRoutineAuthorAttributeKey = @"routine.author";
static NSString * const kBodyZoneListAttributeKey = @"bodyZoneList";
static NSString * const kExerciseListAttributeKey = @"exerciseList";
static NSString * const kExerciseListBaseExerciseAttributeKey = @"exerciseList.baseExercise";
static NSString * const kExerciseListBaseExerciseBodyZoneTagAttributeKey = @"exerciseList.baseExercise.bodyZoneTag";
static NSString * const kExerciseListBaseExerciseAuthorAttributeKey = @"exerciseList.baseExercise.author";
static NSString * const kRoutineBodyZoneListAttributeKey = @"routine.bodyZoneList";
static NSString * const kRoutineExerciseListAttributeKey = @"routine.exerciseList";
static NSString * const kRoutineExerciseListBaseExerciseAttributeKey = @"routine.exerciseList.baseExercise";
static NSString * const kRoutineExerciseListBaseExerciseBodyZoneTagAttributeKey = @"routine.exerciseList.baseExercise.bodyZoneTag";
static NSString * const kRoutineExerciseListBaseExerciseAuthorAttributeKey = @"routine.exerciseList.baseExercise.author";

// Exercise attributes
static NSString * const kExerciseAttributeKey = @"exercise";
static NSString * const kExerciseAuthorAttributeKey = @"exercise.author";
static NSString * const kExerciseBodyZoneTagAttributeKey = @"exercise.bodyZoneTag";
static NSString * const kExerciseImageAttributeKey = @"exercise.image";


@interface ParseAPIManager : NSObject
+ (void)logIn:(NSString *)username
    password:(NSString *)password
  completion:(ParseManagerAuthenticationCompletionBlock) completion;

+ (void)signUp:(PFUser *)user
   completion:(ParseManagerCreateCompletionBlock) completion;

+ (void)logOut:(ParseManagerLogOutCompletionBlock) completion;

+ (void)fetchBodyZones:(ParseManagerFetchingDataRowsCompletionBlock) completion;

+ (void)fetchUsersExercises:(ParseManagerFetchingDataRowsCompletionBlock) completion;

+ (Exercise *)postExercise:(Exercise *)exercise
                  progress:(UIProgressView *)progress
                completion:(ParseManagerCreateCompletionBlock) completion;

+ (void)saveExercise:(Exercise *)exercise
          completion:(ParseManagerCreateCompletionBlock) completion;

+ (void)postRoutine:(Routine *)routine
         completion:(ParseManagerCreateCompletionBlock) completion;

+ (void)fetchHomeTimelineRoutines:(ParseManagerFetchingDataRowsCompletionBlock) completion;

+ (void)fetchUsersCreatedRoutines:(ParseManagerFetchingDataRowsCompletionBlock) completion;

+ (void)fetchUsersLikedRoutines:(ParseManagerFetchingDataRowsCompletionBlock) completion;

+ (void)changeProfilePicture:(PFFileObject *)image
                 completion:(ParseManagerCreateCompletionBlock) completion;

+ (void)searchRoutines:(NSString *)searchTerm
   workoutPlaceFilter:(NSNumber *)workoutPlaceFilter
  trainingLevelFilter:(NSNumber *)trainingLevelFilter
           completion:(ParseManagerFetchingDataRowsCompletionBlock) completion;

+ (void)likeRoutine:(Routine *)routine;

+ (void)unlike:(Routine *)routine;

+ (void)isLiked:(Routine *)routine
    completion:(ParseManagerFindObjectCompletionBlock) completion;

+ (void)changeRoutinesInteractionScore:(Routine *)routine value:(double)value;

+ (PFFileObject *)getPFFileFromURL:(NSURL *)video
                         videoName:(NSString *)videoName;

+ (PFFileObject *)getPFFileFromImage:(UIImage *)image
                           imageName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END

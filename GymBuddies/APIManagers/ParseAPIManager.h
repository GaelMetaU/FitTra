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
#import "DateTools/DateTools.h"


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
static double const kRoutineFetchAmount = 20;
static NSString * const kRoutineAttributeKey = @"routine";
static NSString * const kInteractionScoreAttributeKey = @"interactionScore";
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

/**
 * Passes the received username and  password throguh Parse Server authentication. When completed, it will create
 * a user object at the phone storage and start a session at the app
 */
+ (void)logIn:(NSString *)username
    password:(NSString *)password
  completion:(ParseManagerAuthenticationCompletionBlock) completion;

/**
 * Creates a new user at the Parse Server database
 */
+ (void)signUp:(PFUser *)user
   completion:(ParseManagerCreateCompletionBlock) completion;

/**
 * Deletes the local user object and ends the session, so there is no track of the user
 */
+ (void)logOut:(ParseManagerLogOutCompletionBlock) completion;

/**
 * Gets the body zone icons available at the database
 */
+ (void)fetchBodyZones:(ParseManagerFetchingDataRowsCompletionBlock) completion;

/**
 * Gets the user's saved and created exercises
 */
+ (void)fetchUsersExercises:(ParseManagerFetchingDataRowsCompletionBlock) completion;

/**
 * Creates a new exercise object and in background uploads it to the database
 */
+ (Exercise *)postExercise:(Exercise *)exercise
                  progress:(UIProgressView *)progress
                completion:(ParseManagerCreateCompletionBlock) completion;

/**
 * Creates a SavedExercise relation in background with the exercise passed and the current user
 */
+ (void)saveExercise:(Exercise *)exercise
          completion:(ParseManagerCreateCompletionBlock) completion;

/**
 * Creates a new routine object and uploads in background it to the database
 */
+ (void)postRoutine:(Routine *)routine
         completion:(ParseManagerCreateCompletionBlock) completion;

/**
 * Implements the recommendation system designed to fetch and sort the routines from database based on interactions in background
 */
+ (void)fetchHomeTimelineRoutines:(long)skipValue completion:(ParseManagerFetchingDataRowsCompletionBlock) completion;

/**
 * Uses the current user to fetch in background the routines created by them
 */
+ (void)fetchUsersCreatedRoutines:(ParseManagerFetchingDataRowsCompletionBlock) completion;

/**
 * Uses the current user to fetch in background all LikedRoutine relations that include them
 */
+ (void)fetchUsersLikedRoutines:(ParseManagerFetchingDataRowsCompletionBlock) completion;

/**
 * Edits the current user properties and saves the changes in background
 */
+ (void)changeProfilePicture:(PFFileObject *)image
                 completion:(ParseManagerCreateCompletionBlock) completion;

/**
 * Given the search term and the filter values, fetches in background the most popular routines that match with the description
 */
+ (void)searchRoutines:(NSString *)searchTerm
   workoutPlaceFilter:(NSNumber *)workoutPlaceFilter
  trainingLevelFilter:(NSNumber *)trainingLevelFilter
             skipValue:(double)skipValue
           completion:(ParseManagerFetchingDataRowsCompletionBlock) completion;

/**
 * Creates a LikedExercise relation in background with the exercise passed and the current user
 */
+ (void)likeRoutine:(Routine *)routine;

/**
 * Destroys a LikedRoutine relation in background
 */
+ (void)unlike:(Routine *)routine;

/**
 * Looks for a LikedRoutine relation in background based on the routine passed and the current user
 */
+ (void)isLiked:(Routine *)routine
    completion:(ParseManagerFindObjectCompletionBlock) completion;

/**
 * Updates a routine interaction score in background eventually
 */
+ (void)changeRoutinesInteractionScore:(Routine *)routine value:(double)value;

/**
 * Converts the video received as URL to a standardizzed PFFileObject
 */
+ (PFFileObject *)getPFFileFromURL:(NSURL *)video
                         videoName:(NSString *)videoName;

/**
 * Converts the image received as UIImage to a standardizzed PFFileObject
 */
+ (PFFileObject *)getPFFileFromImage:(UIImage *)image
                           imageName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END

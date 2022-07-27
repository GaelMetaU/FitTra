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

NS_ASSUME_NONNULL_BEGIN

typedef void (^ParseManagerAuthenticationCompletionBlock) (PFUser *user, NSError *error);
typedef void (^ParseManagerCreateCompletionBlock) (BOOL succeeded, NSError *error);
typedef void (^ParseManagerLogOutCompletionBlock) (NSError * _Nullable errorAPI);
typedef void (^ParseManagerFetchingDataRowsCompletionBlock) (NSArray *elements, NSError * _Nullable error);


@interface ParseAPIManager : NSObject
+(void)logIn:(NSString *)username
    password:(NSString *)password
  completion:(ParseManagerAuthenticationCompletionBlock) completion;

+(void)signUp:(PFUser *)user
   completion:(ParseManagerCreateCompletionBlock) completion;

+(void)logOut:(ParseManagerLogOutCompletionBlock) completion;

+(void)fetchBodyZones:(ParseManagerFetchingDataRowsCompletionBlock) completion;

+(void)fetchUsersExercises:(ParseManagerFetchingDataRowsCompletionBlock) completion;

+ (Exercise *)postExercise:(Exercise *)exercise
                  progress:(UIProgressView *)progress
                completion:(ParseManagerCreateCompletionBlock) completion;

+ (void)saveExercise:(Exercise *)exercise completion:(ParseManagerCreateCompletionBlock) completion;

+ (void)postRoutine:(Routine *)routine completion:(ParseManagerCreateCompletionBlock) completion;

+ (void)fetchHomeTimelineRoutines:(ParseManagerFetchingDataRowsCompletionBlock) completion;

+(void)fetchUsersCreatedRoutines:(ParseManagerFetchingDataRowsCompletionBlock) completion;

+(void)fetchUsersLikedRoutines:(ParseManagerFetchingDataRowsCompletionBlock) completion;

+(void)changeProfilePicture:(PFFileObject *)image completion:(ParseManagerCreateCompletionBlock) completion;

+ (PFFileObject *)getPFFileFromURL:(NSURL *)video videoName:(NSString *)videoName;

+ (PFFileObject *)getPFFileFromImage:(UIImage *)image imageName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END

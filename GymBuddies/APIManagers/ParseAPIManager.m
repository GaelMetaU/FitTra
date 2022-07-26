//
//  ParseManager.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/7/22.
//

#import "ParseAPIManager.h"

static NSString * const BODY_ZONE_CLASS = @"BodyZone";
static NSString * const SAVED_EXERCISE_CLASS= @"SavedExercise";
static NSString * const ROUTINE_CLASS = @"Routine";


@implementation ParseAPIManager

+(void)logIn:(NSString *)username
    password:(NSString *)password
  completion:(ParseManagerAuthenticationCompletionBlock)completion {

    ParseManagerAuthenticationCompletionBlock block = ^(PFUser *user, NSError *error) {completion(user,error);};
    
    [PFUser logInWithUsernameInBackground:username password:password block:block];
}


+ (void)signUp:(PFUser *)user
    completion:(ParseManagerCreateCompletionBlock)completion{
    
    ParseManagerCreateCompletionBlock block = ^(BOOL succeeded, NSError *error) {completion(succeeded, error);};
    
    [user signUpInBackgroundWithBlock:block];
}


+(void)logOut:(ParseManagerLogOutCompletionBlock) completion{
    
    ParseManagerLogOutCompletionBlock block = ^void(NSError *errorAPI) {
        if(errorAPI){
            completion(errorAPI);
        }
        else{
            completion(nil);
        }
    };
    
    [PFUser logOutInBackgroundWithBlock:block];
}


+(void)fetchBodyZones:(ParseManagerFetchingDataRowsCompletionBlock) completion{
    PFQuery *query = [PFQuery queryWithClassName:BODY_ZONE_CLASS];
    
    ParseManagerFetchingDataRowsCompletionBlock block = ^void(NSArray *elements, NSError *error){
        completion(elements, error);
    };
    
    [query findObjectsInBackgroundWithBlock:block];
}


+ (Exercise *)postExercise:(Exercise *)exercise
                  progress:(UIProgressView *)progress
                completion:(ParseManagerCreateCompletionBlock) completion {
    
    Exercise *newExercise = [Exercise initWithAttributes:exercise.title author:exercise.author video:exercise.video image:exercise.image bodyZoneTag:exercise.bodyZoneTag];
        
    ParseManagerCreateCompletionBlock checkBlock = ^void(BOOL succeeded, NSError * _Nullable error){
        if(error != nil){
            completion(succeeded, error);
            return;
        }
    };
    
    [newExercise.video saveInBackgroundWithBlock:checkBlock progressBlock:^(int percentDone) {
            [progress setProgress: percentDone / 100];
    }];
    
    ParseManagerCreateCompletionBlock finalBlock = ^void(BOOL succeeded, NSError * _Nullable error){
        if (error!=nil){
            completion(false, error);
        } else {
            completion(true, nil);
        }
    };
    
    [newExercise saveInBackgroundWithBlock:finalBlock];

    [self saveExercise:newExercise completion:checkBlock];

    return newExercise;
}


+ (void)saveExercise:(Exercise *)exercise completion:(ParseManagerCreateCompletionBlock)completion{
    PFObject *savedExercise = [PFObject objectWithClassName:SAVED_EXERCISE_CLASS];
    
    savedExercise[@"author"] = exercise.author;
    savedExercise[@"exercise"] = exercise;
    
    ParseManagerCreateCompletionBlock block = ^void(BOOL succeeded, NSError * _Nullable error){
        completion(succeeded, error);
        if(!succeeded){
            return;
        }
    };
    
    [savedExercise saveInBackgroundWithBlock:block];
}


+ (void)fetchUsersExercises:(ParseManagerFetchingDataRowsCompletionBlock) completion{
    PFQuery *query = [PFQuery queryWithClassName:SAVED_EXERCISE_CLASS];
    [query includeKeys:@[@"exercise", @"exercise.author", @"exercise.bodyZoneTag", @"exercise.image"]];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];

    ParseManagerFetchingDataRowsCompletionBlock block = ^void(NSArray *elements, NSError *error){
        completion(elements, error);
        for(PFObject *exercise in elements){
            NSLog(@"%@", exercise);
        }
    };
    
    [query findObjectsInBackgroundWithBlock:block];
}


+ (void)postRoutine:(Routine *)routine completion:(ParseManagerCreateCompletionBlock) completion{
    Routine *newRoutine = [Routine initWithAttributes:routine.author exerciseList:routine.exerciseList bodyZoneList:routine.bodyZoneList image:routine.image caption:routine.caption trainingLevel:routine.trainingLevel workoutPlace:routine.workoutPlace];
        
    ParseManagerCreateCompletionBlock block = ^void(BOOL succeeded, NSError * _Nullable error){
        completion(succeeded, error);
        if(!succeeded){
            return;
        }
    };
    
    [newRoutine saveInBackgroundWithBlock:block];
}


+ (void)fetchHomeTimelineRoutines:(ParseManagerFetchingDataRowsCompletionBlock) completion{
    PFQuery *query = [PFQuery queryWithClassName:ROUTINE_CLASS];
    [query includeKeys:@[@"bodyZoneList", @"exerciseList", @"author", @"exerciseList.baseExercise", @"exerciseList.baseExercise.bodyZoneTag"]];
    
    ParseManagerFetchingDataRowsCompletionBlock block = ^void(NSArray *elements, NSError *error){
        completion(elements, error);
    };
    
    [query findObjectsInBackgroundWithBlock:block];
}


+ (PFFileObject *)getPFFileFromURL:(NSURL *)video videoName:(NSString *)videoName{
    if(!video){
        return nil;
    }
    NSData *videoData = [NSData dataWithContentsOfURL:video];
    // get image data and check if that is not nil
    if (!videoData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:videoName data:videoData];
}


+ (PFFileObject *)getPFFileFromImage:(UIImage *)image imageName:(NSString *)imageName{
    if(!image){
        return nil;
    }
    NSData *imageData = UIImageJPEGRepresentation(image, 0.75);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:imageName data:imageData];
}

@end

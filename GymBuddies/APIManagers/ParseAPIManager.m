//
//  ParseManager.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/7/22.
//

#import "ParseAPIManager.h"

static NSString * const kBodyZoneClass = @"BodyZone";
static NSString * const kSavedExerciseClass= @"SavedExercise";
static NSString * const kRoutineClass = @"Routine";
static NSString * const kLikedRoutineClass= @"LikedRoutine";


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
    PFQuery *query = [PFQuery queryWithClassName:kBodyZoneClass];
    
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
            completion(true, error);
        }
    };
    
    [newExercise saveInBackgroundWithBlock:finalBlock];

    [self saveExercise:newExercise completion:checkBlock];

    return newExercise;
}


+ (void)saveExercise:(Exercise *)exercise completion:(ParseManagerCreateCompletionBlock)completion{
    PFObject *savedExercise = [PFObject objectWithClassName:kSavedExerciseClass];
    
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
    PFQuery *query = [PFQuery queryWithClassName:kSavedExerciseClass];
    [query includeKeys:@[@"exercise", @"exercise.author", @"exercise.bodyZoneTag", @"exercise.image"]];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];

    ParseManagerFetchingDataRowsCompletionBlock block = ^void(NSArray *elements, NSError *error){
        completion(elements, error);
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
    PFQuery *query = [PFQuery queryWithClassName:kRoutineClass];
    [query includeKeys:@[@"bodyZoneList", @"exerciseList", @"author", @"exerciseList.baseExercise", @"exerciseList.baseExercise.bodyZoneTag", @"exerciseList.baseExercise.author"]];
    
    ParseManagerFetchingDataRowsCompletionBlock block = ^void(NSArray *elements, NSError *error){
        completion(elements, error);
    };
    
    [query findObjectsInBackgroundWithBlock:block];
}


+(void)fetchUsersCreatedRoutines:(ParseManagerFetchingDataRowsCompletionBlock) completion{
    PFQuery *query = [PFQuery queryWithClassName:kRoutineClass];
    [query includeKeys:@[@"bodyZoneList", @"exerciseList", @"author", @"exerciseList.baseExercise", @"exerciseList.baseExercise.bodyZoneTag", @"exerciseList.baseExercise.author"]];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];
    [query orderByDescending:@"createdAt"];
    
    ParseManagerFetchingDataRowsCompletionBlock block = ^void(NSArray *elements, NSError *error){
        completion(elements, error);
    };
    
    [query findObjectsInBackgroundWithBlock:block];
}


+(void)fetchUsersLikedRoutines:(ParseManagerFetchingDataRowsCompletionBlock) completion{
    PFQuery *query = [PFQuery queryWithClassName:kLikedRoutineClass];
    [query includeKeys:@[@"routine",@"routine.bodyZoneList", @"routine.exerciseList", @"routine.author", @"routine.exerciseList.baseExercise", @"routine.exerciseList.baseExercise.bodyZoneTag", @"routine.exerciseList.baseExercise.author"]];
    [query selectKeys:@[@"routine"]];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query orderByDescending:@"createdAt"];
    
    ParseManagerFetchingDataRowsCompletionBlock block = ^void(NSArray *elements, NSError *error){
        completion(elements, error);
    };
    
    [query findObjectsInBackgroundWithBlock:block];
}


+(void)changeProfilePicture:(PFFileObject *)image completion:(ParseManagerCreateCompletionBlock) completion{
    PFUser *user = [PFUser currentUser];
    user[@"profilePicture"] = image;
    
    ParseManagerCreateCompletionBlock block = ^void(BOOL succeeded, NSError * _Nullable error){
        completion(succeeded, error);
        if(!succeeded){
            return;
        }
    };
    
    [user saveInBackgroundWithBlock:block];
}


+(void)searchRoutines:(NSString *)searchTerm
   workoutPlaceFilter:(NSNumber *)workoutPlaceFilter
  trainingLevelFilter:(NSNumber *)trainingLevelFilter
           completion:(ParseManagerFetchingDataRowsCompletionBlock) completion{
    
    NSMutableArray *textSearchQueries = [[NSMutableArray alloc]init];
    
    PFQuery *captionQuery = [PFQuery queryWithClassName:kRoutineClass];
    [captionQuery whereKey:@"standardizedCaption" containsString:searchTerm];
    [textSearchQueries addObject:captionQuery];
    
    PFQuery *authorQuery = [PFQuery queryWithClassName:kRoutineClass];
    [authorQuery whereKey:@"standardizedAuthorUsername" containsString:searchTerm];
    [textSearchQueries addObject:authorQuery];
    
    PFQuery *finalSearchQuery = [PFQuery orQueryWithSubqueries:textSearchQueries];
    
    if(workoutPlaceFilter != nil){
        [finalSearchQuery whereKey:@"workoutPlace" equalTo:workoutPlaceFilter];
    }
        
    if(trainingLevelFilter != nil){
        [finalSearchQuery whereKey:@"trainingLevel" equalTo:trainingLevelFilter];
    }

    [finalSearchQuery includeKeys:@[@"bodyZoneList", @"exerciseList", @"author", @"exerciseList.baseExercise", @"exerciseList.baseExercise.bodyZoneTag", @"exerciseList.baseExercise.author"]];
    
    ParseManagerFetchingDataRowsCompletionBlock block = ^void(NSArray *elements, NSError *error){
        completion(elements, error);
    };
    
    [finalSearchQuery findObjectsInBackgroundWithBlock:block];
}


+ (void)likeRoutine:(Routine *)routine completion:(ParseManagerCreateCompletionBlock) completion{
    PFUser *user = [PFUser currentUser];
    PFObject *likedRoutine = [PFObject objectWithClassName:kLikedRoutineClass];
    likedRoutine[@"routine"] = routine;
    likedRoutine[@"user"] = user;
    
    ParseManagerCreateCompletionBlock block = ^void(BOOL succeeded, NSError * _Nullable error){
        completion(succeeded, error);
        if(!succeeded){
            return;
        }
    };
    
    [likedRoutine saveInBackgroundWithBlock:block];
    [routine saveInBackground];
}


+(void)isLiked:(Routine *)routine completion:(ParseManagerFindObjectCompletionBlock) completion{
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:kLikedRoutineClass];
    [query whereKey:@"user" equalTo:user];
    [query whereKey:@"routine" equalTo:routine];
    
    ParseManagerFindObjectCompletionBlock block = ^void(PFObject *object, NSError * _Nullable error){
        completion(object, error);
    };
    
    [query getFirstObjectInBackgroundWithBlock:block];
    
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

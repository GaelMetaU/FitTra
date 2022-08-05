//
//  ParseManager.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/7/22.
//

#import "ParseAPIManager.h"


static long  const kJPEGCompressionConstant = 0.75;

@implementation ParseAPIManager

+ (void)logIn:(NSString *)username
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


+ (void)logOut:(ParseManagerLogOutCompletionBlock)completion{

    ParseManagerLogOutCompletionBlock block = ^void(NSError *errorAPI) {
        if (errorAPI){
            completion(errorAPI);
        }
        else {
            completion(nil);
        }
    };

    [PFUser logOutInBackgroundWithBlock:block];
}


+ (void)fetchBodyZones:(ParseManagerFetchingDataRowsCompletionBlock) completion{
    PFQuery *query = [PFQuery queryWithClassName:kBodyZoneClass];

    ParseManagerFetchingDataRowsCompletionBlock block = ^void(NSArray *elements, NSError *error){
        completion(elements, error);
    };

    [query findObjectsInBackgroundWithBlock:block];
}


+ (Exercise *)postExercise:(Exercise *)exercise
                  progress:(UIProgressView *)progress
                completion:(ParseManagerCreateCompletionBlock)completion {

    Exercise *newExercise = [Exercise initWithAttributes:exercise.title author:exercise.author video:exercise.video image:exercise.image bodyZoneTag:exercise.bodyZoneTag];

    ParseManagerCreateCompletionBlock checkBlock = ^void(BOOL succeeded, NSError * _Nullable error){
        if (error != nil){
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

    savedExercise[kAuthorAttributeKey] = exercise.author;
    savedExercise[kExerciseAttributeKey] = exercise;

    ParseManagerCreateCompletionBlock block = ^void(BOOL succeeded, NSError * _Nullable error){
        completion(succeeded, error);
        if (!succeeded){
            return;
        }
    };

    [savedExercise saveInBackgroundWithBlock:block];
}


+ (void)fetchUsersExercises:(ParseManagerFetchingDataRowsCompletionBlock) completion{
    PFQuery *query = [PFQuery queryWithClassName:kSavedExerciseClass];
    [query includeKeys:@[kExerciseAttributeKey, kExerciseAuthorAttributeKey, kExerciseBodyZoneTagAttributeKey, kExerciseImageAttributeKey]];
    [query whereKey:kAuthorAttributeKey equalTo:[PFUser currentUser]];

    ParseManagerFetchingDataRowsCompletionBlock block = ^void(NSArray *elements, NSError *error){
        completion(elements, error);
    };

    [query findObjectsInBackgroundWithBlock:block];
}


+ (void)postRoutine:(Routine *)routine completion:(ParseManagerCreateCompletionBlock) completion{
    Routine *newRoutine = [Routine initWithAttributes:routine.author exerciseList:routine.exerciseList bodyZoneList:routine.bodyZoneList image:routine.image caption:routine.caption trainingLevel:routine.trainingLevel workoutPlace:routine.workoutPlace];

    ParseManagerCreateCompletionBlock block = ^void(BOOL succeeded, NSError * _Nullable error){
        completion(succeeded, error);
        if (!succeeded){
            return;
        }
    };

    [newRoutine saveInBackgroundWithBlock:block];
}


+ (void)fetchHomeTimelineRoutines:(ParseManagerFetchingDataRowsCompletionBlock) completion{
    PFQuery *query = [PFQuery queryWithClassName:kRoutineClass];
    [query includeKeys:@[kBodyZoneListAttributeKey, kExerciseListAttributeKey, kAuthorAttributeKey, kExerciseListBaseExerciseAttributeKey, kExerciseListBaseExerciseBodyZoneTagAttributeKey, kExerciseListBaseExerciseAuthorAttributeKey]];

    ParseManagerFetchingDataRowsCompletionBlock block = ^void(NSArray *elements, NSError *error){
        completion(elements, error);
    };

    [query findObjectsInBackgroundWithBlock:block];
}


+ (void)fetchUsersCreatedRoutines:(ParseManagerFetchingDataRowsCompletionBlock) completion{
    PFQuery *query = [PFQuery queryWithClassName:kRoutineClass];
    [query includeKeys:@[kBodyZoneListAttributeKey, kExerciseListAttributeKey, kAuthorAttributeKey, kExerciseListBaseExerciseAttributeKey, kExerciseListBaseExerciseBodyZoneTagAttributeKey, kExerciseListBaseExerciseAuthorAttributeKey]];
    [query whereKey:kAuthorAttributeKey equalTo:[PFUser currentUser]];
    [query orderByDescending:kCreatedAtAttributeKey];

    ParseManagerFetchingDataRowsCompletionBlock block = ^void(NSArray *elements, NSError *error){
        completion(elements, error);
    };

    [query findObjectsInBackgroundWithBlock:block];
}


+ (void)fetchUsersLikedRoutines:(ParseManagerFetchingDataRowsCompletionBlock) completion{
    PFQuery *query = [PFQuery queryWithClassName:kLikedRoutineClass];
    [query includeKeys:@[kRoutineAttributeKey, kRoutineBodyZoneListAttributeKey, kRoutineExerciseListAttributeKey, kRoutineAuthorAttributeKey, kRoutineExerciseListBaseExerciseAttributeKey, kRoutineExerciseListBaseExerciseBodyZoneTagAttributeKey, kRoutineExerciseListBaseExerciseAuthorAttributeKey]];
    [query selectKeys:@[kRoutineAttributeKey]];
    [query whereKey:kUserAttributeKey equalTo:[PFUser currentUser]];
    [query orderByDescending:kCreatedAtAttributeKey];

    ParseManagerFetchingDataRowsCompletionBlock block = ^void(NSArray *elements, NSError *error){
        completion(elements, error);
    };

    [query findObjectsInBackgroundWithBlock:block];
}


+ (void)changeProfilePicture:(PFFileObject *)image completion:(ParseManagerCreateCompletionBlock) completion{
    PFUser *user = [PFUser currentUser];
    user[kProfilePictureAttributeKey] = image;

    ParseManagerCreateCompletionBlock block = ^void(BOOL succeeded, NSError * _Nullable error){
        completion(succeeded, error);
        if (!succeeded){
            return;
        }
    };

    [user saveInBackgroundWithBlock:block];
}


+ (void)searchRoutines:(NSString *)searchTerm
   workoutPlaceFilter:(NSNumber *)workoutPlaceFilter
  trainingLevelFilter:(NSNumber *)trainingLevelFilter
           completion:(ParseManagerFetchingDataRowsCompletionBlock) completion{

    NSMutableArray *textSearchQueries = [[NSMutableArray alloc]init];

    PFQuery *captionQuery = [PFQuery queryWithClassName:kRoutineClass];
    [captionQuery whereKey:kStandardizedCaptionAttributeKey containsString:searchTerm];
    [textSearchQueries addObject:captionQuery];

    PFQuery *authorQuery = [PFQuery queryWithClassName:kRoutineClass];
    [authorQuery whereKey:kStandardizedAuthorUsernameAttributeKey containsString:searchTerm];
    [textSearchQueries addObject:authorQuery];

    PFQuery *finalSearchQuery = [PFQuery orQueryWithSubqueries:textSearchQueries];

    if (workoutPlaceFilter != nil){
        [finalSearchQuery whereKey:kWorkoutPlaceAttributeKey equalTo:workoutPlaceFilter];
    }

    if (trainingLevelFilter != nil){
        [finalSearchQuery whereKey:kTrainingLevelAttributeKey equalTo:trainingLevelFilter];
    }

    [finalSearchQuery includeKeys:@[kBodyZoneListAttributeKey, kExerciseListAttributeKey, kAuthorAttributeKey, kExerciseListBaseExerciseAttributeKey, kExerciseListBaseExerciseBodyZoneTagAttributeKey, kExerciseListBaseExerciseAuthorAttributeKey]];
    [finalSearchQuery orderByDescending:@"interactionScore"];

    ParseManagerFetchingDataRowsCompletionBlock block = ^void(NSArray *elements, NSError *error){
        completion(elements, error);
    };

    [finalSearchQuery findObjectsInBackgroundWithBlock:block];
}


+ (void)likeRoutine:(Routine *)routine{
    PFUser *user = [PFUser currentUser];
    PFObject *likedRoutine = [PFObject objectWithClassName:kLikedRoutineClass];
    likedRoutine[kRoutineAttributeKey] = routine;
    likedRoutine[kUserAttributeKey] = user;

    [likedRoutine saveEventually];
    [self changeRoutinesInteractionScore:routine value:3];
    //[routine saveInBackground];
}

+ (void)unlike:(Routine *)routine{
    [self isLiked:routine completion:^(PFObject * _Nonnull object, NSError * _Nullable error) {
        if (object != nil){
            [object deleteEventually];
        }
    }];
    [self changeRoutinesInteractionScore:routine value:-2];
    //[routine saveInBackground];
}

+ (void)isLiked:(Routine *)routine completion:(ParseManagerFindObjectCompletionBlock) completion{
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:kLikedRoutineClass];
    [query whereKey:kUserAttributeKey equalTo:user];
    [query whereKey:kRoutineAttributeKey equalTo:routine];

    ParseManagerFindObjectCompletionBlock block = ^void(PFObject *object, NSError * _Nullable error){
        completion(object, error);
    };

    [query getFirstObjectInBackgroundWithBlock:block];
}

+ (void)changeRoutinesInteractionScore:(Routine *)routine value:(double)value{
    routine.interactionScore = [NSNumber numberWithLong:[routine.interactionScore longValue] + value];
    
    PFUser *user = [PFUser currentUser];
    
    switch ([user[@"trainingLevel"] longValue]) {
        case TrainingLevelBeginner:
            routine.beginnerUsersInteractionScore = [NSNumber numberWithLong:[routine.beginnerUsersInteractionScore longValue] + value];
            break;
        case TrainingLevelIntermediate:
            routine.mediumUsersInteractionScore = [NSNumber numberWithLong:[routine.mediumUsersInteractionScore longValue] + value];
            break;
        case TrainingLevelExpert:
            routine.expertUsersInteractionScore = [NSNumber numberWithLong:[routine.expertUsersInteractionScore longValue] + value];
            break;
        default:
            break;
    }
    
    switch ([user[@"workoutPlace"] longValue]) {
        case WorkoutPlaceHome:
            routine.homeUsersInteractionScore = [NSNumber numberWithLong:[routine.homeUsersInteractionScore longValue] + value];
            break;
        case WorkoutPlacePark:
            routine.parkUsersInteractionScore = [NSNumber numberWithLong:[routine.parkUsersInteractionScore longValue] + value];
            break;
        case WorkoutPlaceGym:
            routine.gymUsersInteractionScore = [NSNumber numberWithLong:[routine.gymUsersInteractionScore longValue] + value];
            break;
        default:
            break;
    }
    
    [routine saveEventually];
}



+ (PFFileObject *)getPFFileFromURL:(NSURL *)video videoName:(NSString *)videoName{
    if (!video){
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
    if (!image){
        return nil;
    }
    NSData *imageData = UIImageJPEGRepresentation(image, kJPEGCompressionConstant);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }

    return [PFFileObject fileObjectWithName:imageName data:imageData];
}

@end

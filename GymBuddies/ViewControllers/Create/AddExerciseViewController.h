//
//  AddExerciseViewController.h
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/11/22.
//

#import <UIKit/UIKit.h>
#import "Exercise.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AddExerciseViewControllerDelegate <NSObject>

- (void) didAddExercise:(Exercise *)exercise;

@end

@interface AddExerciseViewController : UIViewController
@property (nonatomic, weak) id<AddExerciseViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END

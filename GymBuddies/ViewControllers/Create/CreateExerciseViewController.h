//
//  CreateExerciseViewController.h
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/11/22.
//

#import <UIKit/UIKit.h>
#import "Exercise.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CreateExerciseViewControllerDelegate <NSObject>

- (void) didCreateExercise:(Exercise *)exercise;

@end


@interface CreateExerciseViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, weak) id<CreateExerciseViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

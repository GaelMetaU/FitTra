//
//  AddExerciseTableViewCell.h
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/14/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"
#import "Exercise.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddExerciseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *exerciseImage;
@property (weak, nonatomic) IBOutlet PFImageView *bodyZoneIcon;
@property (weak, nonatomic) IBOutlet PFImageView *authorProfilePicture;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
- (void)setExercise:(Exercise *)exercise;
@end

NS_ASSUME_NONNULL_END

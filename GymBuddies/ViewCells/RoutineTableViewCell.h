//
//  RoutineTableViewCell.h
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/25/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"
#import "ParseAPIManager.h"
#import "AlertCreator.h"
#import "Routine.h"

NS_ASSUME_NONNULL_BEGIN

@interface RoutineTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet PFImageView *authorProfilePicture;
@property (weak, nonatomic) IBOutlet UILabel *authorUsernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *trainingLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *workoutPlaceLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *bodyZoneCollectionView;
@property (weak, nonatomic) IBOutlet PFImageView *routineImage;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (strong, nonatomic) Routine *routine;
@property (nonatomic) BOOL isLiked;
@property (nonatomic) BOOL likedCheck;
-(void)setCellContent:(Routine *)routine;
@end

NS_ASSUME_NONNULL_END

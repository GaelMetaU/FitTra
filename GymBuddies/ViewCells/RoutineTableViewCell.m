//
//  RoutineTableViewCell.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/25/22.
//

#import "RoutineTableViewCell.h"
#import "DateTools/DateTools.h"
#import "SegmentedControlBlocksValues.h"
#import "BodyZoneCollectionViewCell.h"

static CGFloat const kLabelBorderRadius = 5;
static NSString * const kBodyZoneCollectionViewCellNoTitleIdentifier = @"BodyZoneCollectionViewCellNoTitle";
static NSString * const kProfilePictureKey = @"profilePicture";
static NSString * const kLikedNormalRoutineButtonImage = @"suit.heart";
static NSString * const kLikedFilledRoutineButtonImage = @"suit.heart.fill";

@implementation RoutineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bodyZoneCollectionView.delegate = self;
    self.bodyZoneCollectionView.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


#pragma mark -Setting content

- (void)setCellContent:(Routine *)routine{
    _routine = routine;
    
    if(self.routine.author[kProfilePictureKey]){
        self.authorProfilePicture.file = self.routine.author[kProfilePictureKey];
        self.authorProfilePicture.layer.cornerRadius = self.authorProfilePicture.frame.size.width/2;
        [self.authorProfilePicture loadInBackground];
    }

    self.routineImage.file = self.routine.image;
    [self.routineImage loadInBackground];
    self.authorUsernameLabel.text = self.routine.author.username;
    self.captionLabel.text = self.routine.caption;
    self.dateLabel.text = self.routine.createdAt.shortTimeAgoSinceNow;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%@", self.routine.likeCount];
    
    // Converts the training level value to a string and background color
    self.trainingLevelLabel.layer.cornerRadius = kLabelBorderRadius;
    self.trainingLevelLabel.text = [SegmentedControlBlocksValues setTrainingLevelLabelText:self.routine.trainingLevel];
    self.trainingLevelLabel.backgroundColor = [SegmentedControlBlocksValues setTrainingLevelLabelColor:self.routine.trainingLevel];
    self.trainingLevelLabel.layer.masksToBounds = YES;
    
    // Converts the workout place value to a string
    self.workoutPlaceLabel.layer.cornerRadius = kLabelBorderRadius;
    self.workoutPlaceLabel.text = [SegmentedControlBlocksValues setWorkoutPlaceLabelContent:self.routine.workoutPlace];
    self.workoutPlaceLabel.layer.masksToBounds = YES;
    
    [self setLikedRoutine];
}


-(void)setLikedRoutine{
    [ParseAPIManager isLiked:self.routine completion:^(PFObject * _Nonnull object, NSError * _Nullable error) {
        if(error == nil){
            [self.likeButton setImage:[UIImage systemImageNamed:kLikedFilledRoutineButtonImage] forState:UIControlStateNormal];
            self.likeButton.tintColor = [UIColor systemRedColor];
            self.isLiked = YES;
        } else{
            [self.likeButton setImage:[UIImage systemImageNamed:kLikedNormalRoutineButtonImage] forState:UIControlStateNormal];
            self.likeButton.tintColor = [UIColor systemBlueColor];
            self.isLiked = NO;
        }
    }];
}


#pragma mark - Like method

- (IBAction)didTapLike:(id)sender {
    [self likeAction];
}

-(void)likeAction{
    if(self.isLiked){
        
    } else {
        [self.likeButton setImage:[UIImage systemImageNamed:kLikedFilledRoutineButtonImage] forState:UIControlStateNormal];
        self.likeButton.tintColor = [UIColor systemRedColor];
        self.routine.likeCount = [NSNumber numberWithLong:[self.routine.likeCount longValue] + 1 ];
        self.likeCountLabel.text = [NSString stringWithFormat:@"%@", self.routine.likeCount];
        [ParseAPIManager likeRoutine:self.routine completion:^(BOOL succeeded, NSError * _Nonnull error) {}];
    }
}


#pragma mark -Collection view methods

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BodyZoneCollectionViewCell *cell = [self.bodyZoneCollectionView dequeueReusableCellWithReuseIdentifier:kBodyZoneCollectionViewCellNoTitleIdentifier forIndexPath:indexPath];
    [cell setCellContentNoTitle:self.routine.bodyZoneList[indexPath.item]];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.routine.bodyZoneList.count;
}
@end

//
//  TimelineRoutineTableViewCell.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/25/22.
//

#import "TimelineRoutineTableViewCell.h"
#import "DateTools/DateTools.h"
#import "SegmentedControlBlocksValues.h"
#import "BodyZoneCollectionViewCell.h"

static CGFloat const kLabelBorderRadius = 5;
static NSString * const kBodyZoneCollectionViewCellNoTitleIdentifier = @"BodyZoneCollectionViewCellNoTitle";

@implementation TimelineRoutineTableViewCell

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
    
    if(self.routine.author[@"profilePicture"]){
        self.authorProfilePicture.file = self.routine.author[@"profilePicture"];
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

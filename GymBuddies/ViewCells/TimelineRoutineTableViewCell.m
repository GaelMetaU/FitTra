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

static NSString * const kTrainingLevelExpert = @"Expert";
static NSString * const kTraininLevelMedium = @"Medium";
static NSString * const kTrainingLevelBeginner = @"Beginner";

static NSString * const kWorkoutPlaceHome = @"Home";
static NSString * const kWorkoutPlacePark = @"Park";
static NSString * const kWorkoutPlaceGym = @"Gym";

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
    [self setTrainingLevelLabelContent];
    [self setWorkoutPlaceLabelContent];
    NSLog(@"Count %lu",self.routine.bodyZoneList.count);
}


-(void)setTrainingLevelLabelContent{
    self.trainingLevelLabel.layer.cornerRadius = 5;
    //self.trainingLevelLabel.layer.borderWidth = 20.0;
    TrainingLevels trainingLevel = [self.routine.trainingLevel longValue];
    switch (trainingLevel) {
        case TrainingLevelExpert:
            self.trainingLevelLabel.backgroundColor = [UIColor systemRedColor];
            self.trainingLevelLabel.text = kTrainingLevelExpert;
            break;
        case TrainingLevelIntermediate:
            self.trainingLevelLabel.backgroundColor = [UIColor systemYellowColor];
            self.trainingLevelLabel.text = kTraininLevelMedium;
            break;
        case TrainingLevelBeginner:
            self.trainingLevelLabel.backgroundColor = [UIColor systemGreenColor];
            self.trainingLevelLabel.text = kTrainingLevelBeginner;
            break;
        default:
            break;
    }
    self.trainingLevelLabel.layer.masksToBounds = YES;
    [self.bodyZoneCollectionView reloadData];
}


-(void)setWorkoutPlaceLabelContent{
    self.workoutPlaceLabel.layer.cornerRadius = 5;
    
    WorkoutPlace workoutPlace = [self.routine.workoutPlace longValue];

    switch (workoutPlace) {
        case WorkoutPlaceGym:
            self.workoutPlaceLabel.text = kWorkoutPlaceGym;
            break;
        case WorkoutPlacePark:
            self.workoutPlaceLabel.text = kWorkoutPlacePark;
            break;
        case WorkoutPlaceHome:
            self.workoutPlaceLabel.text = kWorkoutPlaceHome;
            break;
        default:
            break;
    }
    self.workoutPlaceLabel.layer.masksToBounds = YES;

}


#pragma mark -Collection view methods

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BodyZoneCollectionViewCell *cell = [self.bodyZoneCollectionView dequeueReusableCellWithReuseIdentifier:@"BodyZoneCollectionViewCellNoTitle" forIndexPath:indexPath];
    
    [cell setCellContentNoTitle:self.routine.bodyZoneList[indexPath.item]];
    NSLog(@"BODY ZONE %@", self.routine.bodyZoneList[indexPath.item]);
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.routine.bodyZoneList.count;
}
@end

//
//  RoutineDetailsViewController.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/26/22.
//

#import "RoutineDetailsViewController.h"
#import "Parse/PFImageView.h"
#import "SegmentedControlBlocksValues.h"
#import "RoutineDetailsExerciseTableViewCell.h"
#import "BodyZoneCollectionViewCell.h"


static NSString * const kTrainingLevelExpert = @"Expert";
static NSString * const kTrainingLevelMedium = @"Medium";
static NSString * const kTrainingLevelBeginner = @"Beginner";

static NSString * const kWorkoutPlaceHome = @"Home";
static NSString * const kWorkoutPlacePark = @"Park";
static NSString * const kWorkoutPlaceGym = @"Gym";


@interface RoutineDetailsViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *routineImage;
@property (weak, nonatomic) IBOutlet UICollectionView *bodyZoneCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UITableView *exerciseListTableView;
@property (weak, nonatomic) IBOutlet UILabel *trainingLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *workoutPlaceLabel;

@property (strong, nonatomic) NSArray *bodyZoneList;
@property (strong, nonatomic) NSArray *exerciseList;

@end

@implementation RoutineDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bodyZoneList = [[NSArray alloc]init];
    self.exerciseList = [[NSArray alloc]init];
    
    self.bodyZoneCollectionView.delegate = self;
    self.bodyZoneCollectionView.dataSource = self;
    
    self.exerciseListTableView.delegate = self;
    self.exerciseListTableView.dataSource = self;
    self.exerciseListTableView.rowHeight = UITableViewAutomaticDimension;
    
    [self setRoutine:self.routine];
}

#pragma mark - Top view content

-(void)setRoutine:(Routine *)routine{
    _routine = routine;
    [self setTopViewContent];

    self.bodyZoneList = self.routine.bodyZoneList;
    self.exerciseList = self.routine.exerciseList;
    
    [self.exerciseListTableView reloadData];
    [self.bodyZoneCollectionView reloadData];
}

-(void)setTopViewContent{
    self.captionLabel.text = self.routine.caption;
    self.routineImage.file = self.routine.image;
    [self.routineImage loadInBackground];
    [self setTrainingLevelLabelContent];
    [self setWorkoutPlaceLabelContent];
}


-(void)setTrainingLevelLabelContent{
    self.trainingLevelLabel.layer.cornerRadius = 5;
    TrainingLevels trainingLevel = [self.routine.trainingLevel longValue];
    switch (trainingLevel) {
        case TrainingLevelExpert:
            self.trainingLevelLabel.backgroundColor = [UIColor systemRedColor];
            self.trainingLevelLabel.text = kTrainingLevelExpert;
            break;
        case TrainingLevelIntermediate:
            self.trainingLevelLabel.backgroundColor = [UIColor systemYellowColor];
            self.trainingLevelLabel.text = kTrainingLevelMedium;
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


#pragma mark - Collection view methods

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BodyZoneCollectionViewCell *cell = [self.bodyZoneCollectionView dequeueReusableCellWithReuseIdentifier:@"RoutineBodyZoneCollectionViewCell" forIndexPath:indexPath];
    [cell setCellContent:self.bodyZoneList[indexPath.item]];
    return cell;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.bodyZoneList.count;
}


#pragma mark - Table view methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RoutineDetailsExerciseTableViewCell *cell = [self.exerciseListTableView dequeueReusableCellWithIdentifier:@"RoutineDetailsExerciseTableViewCell"];
    [cell setCellContent:self.exerciseList[indexPath.row]];
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.exerciseList.count;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

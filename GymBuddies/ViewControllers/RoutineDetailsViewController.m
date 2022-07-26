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

static NSString * const kBodyZoneCollectionViewCellIdentifier = @"RoutineBodyZoneCollectionViewCell";
static NSString * const kExerciseTableViewCellIdentifier = @"RoutineDetailsExerciseTableViewCell";

static CGFloat const kLabelBorderRadius = 5;

@interface RoutineDetailsViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *routineImage;
@property (weak, nonatomic) IBOutlet UICollectionView *bodyZoneCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UITableView *exerciseListTableView;
@property (weak, nonatomic) IBOutlet UILabel *trainingLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *workoutPlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
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

// Grabs the routine broguht by the segue and sets the view's content
-(void)setRoutine:(Routine *)routine{
    _routine = routine;
    [self setTopViewContent];

    self.bodyZoneList = self.routine.bodyZoneList;
    self.exerciseList = self.routine.exerciseList;
    
    [self.exerciseListTableView reloadData];
    [self.bodyZoneCollectionView reloadData];
}


-(void)setTopViewContent{
    self.routineImage.file = self.routine.image;
    [self.routineImage loadInBackground];
    
    self.captionLabel.text = self.routine.caption;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%@", self.routine.likeCount];
    
    // Converts the training level value to a string and background color
    self.trainingLevelLabel.layer.cornerRadius = kLabelBorderRadius;
    self.trainingLevelLabel.text = [SegmentedControlBlocksValues setTrainingLevelLabelText: self.routine.trainingLevel];
    self.trainingLevelLabel.backgroundColor = [SegmentedControlBlocksValues setTrainingLevelLabelColor:self.routine.trainingLevel];
    self.trainingLevelLabel.layer.masksToBounds = YES;
    
    // Converts the workout place value to a string
    self.workoutPlaceLabel.layer.cornerRadius = kLabelBorderRadius;
    self.workoutPlaceLabel.text = [SegmentedControlBlocksValues setWorkoutPlaceLabelContent:self.routine.workoutPlace];
    self.workoutPlaceLabel.layer.masksToBounds = YES;
}


#pragma mark - Collection view methods

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BodyZoneCollectionViewCell *cell = [self.bodyZoneCollectionView dequeueReusableCellWithReuseIdentifier: kBodyZoneCollectionViewCellIdentifier forIndexPath:indexPath];
    [cell setCellContent:self.bodyZoneList[indexPath.item]];
    return cell;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.bodyZoneList.count;
}


#pragma mark - Table view methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RoutineDetailsExerciseTableViewCell *cell = [self.exerciseListTableView dequeueReusableCellWithIdentifier:kExerciseTableViewCellIdentifier];
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

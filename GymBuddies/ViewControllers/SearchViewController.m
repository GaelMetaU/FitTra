//
//  SearchViewController.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/28/22.
//

#import "SearchViewController.h"
#import "ParseAPIManager.h"
#import "RoutineTableViewCell.h"
#import "Routine.h"
#import "RoutineDetailsViewController.h"
#import "AlertCreator.h"
#import "SegmentedControlBlocksValues.h"
#import "CommonValidations.h"

static NSString * const kSearchToDetailsSegue = @"SearchToDetailsSegue";
static NSString * const kBeginnerFilterTitle = @"Beginner";
static NSString * const kMediumFilterTitle = @"Medium";
static NSString * const kExpertFilterTitle = @"Expert";
static NSString * const kHomeFilterTitle = @"Home";
static NSString * const kParkFilterTitle = @"Park";
static NSString * const kGymFilterTitle = @"Gym";


@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UITableView *resultsTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *workoutPlaceFilter;
@property (weak, nonatomic) IBOutlet UIButton *trainingLevelFilter;
@property (strong, nonatomic) NSArray *results;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSNumber *workoutPlaceFilterValue;
@property (strong, nonatomic) NSNumber *trainingLevelFilterValue;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar.delegate = self;
    
    self.resultsTableView.delegate = self;
    self.resultsTableView.dataSource = self;
    self.resultsTableView.rowHeight = UITableViewAutomaticDimension;
    
    [self setTrainingLevelFilterMenu];
    [self setWorkoutPlaceFilterMenu];
    
    self.results = [[NSArray alloc]init];
    
}


#pragma mark - Search bar methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(self.timer)
        {
            [self.timer invalidate];
            self.timer = nil;
        }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.20 target:self selector:@selector(searchTimerCall:) userInfo:nil repeats:NO];
}


-(void)searchTimerCall:(NSTimer *)timer{
    [self searchRoutines];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
}


#pragma mark - Filters

-(void)setTrainingLevelFilterMenu{
    UIAction *beginner = [UIAction actionWithTitle:kBeginnerFilterTitle image:nil identifier:nil handler:^(UIAction *action){
        NSNumber *filterValue = [NSNumber numberWithLong:TrainingLevelBeginner];
        [self changeTrainingLevelFilterStates:kBeginnerFilterTitle newFilterValue:filterValue];
    }];
    
    UIAction *medium = [UIAction actionWithTitle:kMediumFilterTitle image:nil identifier:nil handler:^(UIAction *action){
        NSNumber *filterValue = [NSNumber numberWithLong:TrainingLevelIntermediate];
        [self changeTrainingLevelFilterStates:kMediumFilterTitle newFilterValue:filterValue];
    }];
    
    UIAction *expert = [UIAction actionWithTitle:kExpertFilterTitle image:nil identifier:nil handler:^(UIAction *action){
        NSNumber *filterValue = [NSNumber numberWithLong:TrainingLevelExpert];
        [self changeTrainingLevelFilterStates:kExpertFilterTitle newFilterValue:filterValue];
    }];
    
    UIMenu *menu = [[UIMenu alloc]menuByReplacingChildren:[NSArray arrayWithObjects:beginner, medium, expert, nil]];
    self.trainingLevelFilter.menu = menu;
}


-(void)changeTrainingLevelFilterStates:(NSString *)actionTitle newFilterValue:(NSNumber *)newFilterValue{
    for(UIAction *action in self.trainingLevelFilter.menu.children){
        if(action.title == actionTitle){
            if(action.state == UIMenuElementStateOn){
                action.state = UIMenuElementStateOff;
                self.trainingLevelFilterValue = nil;
            } else {
                action.state = UIMenuElementStateOn;
                self.trainingLevelFilterValue = newFilterValue;
            }
        }
        else {
            action.state = UIMenuElementStateOff;
        }
    }
    [self searchRoutines];
}


-(void)setWorkoutPlaceFilterMenu{
    UIAction *home = [UIAction actionWithTitle:kHomeFilterTitle image:nil identifier:nil handler:^(UIAction *action){
        NSNumber *filterValue = [NSNumber numberWithLong:WorkoutPlaceHome];
        [self changeWorkoutPlaceFilterStates:kHomeFilterTitle newFilterValue:filterValue];
    }];
    
    UIAction *park = [UIAction actionWithTitle:kParkFilterTitle image:nil identifier:nil handler:^(UIAction *action){
        NSNumber *filterValue = [NSNumber numberWithLong:WorkoutPlacePark];
        [self changeWorkoutPlaceFilterStates:kParkFilterTitle newFilterValue:filterValue];
    }];
    
    UIAction *gym = [UIAction actionWithTitle:kGymFilterTitle image:nil identifier:nil handler:^(UIAction *action){
        NSNumber *filterValue = [NSNumber numberWithLong:WorkoutPlaceGym];
        [self changeWorkoutPlaceFilterStates:kGymFilterTitle newFilterValue:filterValue];
    }];
    
    UIMenu *menu = [[UIMenu alloc]menuByReplacingChildren:[NSArray arrayWithObjects:home, park, gym, nil]];
    self.workoutPlaceFilter.menu = menu;
}


-(void)changeWorkoutPlaceFilterStates:(NSString *)actionTitle newFilterValue:(NSNumber *)newFilterValue{
    for(UIAction *action in self.workoutPlaceFilter.menu.children){
        if(action.title == actionTitle){
            if(action.state == UIMenuElementStateOn){
                action.state = UIMenuElementStateOff;
                self.workoutPlaceFilterValue = nil;
            } else {
                action.state = UIMenuElementStateOn;
                self.workoutPlaceFilterValue = newFilterValue;
            }
        }
        else{
            action.state = UIMenuElementStateOff;
        }
    }
    [self searchRoutines];
}


#pragma mark - Search query

-(void)searchRoutines{
    NSString *searchTerm = [CommonValidations standardizeSearchTerm:self.searchBar.text];;
    if(searchTerm.length != 0){
        [ParseAPIManager searchRoutines:searchTerm workoutPlaceFilter:self.workoutPlaceFilterValue trainingLevelFilter:self.trainingLevelFilterValue completion:^(NSArray * _Nonnull elements, NSError * _Nullable error) {
                if(error != nil){
                    UIAlertController *alert = [AlertCreator createOkAlert:@"Error searching" message:error.localizedDescription];
                    [self presentViewController:alert animated:YES completion:nil];
                } else {
                    self.results = elements;
                    [self.resultsTableView reloadData];
                }
        }];
    }
}


#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.results.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RoutineTableViewCell *cell = [self.resultsTableView dequeueReusableCellWithIdentifier:@"RoutineResultTableViewCell"];
    [cell setCellContent:self.results[indexPath.row]];
    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BOOL isSearchToDetailsSegue = [segue.identifier isEqualToString:kSearchToDetailsSegue];
    if(isSearchToDetailsSegue){
        NSIndexPath *indexPath = [self.resultsTableView indexPathForCell:sender];
        RoutineDetailsViewController *routineDetailsViewController = [segue destinationViewController];
        routineDetailsViewController.routine = self.results[indexPath.row];
    }
}


@end

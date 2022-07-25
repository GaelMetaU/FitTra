//
//  AddExerciseViewController.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/11/22.
//

#import "AddExerciseViewController.h"
#import "ParseAPIManager.h"
#import "AddExerciseTableViewCell.h"
#import "CreateExerciseViewController.h"
#import "AlertCreator.h"

static NSString * const CREATE_EXERCISE_SEGUE_IDENTIFIER = @"CreateExerciseSegue";

@interface AddExerciseViewController () <UITableViewDelegate, UITableViewDataSource, CreateExerciseViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *exercises;

@end

@implementation AddExerciseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.exercises = [[NSMutableArray alloc]init];
    [self loadUsersExercises];
}


#pragma mark - Data fetching

-(void)loadUsersExercises{
    [ParseAPIManager fetchUsersExercises:^(NSArray * _Nonnull elements, NSError * _Nonnull error) {
        if(elements!=nil){
            for(PFObject *element in elements){
                [self.exercises addObject:element[@"exercise"]];
            }
            [self.tableView reloadData];
        } else {
            UIAlertController *alert = [AlertCreator createOkAlert:@"Error fetching exercises" message:error.localizedDescription];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}


#pragma mark - Table view methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddExerciseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddExerciseTableViewCell"];
    [cell setExercise:self.exercises[indexPath.row]];
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.exercises.count;
}

// When user selects an exercise, it returns to the routine screen and calls the delegate method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate didAddExercise:self.exercises[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Delegate methods

- (void) didCreateExercise:(Exercise *)exercise{
    [self.exercises insertObject:exercise atIndex:0];
    [self.tableView reloadData];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BOOL isCreateExerciseSegue = [segue.identifier isEqualToString:CREATE_EXERCISE_SEGUE_IDENTIFIER];
    if(isCreateExerciseSegue){
        CreateExerciseViewController *createExerciseViewController = [segue destinationViewController];
        createExerciseViewController.delegate = self;
    }
}


@end

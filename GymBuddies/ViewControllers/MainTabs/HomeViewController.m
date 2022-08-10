//
//  HomeViewController.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/8/22.
//

#import "HomeViewController.h"
#import "ParseAPIManager.h"
#import "GoogleMapsView.h"
#import "AlertCreator.h"
#import "RoutineTableViewCell.h"
#import "RoutineDetailsViewController.h"

static NSString * const kHomeToDetailsSegue = @"HomeToDetailsSegue";
static NSString * const kRoutineTableViewCell = @"RoutineTableViewCell";

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet GoogleMapsView *googleMapsView;
@property (strong, nonatomic) NSMutableArray *routineFeed;
@property (nonatomic) double maxRoutineAmount;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.googleMapsView setContent];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight =UITableViewAutomaticDimension;
    self.routineFeed = [[NSMutableArray alloc]init];
    self.maxRoutineAmount = 0;
    [self fetchRoutines];
    
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
}


#pragma mark - Fetching data

-(void)refreshView:(UIRefreshControl *)refreshControl{
    [self fetchRoutines];
    self.maxRoutineAmount = 0;
    [refreshControl endRefreshing];
}


- (void)fetchRoutines{
    __weak __typeof(self) weakSelf = self;
    [ParseAPIManager fetchHomeTimelineRoutines:self.routineFeed.count completion:^(NSArray * _Nonnull elements, NSError * _Nonnull error) {
        __strong __typeof(self) strongSelf = weakSelf;
            if (elements != nil){
                [strongSelf->_routineFeed addObjectsFromArray: elements];
                [strongSelf->_tableView reloadData];
                self.maxRoutineAmount += kRoutineFetchAmount;
            } else {
                UIAlertController *alert = [AlertCreator createOkAlert:@"Error loading timeline" message:error.localizedDescription];
                [strongSelf presentViewController:alert animated:YES completion:nil];
            }
    }];
}


- (void)loadMoreRoutines{
    // If current amount of routines is not equal to the current maximum it means there are no routines left
    if (self.routineFeed.count == self.maxRoutineAmount){
        [self fetchRoutines];
    }
}

#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.routineFeed.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RoutineTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"RoutineTableViewCell"];
    [cell setCellContent:self.routineFeed[indexPath.row]];
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row + 1 == self.routineFeed.count){
        [self loadMoreRoutines];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    BOOL isHomeToDetailsSegue = [segue.identifier isEqualToString:kHomeToDetailsSegue];
    if (isHomeToDetailsSegue){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        RoutineDetailsViewController *routineDetailsViewController = [segue destinationViewController];
        routineDetailsViewController.routine = self.routineFeed[indexPath.row];
        RoutineTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        routineDetailsViewController.isLiked = cell.isLiked;
    }
    
}


@end

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

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet GoogleMapsView *googleMapsView;
@property (strong, nonatomic) NSArray *routineFeed;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.googleMapsView setContent];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight =UITableViewAutomaticDimension;
    self.routineFeed = [[NSArray alloc]init];

    [self fetchRoutines];
}


#pragma mark - Table view methods

-(void)fetchRoutines{
    [ParseAPIManager fetchHomeTimelineRoutines:^(NSArray * _Nonnull elements, NSError * _Nonnull error) {
            if(elements != nil){
                self.routineFeed = elements;
                [self.tableView reloadData];
            } else{
                UIAlertController *alert = [AlertCreator createOkAlert:@"Error loading timeline" message:error.localizedDescription];
                [self presentViewController:alert animated:YES completion:nil];
            }
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.routineFeed.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RoutineTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"RoutineTableViewCell"];
    [cell setCellContent:self.routineFeed[indexPath.row]];
    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    BOOL isHomeToDetailsSegue = [segue.identifier isEqualToString:kHomeToDetailsSegue];
    if(isHomeToDetailsSegue){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        RoutineDetailsViewController *routineDetailsViewController = [segue destinationViewController];
        routineDetailsViewController.routine = self.routineFeed[indexPath.row];
    }
    
}


@end

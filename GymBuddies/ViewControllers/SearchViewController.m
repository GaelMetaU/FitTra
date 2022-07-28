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

static NSString * const kSearchToDetailsSegue = @"SearchToDetailsSegue";

@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UITableView *resultsTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *results;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar.delegate = self;
    
    self.resultsTableView.delegate = self;
    self.resultsTableView.dataSource = self;
    self.resultsTableView.rowHeight = UITableViewAutomaticDimension;
    
    self.navigationItem.searchController = self.searchController;
    
    self.results = [[NSArray alloc]init];
    
}


#pragma mark - Search bar methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(self.timer)
        {
            [self.timer invalidate];
            self.timer = nil;
        }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.20 target:self selector:@selector(searchQuery:) userInfo:nil repeats:NO];
}


-(void)searchQuery:(NSTimer *)timer{
    NSString *searchTerm = self.searchBar.text;
    if(searchTerm.length != 0){
        [ParseAPIManager searchRoutines:searchTerm completion:^(NSArray * _Nonnull elements, NSError * _Nullable error) {
                    if(error != nil){
                        UIAlertController *alert = [AlertCreator createOkAlert:@"Error searching" message:error.localizedDescription];
                        [self presentViewController:alert animated:YES completion:nil];
                    } else {
                        NSLog(@"Done");
                        self.results = elements;
                        [self.resultsTableView reloadData];
                    }
        }];
    }
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
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

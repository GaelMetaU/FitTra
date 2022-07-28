//
//  SearchViewController.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/28/22.
//

#import "SearchViewController.h"
#import "RoutineTableViewCell.h"

@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UITableView *resultsTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *results;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.resultsTableView.delegate = self;
    self.resultsTableView.dataSource = self;
    
    self.results = [[NSArray alloc]init];
    
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
    
}


@end

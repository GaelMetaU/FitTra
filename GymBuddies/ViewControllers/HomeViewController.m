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

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet GoogleMapsView *googleMapsView;
@property (strong, nonatomic) NSArray *routineFeed;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight =UITableViewAutomaticDimension;
    
    [self.googleMapsView setContent];
    
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
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GoogleMapsTableViewCell"];
    return cell;
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

//
//  ProfileViewController.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/8/22.
//

#import "ProfileViewController.h"
#import "ParseAPIManager.h"
#import "Parse/PFImageView.h"
#import "Routine.h"
#import "SceneDelegate.h"
#import "AlertCreator.h"
#import "RoutineTableViewCell.h"
#import "RoutineDetailsViewController.h"

static NSNumber * kShowCreatedRoutines = @0;
static NSNumber * kShowLikedRoutines = @1;
static NSString * kProfileToDetailsSegue = @"ProfileToDetailsSegue";

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UITableView *routinesTableView;
@property (weak, nonatomic) IBOutlet PFImageView *userProfilePicture;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) NSArray *createdRoutineList;
@property (strong, nonatomic) NSArray *likedRoutineList;
@property (strong, nonatomic) NSNumber *showCreatedOrLikedRoutinesIndicator;
@end

@implementation ProfileViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.likedRoutineList = [[NSArray alloc]init];
    self.createdRoutineList = [[NSArray alloc]init];
    self.showCreatedOrLikedRoutinesIndicator = kShowCreatedRoutines;
    
    self.routinesTableView.delegate = self;
    self.routinesTableView.dataSource = self;
    
    [self setProfileInfo];
    [self fetchUsersLikedRoutines];
    [self fetchUsersCreatedRoutines];
}


- (IBAction)didTapLogOut:(id)sender {
    [ParseAPIManager logOut:^(NSError * _Nonnull error) {
        if(error){
            UIAlertController *alert = [AlertCreator createOkAlert:@"Error logging out" message:error.localizedDescription];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            SceneDelegate *delegate = (SceneDelegate *)self.view.window.windowScene.delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            delegate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
        }
    }];
}


#pragma mark - Top view set up

-(void)setProfileInfo{
    PFUser *user = [PFUser currentUser];
    
    self.userProfilePicture.layer.cornerRadius = self.userProfilePicture.frame.size.width/2;
    if(user[@"profilePicture"]){
        self.userProfilePicture.file = user[@"profilePicture"];
        [self.userProfilePicture loadInBackground];
    }
    
    self.usernameLabel.text = user.username;
}



#pragma mark - Fetching routines

-(void)fetchUsersCreatedRoutines{
    [ParseAPIManager fetchUsersCreatedRoutines:^(NSArray * _Nonnull elements, NSError * _Nullable error) {
            if(elements != nil){
                self.createdRoutineList = elements;
                [self.routinesTableView reloadData];
            } else{
                UIAlertController *alert = [AlertCreator createOkAlert:@"Error loading your routines" message:error.localizedDescription];
                [self presentViewController:alert animated:YES completion:nil];
            }
    }];
}


-(void)fetchUsersLikedRoutines{
    [ParseAPIManager fetchUsersLikedRoutines:^(NSArray * _Nonnull elements, NSError * _Nullable error) {
            if(elements != nil){
                self.likedRoutineList = elements;
                [self.routinesTableView reloadData];
            } else{
                UIAlertController *alert = [AlertCreator createOkAlert:@"Error loading your liked routines" message:error.localizedDescription];
                [self presentViewController:alert animated:YES completion:nil];
            }
    }];
}


#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.showCreatedOrLikedRoutinesIndicator == kShowLikedRoutines){
        return self.likedRoutineList.count;
    } else if(self.showCreatedOrLikedRoutinesIndicator == kShowCreatedRoutines){
        return self.createdRoutineList.count;
    } else {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RoutineTableViewCell *cell = [self.routinesTableView dequeueReusableCellWithIdentifier:@"RoutineTableViewCell"];
    
    if(self.showCreatedOrLikedRoutinesIndicator == kShowLikedRoutines){
        [cell setCellContent:self.likedRoutineList[indexPath.row]];
    } else {
        [cell setCellContent:self.createdRoutineList[indexPath.row]];
    }
    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BOOL isHomeToDetailsSegue = [segue.identifier isEqualToString:kProfileToDetailsSegue];
    if(isHomeToDetailsSegue){
        NSIndexPath *indexPath = [self.routinesTableView indexPathForCell:sender];
        RoutineDetailsViewController *routineDetailsViewController = [segue destinationViewController];
        if(self.showCreatedOrLikedRoutinesIndicator == kShowLikedRoutines){
            routineDetailsViewController.routine = self.likedRoutineList[indexPath.row];
        } else {
            routineDetailsViewController.routine = self.createdRoutineList[indexPath.row];
        }
    }
}


@end

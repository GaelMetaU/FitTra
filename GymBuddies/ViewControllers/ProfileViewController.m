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

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UITableView *routinesTableView;
@property (weak, nonatomic) IBOutlet PFImageView *userProfilePicture;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) NSArray *createdRoutineList;
@property (strong, nonatomic) NSArray *likedRoutineList;

@end

@implementation ProfileViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.likedRoutineList = [[NSArray alloc]init];
    self.createdRoutineList = [[NSArray alloc]init];
    
    [self setProfileInfo];
    [self fetchUsersLikedRoutines];
    [self fetchUsersCreatedRoutines];
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
                UIAlertController *alert = [AlertCreator createOkAlert:@"Error loading your routines" message:error.localizedDescription];
                [self presentViewController:alert animated:YES completion:nil];
            }
    }];
}


#pragma mark - 
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

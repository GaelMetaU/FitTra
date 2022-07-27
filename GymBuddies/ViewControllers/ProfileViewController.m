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
#import "MobileCoreServices/MobileCoreServices.h"

static NSNumber * kShowCreatedRoutines = @0;
static NSNumber * kShowLikedRoutines = @1;
static NSString * kProfileToDetailsSegue = @"ProfileToDetailsSegue";

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UITableView *routinesTableView;
@property (weak, nonatomic) IBOutlet PFImageView *userProfilePicture;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *showCreatedRoutinesButton;
@property (weak, nonatomic) IBOutlet UIButton *showLikedRoutinesButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (strong, nonatomic) NSArray *createdRoutineList;
@property (strong, nonatomic) NSArray *likedRoutineList;
@property (strong, nonatomic) NSNumber *showCreatedOrLikedRoutinesIndicator;
@property (strong, nonatomic) UIImagePickerController *mediaPicker;
@end

@implementation ProfileViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mediaPicker = [UIImagePickerController new];
    self.mediaPicker.delegate = self;
    self.mediaPicker.allowsEditing = YES;
    
    self.likedRoutineList = [[NSArray alloc]init];
    self.createdRoutineList = [[NSArray alloc]init];
    
    self.showCreatedRoutinesButton.selected = YES;
    self.showCreatedOrLikedRoutinesIndicator = kShowCreatedRoutines;
    
    self.routinesTableView.delegate = self;
    self.routinesTableView.dataSource = self;
    
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
    [self setSettingsPullDownButton];
}


-(void)setSettingsPullDownButton{
    
    UIAction *logOut = [UIAction actionWithTitle:@"Log out" image:nil identifier:nil handler:^(UIAction *action){
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
    }];
    
    UIAction *changeProfilePicture = [UIAction actionWithTitle:@"Change Profile Picture" image:nil identifier:nil handler:^(UIAction *action){
        self.mediaPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.mediaPicker.mediaTypes = @[(NSString*)kUTTypeImage];
        [self presentViewController:self.mediaPicker animated:YES completion:nil];
    }];
    
    UIMenu *menu = [[UIMenu alloc]menuByReplacingChildren:[NSArray arrayWithObjects:logOut, changeProfilePicture, nil]];
    self.settingsButton.menu = menu;
    self.settingsButton.showsMenuAsPrimaryAction = YES;
}


#pragma mark - Change Profile Picture

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    NSURL *urlImage = [info objectForKey:UIImagePickerControllerImageURL];
    NSString *imageName = urlImage.lastPathComponent;
    
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    PFFileObject *imageFile = [ParseAPIManager getPFFileFromImage:editedImage imageName:imageName];
    
    [ParseAPIManager changeProfilePicture:imageFile completion:^(BOOL succeeded, NSError * _Nonnull error) {
        if(succeeded){
            self.userProfilePicture.image = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            UIAlertController *alert = [AlertCreator createOkAlert:@"Error changing your profile picture" message:error.localizedDescription];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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


#pragma mark - Button interaction

- (IBAction)didTapCreated:(id)sender {
    if(self.showCreatedRoutinesButton.isSelected){
        return;
    }
    self.showCreatedRoutinesButton.selected = YES;
    self.showLikedRoutinesButton.selected = NO;
    self.showCreatedOrLikedRoutinesIndicator = kShowCreatedRoutines;
   
    [self.routinesTableView reloadData];
}


- (IBAction)didTapLiked:(id)sender {
    if(self.showLikedRoutinesButton.isSelected){
        return;
    }
    self.showLikedRoutinesButton.selected = YES;
    self.showCreatedRoutinesButton.selected = NO;
    self.showCreatedOrLikedRoutinesIndicator = kShowLikedRoutines;
   
    [self.routinesTableView reloadData];
}


#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.showCreatedOrLikedRoutinesIndicator == kShowLikedRoutines){
        NSLog(@"%lu", self.likedRoutineList.count);
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
        [cell setCellContent:self.likedRoutineList[indexPath.row][@"routine"]];
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

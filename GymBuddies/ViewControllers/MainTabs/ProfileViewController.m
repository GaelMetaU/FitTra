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
static NSString * kLoginViewControllerIdentifier = @"LoginNavigationController";
static NSString * kRoutineTableViewCellIdentifier = @"RoutineTableViewCell";

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
    self.routinesTableView.delegate = self;
    self.routinesTableView.dataSource = self;
    // Media picker set up
    self.mediaPicker = [UIImagePickerController new];
    self.mediaPicker.delegate = self;
    self.mediaPicker.allowsEditing = YES;
    // Initializing data sources
    self.likedRoutineList = [[NSArray alloc]init];
    self.createdRoutineList = [[NSArray alloc]init];
    // Initial routine views
    self.showCreatedRoutinesButton.selected = YES;
    self.showCreatedOrLikedRoutinesIndicator = kShowCreatedRoutines;
    
    [self fetchUsersLikedRoutines];
    [self fetchUsersCreatedRoutines];
    [self setProfileInfo];
    
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    [self.routinesTableView insertSubview:refreshControl atIndex:0];
}


#pragma mark - Top view set up

- (void)setProfileInfo{
    PFUser *user = [PFUser currentUser];
    
    self.userProfilePicture.layer.cornerRadius = self.userProfilePicture.frame.size.width/2;
    if (user[kProfilePictureAttributeKey]){
        self.userProfilePicture.file = user[kProfilePictureAttributeKey];
        [self.userProfilePicture loadInBackground];
    }
    
    self.usernameLabel.text = user.username;
    [self setSettingsPullDownButton];
}


- (void)setSettingsPullDownButton{
    
    UIAction *logOut = [UIAction actionWithTitle:@"Log out" image:nil identifier:nil handler:^(UIAction *action){
        __weak __typeof(self) weakSelf = self;
        UIView *rootView = self.view;
        [ParseAPIManager logOut:^(NSError * _Nonnull error) {
            __strong __typeof(self) strongSelf = weakSelf;
            if (error){
                UIAlertController *alert = [AlertCreator createOkAlert:@"Error logging out" message:error.localizedDescription];
                [strongSelf presentViewController:alert animated:YES completion:nil];
            } else {
                SceneDelegate *delegate = (SceneDelegate *)rootView.window.windowScene.delegate;
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                delegate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:kLoginViewControllerIdentifier];
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
        if (succeeded){
            self.userProfilePicture.image = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            UIAlertController *alert = [AlertCreator createOkAlert:@"Error changing your profile picture" message:error.localizedDescription];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Fetching routines

- (void)fetchUsersCreatedRoutines{
    __weak __typeof(self) weakSelf = self;
    [ParseAPIManager fetchUsersCreatedRoutines:^(NSArray * _Nonnull elements, NSError * _Nullable error) {
        __strong __typeof(self) strongSelf = weakSelf;
        if (elements != nil){
            strongSelf->_createdRoutineList = elements;
            [strongSelf->_routinesTableView reloadData];
        } else {
            [strongSelf fetchingAlert:error];
        }
    }];
}


- (void)fetchUsersLikedRoutines{
    __weak __typeof(self) weakSelf = self;
    [ParseAPIManager fetchUsersLikedRoutines:^(NSArray * _Nonnull elements, NSError * _Nullable error) {
        __strong __typeof(self) strongSelf = weakSelf;
        if (elements != nil){
            strongSelf->_likedRoutineList = elements;
            [strongSelf->_routinesTableView reloadData];
        } else {
            [strongSelf fetchingAlert:error];
        }
    }];
}


- (void)fetchingAlert:(NSError *)error{
    UIAlertController *alert = [AlertCreator createOkAlert:@"Error loading your routines" message:error.localizedDescription];
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)refreshView:(UIRefreshControl *)refreshControl{
    [self fetchUsersLikedRoutines];
    [self fetchUsersCreatedRoutines];
    [self setProfileInfo];
    [refreshControl endRefreshing];
}


#pragma mark - Button interaction

- (IBAction)didTapSwitchView:(id)sender{
    // If button pressed is the same as the view shown
    if ((sender == self.showCreatedRoutinesButton && self.showCreatedOrLikedRoutinesIndicator == kShowCreatedRoutines) || (sender == self.showLikedRoutinesButton && self.showCreatedOrLikedRoutinesIndicator == kShowLikedRoutines)){
        return;
    }
    
    if (self.showCreatedOrLikedRoutinesIndicator == kShowLikedRoutines){
        self.showCreatedRoutinesButton.selected = YES;
        self.showLikedRoutinesButton.selected = NO;
        self.showCreatedOrLikedRoutinesIndicator = kShowCreatedRoutines;
    } else {
        self.showLikedRoutinesButton.selected = YES;
        self.showCreatedRoutinesButton.selected = NO;
        self.showCreatedOrLikedRoutinesIndicator = kShowLikedRoutines;
    }
    
    [self.routinesTableView reloadData];
}


#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.showCreatedOrLikedRoutinesIndicator == kShowLikedRoutines){
        NSLog(@"%lu", self.likedRoutineList.count);
        return self.likedRoutineList.count;
    } else if (self.showCreatedOrLikedRoutinesIndicator == kShowCreatedRoutines){
        return self.createdRoutineList.count;
    } else {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RoutineTableViewCell *cell = [self.routinesTableView dequeueReusableCellWithIdentifier:kRoutineTableViewCellIdentifier];
    
    if (self.showCreatedOrLikedRoutinesIndicator == kShowLikedRoutines){
        [cell setCellContent:self.likedRoutineList[indexPath.row][kRoutineAttributeKey]];
    } else {
        [cell setCellContent:self.createdRoutineList[indexPath.row]];
    }
    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BOOL isProfileToDetailsSegue = [segue.identifier isEqualToString:kProfileToDetailsSegue];
    if (isProfileToDetailsSegue){
        NSIndexPath *indexPath = [self.routinesTableView indexPathForCell:sender];
        RoutineDetailsViewController *routineDetailsViewController = [segue destinationViewController];
        if (self.showCreatedOrLikedRoutinesIndicator == kShowLikedRoutines){
            routineDetailsViewController.routine = self.likedRoutineList[indexPath.row][kRoutineAttributeKey];
        } else {
            routineDetailsViewController.routine = self.createdRoutineList[indexPath.row];
        }
        RoutineTableViewCell *cell = [self.routinesTableView cellForRowAtIndexPath:indexPath];
        routineDetailsViewController.isLiked = cell.isLiked;
    }
}


@end

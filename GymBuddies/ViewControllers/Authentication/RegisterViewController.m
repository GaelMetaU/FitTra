//
//  RegisterViewController.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/7/22.
//

#import "RegisterViewController.h"
#import "ParseAPIManager.h"
#import "SegmentedControlBlocksValues.h"
#import "CommonValidations.h"
#import "AlertCreator.h"

static NSString * const kEmailKey = @"email";
static NSString * const kPasswordKey = @"password";
static NSString * const kUsernameKey = @"username";
static NSString * const kTrainingLevelKey = @"trainingLevel";
static NSString * const kWorkoutPlaceKey = @"workoutPlace";

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *trainingLevelControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *workoutPlaceControl;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap)];
    [self.view addGestureRecognizer:tap];
}


- (void)singleTap{
    [self.view endEditing:YES];
}


#pragma mark - Buttons interactions

- (IBAction)didTapSubmit:(id)sender {
    
    NSString *email = [CommonValidations standardizeUserAuthInput:self.emailField.text];
    NSString *username = [CommonValidations standardizeUserAuthInput:self.usernameField.text];
    NSString *password = [CommonValidations standardizeUserAuthInput:self.passwordField.text];
    NSString *confirmPassword = [CommonValidations standardizeUserAuthInput:self.confirmPasswordField.text];
    
    if ([self _lookForEmptyFields:username email:email password:password confirmPassword:confirmPassword]){
        UIAlertController *alert = [AlertCreator createOkAlert:@"Empty field(s)" message:@"There is one or more empty fields"];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if (![self _checkPasswordsMatching]){
        UIAlertController *alert = [AlertCreator createOkAlert:@"Password not matching" message:@"Make sure both passwords you provide are the same"];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    TrainingLevels level = [self.trainingLevelControl selectedSegmentIndex];
    
    WorkoutPlace place = [self.workoutPlaceControl selectedSegmentIndex];
    
    PFUser *user = [[PFUser alloc]init];
    user[kEmailKey] = email;
    user[kUsernameKey] = username;
    user[kPasswordKey] = password;
    user[kTrainingLevelKey] = [NSNumber numberWithLong:level];
    user[kWorkoutPlaceKey] = [NSNumber numberWithLong:place];
    
    __weak __typeof(self) weakSelf = self;
    UINavigationController *navigationController = self.navigationController;
    [ParseAPIManager signUp:user completion:^(BOOL succeeded, NSError * _Nonnull error) {
        __strong __typeof(self) strongSelf = weakSelf;
        if (error != nil){
            UIAlertController *alert = [AlertCreator createOkAlert:@"Error registering" message:error.localizedDescription];
            [strongSelf presentViewController:alert animated:YES completion:nil];
        } else {
            [navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

#pragma mark - Validations

    
- (BOOL)_lookForEmptyFields:(NSString *)username
                      email:(NSString *)email
                   password:(NSString *)password
            confirmPassword:(NSString *)confirmPassword {
    return (username.length == 0 || password.length == 0 || confirmPassword == 0 || email.length == 0);
}


- (BOOL)_checkPasswordsMatching{
    NSString *password = self.passwordField.text;
    NSString *confirmPassword = self.confirmPasswordField.text;
    
    return [password isEqualToString:confirmPassword];
}

@end

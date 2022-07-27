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
}


#pragma mark - Buttons interactions

- (IBAction)didTapSubmit:(id)sender {
    
    NSString *email = [CommonValidations standardizeUserAuthInput:self.emailField.text];
    NSString *username = [CommonValidations standardizeUserAuthInput:self.usernameField.text];
    NSString *password = [CommonValidations standardizeUserAuthInput:self.passwordField.text];
    NSString *confirmPassword = [CommonValidations standardizeUserAuthInput:self.confirmPasswordField.text];
    
    if([self _lookForEmptyFields:username email:email password:password confirmPassword:confirmPassword]){
        UIAlertController *alert = [AlertCreator createOkAlert:@"Empty field(s)" message:@"There is one or more empty fields"];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if(![self _checkPasswordsMatching]){
        UIAlertController *alert = [AlertCreator createOkAlert:@"Password not matching" message:@"Make sure both passwords you provide are the same"];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    TrainingLevels level = [self.trainingLevelControl selectedSegmentIndex];
    
    WorkoutPlace place = [self.workoutPlaceControl selectedSegmentIndex];
    
    PFUser *user = [[PFUser alloc]init];
    user[@"email"] = email;
    user[@"username"] = username;
    user[@"password"] = password;
    user[@"trainingLevel"] = [NSNumber numberWithLong:level];
    user[@"workoutPlace"] = [NSNumber numberWithLong:place];
    
    [ParseAPIManager signUp:user completion:^(BOOL succeeded, NSError * _Nonnull error) {
        if(error != nil){
            UIAlertController *alert = [AlertCreator createOkAlert:@"Error registering" message:error.localizedDescription];
            [self presentViewController:alert animated:YES completion:nil];        } else {
            [self.navigationController popViewControllerAnimated:YES];
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


-(BOOL)_checkPasswordsMatching{
    NSString *password = self.passwordField.text;
    NSString *confirmPassword = self.confirmPasswordField.text;
    
    return [password isEqualToString:confirmPassword];
}

@end

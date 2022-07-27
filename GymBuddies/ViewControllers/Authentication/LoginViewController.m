//
//  LoginViewController.m
//  GymBuddies
//
//  Created by Gael Rodriguez Gomez on 7/7/22.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "ParseAPIManager.h"
#import "SceneDelegate.h"
#import "AlertCreator.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - Button outlet actions


- (IBAction)didTapLogin:(id)sender {
    
    if(![self _lookForEmptyFields]){
        NSString *username = self.usernameField.text;
        NSString *password = self.passwordField.text;
        
        
        [ParseAPIManager logIn:username password:password completion:^(PFUser * user, NSError *  error){
            if (error != nil) {
                UIAlertController *alert = [AlertCreator createOkAlert:@"Error logging in" message:error.localizedDescription];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else {
                SceneDelegate *delegate = (SceneDelegate *)self.view.window.windowScene.delegate;
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                delegate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"AppTabController"];
            }
        }];
    }
    else {
        UIAlertController *alert = [AlertCreator createOkAlert:@"Empty field(s)" message:@"There is one or more empty fields"];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


#pragma mark -  Validations

- (BOOL)_lookForEmptyFields{
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;

    return (username.length == 0 || password.length == 0);
}


@end
